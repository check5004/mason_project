import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// カスタムTalkerDioLoggerインターセプター
/// 特定のエラータイプをフィルタリングする機能を提供
class CustomTalkerDioLogger extends Interceptor {
  final Talker talker;
  final TalkerDioLoggerSettings settings;
  final TalkerDioLogger _originalLogger;

  /// フィルタリングするエラータイプのリスト
  final List<DioExceptionType> filteredErrorTypes;

  CustomTalkerDioLogger({
    required this.talker,
    this.settings = const TalkerDioLoggerSettings(),
    this.filteredErrorTypes = const [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
    ],
  }) : _originalLogger = TalkerDioLogger(talker: talker, settings: settings);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _originalLogger.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _originalLogger.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // フィルタリング対象のエラータイプの場合はWarningとしてログ出力
    if (filteredErrorTypes.contains(err.type)) {
      // エラーではなく警告ログとして出力
      talker.warning('【Filtered】Dio Error (${err.type}): ${err.message}');
    } else {
      // 通常のエラーとして処理
      _originalLogger.onError(err, handler);

      // 処理継続
      handler.next(err);
    }
  }
}
