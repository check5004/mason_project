import '../entities/auth_result.dart';

/// -----
/// [概要]   :認証リポジトリのインターフェース
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/25
/// -----
///
/// 認証処理を行うための抽象インターフェース
abstract class AuthRepository {
  /// ログイン処理
  ///
  /// [username] ユーザー名
  /// [password] パスワード
  Future<AuthResult> login(String username, String password);

  /// ログアウト処理
  Future<void> logout();

  /// 認証状態の確認
  Future<bool> isAuthenticated();

  /// 認証トークンの取得
  Future<String?> getToken();

  /// デモ用の認証を実行
  ///
  /// 実際のAPIを呼び出さず、ハードコードされたトークンで認証成功とする
  Future<AuthResult> demoAuthenticate();
}
