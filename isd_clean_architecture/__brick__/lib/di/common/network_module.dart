import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

import '../../core/constants/config.dart';
import '../../core/network/auth_interceptor.dart';
import '../../core/network/custom_talker_logger.dart';
import '../../core/utils/talker_util.dart';

part 'network_module.g.dart';

/// -----
/// [概要]   :基本のDioインスタンスを提供するプロバイダー
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/25
/// -----
///
/// API接続に必要な基本設定を施したDioインスタンスを提供します
@riverpod
Dio dio(Ref ref) {
  final dio = Dio();

  // ベースURLを設定
  dio.options.baseUrl = Config.environment.apiUrl;

  // タイムアウト設定
  dio.options.connectTimeout = const Duration(seconds: 30); // リクエストタイムアウト
  dio.options.receiveTimeout = const Duration(seconds: 90); // レスポンスタイムアウト

  // デフォルトヘッダーの設定
  dio.options.headers = {'Content-Type': 'application/json', 'Accept': 'application/json'};

  // インターセプターの追加
  final authInterceptor = ref.watch(authInterceptorProvider);
  dio.interceptors.add(authInterceptor);

  // デバッグモードの場合はログインターセプターを追加
  dio.interceptors.add(
    CustomTalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: false,
        printResponseHeaders: false,
        printResponseMessage: true,
      ),
      // フィルタリングするエラータイプを指定
      filteredErrorTypes: const [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ],
    ),
  );

  return dio;
}
