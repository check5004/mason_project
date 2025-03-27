import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils/com_util.dart';
import '../utils/message_util.dart';
import '../utils/network_util.dart';

part 'dio_interceptor.freezed.dart';
part 'dio_interceptor.g.dart';

/// ダイアログデータ
@freezed
abstract class DialogData with _$DialogData {
  const factory DialogData({
    required String message,
    required DialogType dialogType,
    @Default(false) bool hideOkButton,

    /// ダイアログを閉じる
    /// trueで更新するとhomeScreenのpopでダイアログを閉じる
    @Default(false) bool onDialogClose,
  }) = _DialogData;
}

/// ダイアログデータのプロバイダー
@riverpod
class DialogDataState extends _$DialogDataState {
  @override
  DialogData? build() => null;

  /// ダイアログデータを設定
  void set(DialogData data) {
    state = data;
  }

  /// ダイアログデータをクリア
  void clear() {
    state = null;
  }
}

/// -----------------------------------------------
/// [概要]   :Dioのエラーハンドリングを行うインターセプター
/// [作成者] :TCC S.Tate
/// [作成日] :2024/12/25
/// -----------------------------------------------
class ErrorInterceptor extends Interceptor {
  /// コンストラクタ
  ///
  /// 引数:
  /// * [ref] - Riverpodのプロバイダー参照オブジェクト
  final Ref ref;

  ErrorInterceptor(this.ref);

  /// -----------------------------------------------
  /// リクエストのインターセプト
  /// -----------------------------------------------
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // ネットワーク接続確認用のリクエストの場合は特別処理
    if (options.headers.containsKey('X-Network-Connectivity-Check')) {
      // 接続確認リクエストなのでサーバーに送信せず、成功レスポンスを返す
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          statusMessage: 'OK',
          data: {'status': 'connected', 'code': '0'},
        ),
        true,
      );
    }

    // ネットワーク接続チェック
    final isConnected = await NetworkUtil.checkAndWaitForConnectivity(ref: ref, timeoutSeconds: -1);

    // ネットワーク接続がない場合はエラーを返す
    if (!isConnected) {
      return handler.reject(
        DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: 503,
            statusMessage: MessageUtil.message.networkUnavailable,
          ),
          type: DioExceptionType.connectionError,
          message: MessageUtil.message.networkNotAvailable,
        ),
        true,
      );
    }

    return handler.next(options);
  }

  /// -----------------------------------------------
  /// レスポンス処理のインターセプト
  /// -----------------------------------------------
  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    // エラー送信用リクエストの場合はスキップ（例: URLで判定）
    if (response.requestOptions.path.contains('/common/ErrorSend')) {
      return handler.next(response);
    }
    String? code;
    String? message;
    DialogType? dialogType;
    try {
      code = response.data['code'] as String? ?? response.data['result_status']['status'] as String?;
    } catch (_) {}
    try {
      message = ComUtil.convertBlankToNull(
        response.data['msg'] as String? ?? response.data['result_status']['msg'] as String?,
      );
    } catch (_) {}

    switch (code) {
      case '0':
        dialogType = DialogType.info;
        if (message?.contains('完了しました') ?? false) {
          //TODO: ごり押しsuccess判断をなんとかする
          dialogType = DialogType.success;
        }
        break;
      case '1':
        dialogType = DialogType.error;
        break;
      case '9':
        dialogType = DialogType.error;
        // String str = 'サーバーエラーが発生しました。\nシステム管理者にお問い合わせください。\n[$code: $message]'; //TODO: エラー送信を有効にする
        // await MailUtil.sendError(str); //TODO: エラー送信を有効にする
        message = MessageUtil.message.serverError;
    }

    // ダイアログデータを設定
    // メッセージがある場合はダイアログを表示
    if (message != null && message.isNotEmpty) {
      ref
          .read(dialogDataStateProvider.notifier)
          .set(DialogData(message: message, dialogType: dialogType ?? DialogType.error));
    }

    super.onResponse(response, handler);
  }

  /// -----------------------------------------------
  /// エラー処理のインターセプト
  /// -----------------------------------------------
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // エラー送信用リクエストの場合はスキップ（例: URLで判定）
    if (err.requestOptions.path.contains('/common/ErrorSend')) {
      return handler.next(err);
    }

    final code = ComUtil.convertBlankToNull(err.response?.statusCode.toString());
    var message = ComUtil.convertBlankToNull(err.response?.statusMessage) ?? MessageUtil.message.serverError;
    var dialogType = DialogType.error;

    // タイムアウト関連のエラーかどうかチェック
    bool isTimeoutError =
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionTimeout;

    switch (code) {
      case '401':
        message = '${MessageUtil.message.authError}\n再度ログインしてください。';
        break;
      case '403':
        message = MessageUtil.message.accessDenied;
        break;
      case '503':
        if (err.response?.statusMessage?.isNotEmpty ?? false) {
          message = err.response!.statusMessage.toString();
          break;
        }
      default:
        // タイムアウト関連のエラーは特別処理
        if (isTimeoutError) {
          // タイムアウトエラーの場合はユーザーフレンドリーなメッセージを表示
          message = MessageUtil.message.timeoutError;
        } else {
          // その他のサーバーエラーの場合はメール送信
          message =
              '${MessageUtil.message.serverError}\nシステム管理者にお問い合わせください。\n[${err.response?.statusCode}: ${err.response?.statusMessage}]';
          // MailUtil.sendError(message); //TODO: エラー送信を有効にする
        }
    }

    // ダイアログデータを設定
    // メッセージがある場合はダイアログを表示
    if (message.isNotEmpty && code != null) {
      ref.read(dialogDataStateProvider.notifier).set(DialogData(message: message, dialogType: dialogType));
    }

    // エラーを伝播させる（タイムアウトエラーも含めて全てのエラーを適切に伝播）
    handler.reject(err);
  }
}
