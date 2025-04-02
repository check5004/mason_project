import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/api_config.dart';
import '../../data/local/auth_token_storage.dart';
import '../utils/talker_util.dart';

part 'auth_interceptor.g.dart';

/// -----
/// [概要]   :認証トークンをリクエストに付与するインターセプター
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/25
/// -----
///
/// Dioのインターセプターとして使用し、すべてのAPIリクエストに認証ヘッダーを自動的に付与します
class AuthInterceptor extends Interceptor {
  final AuthToken? _authToken;
  final bool _useDemoToken;

  AuthInterceptor({AuthToken? authToken, bool useDemoToken = true})
    : _authToken = authToken,
      _useDemoToken = useDemoToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _getToken();

    if (token != null) {
      options.headers['Authorization'] = token;
      talker.debug('認証ヘッダーを付与: ${options.uri}');
    } else {
      talker.warning('認証トークンがありません: ${options.uri}');
    }

    super.onRequest(options, handler);
  }

  /// 認証トークンを取得
  String? _getToken() {
    // StateNotifierが提供されている場合はそこからトークンを取得
    if (_authToken != null && _authToken.hasToken) {
      return _authToken.bearerToken;
    }

    // StateNotifierがない、またはトークンがない場合でデモトークンを使う設定ならデモトークンを返す
    if (_useDemoToken) {
      return ApiConfig.actualApiToken;
    }

    return null;
  }
}

/// -----
/// [概要]   :認証インターセプターのプロバイダー
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/25
/// -----
@riverpod
AuthInterceptor authInterceptor(Ref ref) {
  final authToken = ref.watch(authTokenProvider.notifier);
  return AuthInterceptor(authToken: authToken);
}
