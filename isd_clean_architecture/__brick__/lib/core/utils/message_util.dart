import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_util.g.dart';

/// -----------------------------------------------
/// グローバルナビゲーターキー
/// アプリケーション全体で使用できるNavigatorKey
/// -----------------------------------------------
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// -----------------------------------------------
/// [概要]   :メッセージ管理用のユーティリティクラス
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/27
/// -----------------------------------------------
class MessageUtil {
  // 現在アクティブなメッセージ文字列を管理するリスト
  static final List<String> _activeMsgs = [];

  /// -----------------------------------------------
  /// メッセージダイアログの表示状態を確認
  ///
  /// 戻り値：
  /// * アクティブなメッセージが存在する場合はtrue
  /// -----------------------------------------------
  static bool isMsgDialogShown() {
    return _activeMsgs.isNotEmpty;
  }

  /// -----------------------------------------------
  /// 指定されたメッセージがアクティブ状態かを確認
  ///
  /// * [msg] : チェック対象のメッセージ
  ///
  /// 戻り値：
  /// * メッセージがアクティブな場合はtrue
  /// -----------------------------------------------
  static bool isMsgActive(String msg) {
    return _activeMsgs.contains(msg);
  }

  /// -----------------------------------------------
  /// アクティブメッセージリストにメッセージを追加
  ///
  /// * [msg] : 追加するメッセージ
  /// -----------------------------------------------
  static void addMsg(String msg) {
    _activeMsgs.add(msg);
  }

  /// -----------------------------------------------
  /// アクティブメッセージリストからメッセージを削除
  ///
  /// * [msg] : 削除するメッセージ
  /// -----------------------------------------------
  static void removeMsg(String msg) {
    _activeMsgs.remove(msg);
  }

  /// -----------------------------------------------
  /// プレースホルダーを置換してメッセージを取得
  ///
  /// * [message] : 元のメッセージ
  /// * [placeholders] : 置換する値のリスト
  ///
  /// 戻り値：
  /// * 置換後のメッセージ
  /// -----------------------------------------------
  static String format(String message, {List<String>? placeholders}) {
    if (placeholders == null || placeholders.isEmpty) return message;

    String result = message;
    // {0}, {1}, ... を順番に置換
    for (int i = 0; i < placeholders.length; i++) {
      result = result.replaceAll('{$i}', placeholders[i]);
    }
    return result;
  }

  /// -----------------------------------------------
  /// メッセージ定数を取得するヘルパーメソッド
  /// -----------------------------------------------
  static Message get message => Message();

  /// -----------------------------------------------
  /// 有効なBuildContextを取得
  ///
  /// * [context] : オプショナルなBuildContext
  ///
  /// 戻り値：
  /// * 有効なBuildContext
  /// * contextが渡された場合はその値を返す
  /// * contextが渡されなかった場合はグローバルなnavigatorKeyから取得
  /// -----------------------------------------------
  static BuildContext? _getContext(BuildContext? context) {
    // 渡されたcontextが有効な場合はそれを使用
    if (context != null && context.mounted) return context;

    // グローバルなnavigatorKeyからcontextを取得
    return navigatorKey.currentContext;
  }

  /// -----------------------------------------------
  /// シンプルなメッセージダイアログを表示
  ///
  /// * [context] : BuildContextはオプション
  /// * [title] : ダイアログのタイトル
  /// * [msg] : 表示するメッセージ
  /// * [btnText] : OKボタンのテキスト
  /// * [dialogType] : ダイアログのタイプ
  /// * [width] : ダイアログの幅 (デフォルトは500)
  /// * [hideOkButton] : OKボタンを非表示にするかどうか
  ///
  /// 戻り値：
  /// * ダイアログが正常に表示され、OKボタンが押された場合はtrue
  /// -----------------------------------------------
  static Future<bool> showMsgDialog({
    BuildContext? context,
    required String title,
    required String msg,
    String? btnText = 'OK',
    DialogType dialogType = DialogType.info,
    double width = 500,
    bool hideOkButton = false,
  }) async {
    final ctx = _getContext(context);
    if (ctx == null) return false;

    bool result = false;
    final combinedMsg = '$title$msg';
    late StreamSubscription<List<ConnectivityResult>> subscription;

    // メッセージがアクティブならダイアログを表示しない
    if (isMsgActive(combinedMsg)) return false;
    addMsg(combinedMsg); // アクティブ判定用

    // Completerを使用してダイアログの完了を待つ
    final completer = Completer<void>();

    // ダイアログを表示
    AwesomeDialog(
      context: ctx,
      dialogType: dialogType,
      title: title,
      desc: msg,
      btnOkText: btnText,
      btnOk: hideOkButton ? const SizedBox.shrink() : null,
      width: width,
      btnOkOnPress: () {
        if (completer.isCompleted) return; // 連打防止
        result = true;
        completer.complete();
      },
      dismissOnTouchOutside: false, // 周りタップで閉じない
      dismissOnBackKeyPress: false, // バックキーで閉じない
    ).show();

    // ネットワークに接続できない場合は、接続状態を監視
    if (msg == message.networkUnavailable) {
      subscription = Connectivity().onConnectivityChanged.listen(
        (List<ConnectivityResult> results) {
          // 接続が確立されている場合
          if (!results.contains(ConnectivityResult.none) && results.isNotEmpty) {
            subscription.cancel(); // 接続状態の監視を終了

            // ネットワークが利用できない場合は、ダイアログを閉じる
            // ignore: use_build_context_synchronously
            final currentContext = _getContext(context);
            if (currentContext != null &&
                currentContext.mounted &&
                Navigator.of(currentContext, rootNavigator: true).canPop()) {
              Navigator.of(currentContext, rootNavigator: true).pop();
              if (!completer.isCompleted) {
                completer.complete();
              }
            }
          }
        },
        cancelOnError: false, // エラーが発生しても監視を継続
      );
    }

    // ダイアログが閉じるまで待つ
    await completer.future;

    removeMsg(combinedMsg); // アクティブ判定用
    return result;
  }

  /// -----------------------------------------------
  /// 確認ダイアログを表示
  ///
  /// * [context] : BuildContextはオプション
  /// * [title] : ダイアログのタイトル
  /// * [msg] : 確認メッセージ
  /// * [noText] : 「いいえ」ボタンのテキスト
  /// * [yesText] : 「はい」ボタンのテキスト
  /// * [reverseBtnOrder] : ボタンの順番を逆にするかどうか
  /// * [dialogType] : ダイアログのタイプ
  /// * [width] : ダイアログの幅 (デフォルトは500)
  ///
  /// 戻り値：
  /// * 「はい」が選択された場合はtrue、それ以外はfalse
  /// -----------------------------------------------
  static Future<bool> showConfirmDialog({
    BuildContext? context,
    String? title = '確認',
    String? msg,
    String? noText = 'キャンセル',
    String? yesText = 'OK',
    bool reverseBtnOrder = false,
    DialogType dialogType = DialogType.info,
    double width = 500,
  }) async {
    final ctx = _getContext(context);
    if (ctx == null) return false;

    bool result = false;

    // ダイアログを表示
    await AwesomeDialog(
      context: ctx,
      dialogType: dialogType,
      title: title,
      desc: msg,
      btnCancelText: noText,
      btnOkText: yesText,
      width: width,
      reverseBtnOrder: reverseBtnOrder,
      btnCancelOnPress: () => result = false,
      btnOkOnPress: () => result = true,
      dismissOnTouchOutside: false, // 周りタップで閉じない
      dismissOnBackKeyPress: false, // バックキーで閉じない
    ).show();

    return result;
  }
}

/// -----------------------------------------------
/// [概要]   :メッセージ定数クラス
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/27
/// -----------------------------------------------
class Message {
  // 必須入力
  final String requiredField = '{0}を入力してください。';
  // 入力エラー
  final String invalidInput = '{0}の入力に誤りがあります。';
  // ネットワーク関連
  final String networkUnavailable = 'ネットワークに接続できません。\n(モバイル通信、Wi-Fi接続をONにしてください。)';
  final String networkNotAvailable = 'ネットワーク接続がありません。';
  final String networkRetryLimit = '通信エラーが発生しました。\n接続状態をご確認ください。';
  final String networkError = '通信エラーが発生しました。\n接続状態をご確認ください。';
  final String timeoutError = 'サーバー接続タイムアウトエラー';
  final String networkReconnected = 'ネットワーク接続が復旧しました。\n再度操作を行ってください。';
  // サーバー関連
  final String serverError = 'サーバーエラーが発生しました。';
  // 認証
  final String authError = '認証に失敗しました。';
  final String accessDenied = 'アクセス権限がありません。';
  // アップデート
  final String updateRequired = 'アプリのバージョンが更新されました。\nアップデートをお願いします。';
  // 確認ダイアログ
  final String confirmMove = '{0}へ移動します。よろしいですか？';
  // ログアウト関連
  final String logoutSuccess = 'ログアウトしました。';
  final String logoutConfirm = 'ログアウトしますか？';
  // 担当者配分率チェック
  final String invalidTantoshaRate = '担当者の配分率は合計100でなければなりません。';
  // 必須項目チェック
  final String requiredFields = '未入力の必須項目があります。';
  // 日付チェック
  final String dateError = '不正な日付が入力されています。';
}

/// -----------------------------------------------
/// [概要]   :ダイアログデータモデル
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/27
/// -----------------------------------------------
class DialogData {
  final String message;
  final DialogType dialogType;
  final bool hideOkButton;

  DialogData({required this.message, required this.dialogType, this.hideOkButton = false});
}

/// -----------------------------------------------
/// [概要]   :ダイアログ管理状態プロバイダー
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/27
/// -----------------------------------------------
@riverpod
class DialogState extends _$DialogState {
  @override
  DialogData? build() {
    return null;
  }

  void showDialog(DialogData data) {
    state = data;
  }

  void hideDialog() {
    state = null;
  }
}
