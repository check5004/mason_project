import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/api_config.dart';
import '../../core/utils/talker_util.dart';

part 'auth_token_storage.g.dart';

/// -----
/// [概要]   :認証トークンを管理するプロバイダー
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/25
/// -----
@Riverpod(keepAlive: true)
class AuthToken extends _$AuthToken {
  @override
  String? build() => null;

  /// トークンを設定（通常はログイン時などに呼び出す）
  void setToken(String token) {
    talker.info('認証トークンを設定しました');
    state = token;
  }

  /// トークンをクリア（ログアウト時などに呼び出す）
  void clearToken() {
    talker.info('認証トークンをクリアしました');
    state = null;
  }

  /// トークンが存在するかチェック
  bool get hasToken => state != null;

  /// ベアラートークンの形式で取得
  String? get bearerToken {
    if (state == null) return null;
    return 'Bearer $state';
  }

  /// 現在のトークンを取得
  String? get currentToken => state;

  /// デモ用のトークンをセット
  void setDemoToken() {
    talker.info('デモ用認証トークンを設定しました');
    setToken(ApiConfig.actualApiToken);
  }
}
