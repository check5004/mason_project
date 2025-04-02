/// -----
/// [概要]   :認証結果を表すエンティティクラス
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/25
/// -----
///
/// 認証処理の結果を表すデータクラス
class AuthResult {
  /// 認証が成功したかどうか
  final bool isSuccess;

  /// 認証トークン（認証成功時のみ有効）
  final String? token;

  /// エラーメッセージ（認証失敗時のみ有効）
  final String? errorMessage;

  const AuthResult({required this.isSuccess, this.token, this.errorMessage});

  /// 認証成功の結果を作成
  factory AuthResult.success(String token) {
    return AuthResult(isSuccess: true, token: token, errorMessage: null);
  }

  /// 認証失敗の結果を作成
  factory AuthResult.failure(String errorMessage) {
    return AuthResult(isSuccess: false, token: null, errorMessage: errorMessage);
  }
}
