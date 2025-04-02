import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/api_config.dart';
import '../../core/utils/talker_util.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../local/auth_token_storage.dart';

part 'auth_repository_impl.g.dart';

/// -----
/// [概要]   :認証リポジトリのプロバイダー
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/25
/// -----
///
/// `AuthRepository`の実装を提供するRiverpodプロバイダー。
/// `keepAlive: true` により、アプリケーションのライフサイクル中に状態が保持される。
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  // AuthTokenプロバイダーのnotifier（状態変更メソッドを持つクラス）を取得
  final authToken = ref.watch(authTokenProvider.notifier);
  // AuthRepositoryImplのインスタンスを作成し、AuthTokenを依存性注入
  return AuthRepositoryImpl(authToken);
}

/// -----
/// [概要]   :認証リポジトリの実装クラス
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/25
/// -----
///
/// `AuthRepository`インターフェースを実装し、実際の認証処理ロジックを提供します。
/// この実装は、ローカルのトークンストレージ(`AuthToken`)に依存します。
/// デモアプリのため、実際のAPI呼び出しはモック化されています。
class AuthRepositoryImpl implements AuthRepository {
  // ローカルでの認証トークン管理を行うAuthTokenクラスのインスタンス
  final AuthToken _authToken;

  /// `AuthRepositoryImpl`のコンストラクタ
  ///
  /// [authToken] 認証トークンを管理する`AuthToken`インスタンス
  AuthRepositoryImpl(this._authToken);

  /// ログイン処理を実行します。
  ///
  /// [username] ユーザー名
  /// [password] パスワード
  ///
  /// 戻り値:
  /// * 認証結果(`AuthResult`)を含むFuture
  ///
  /// NOTE: デモアプリのため、実際のAPI通信は行わず、常に成功として固定トークンを設定します。
  @override
  Future<AuthResult> login(String username, String password) async {
    talker.info('ログイン処理を実行: $username');

    try {
      // 本来はここでAPIを呼び出し、ユーザー名とパスワードで認証を行う
      // 成功した場合、APIから返却されたトークンを取得する

      // デモ用: 固定のトークンを使用
      final token = ApiConfig.actualApiToken;
      // 取得したトークンをローカルストレージに保存
      _authToken.setToken(token);

      // 成功結果とトークンを返す
      return AuthResult.success(token);
    } catch (e, stackTrace) {
      // エラーが発生した場合、ログに出力
      talker.error('ログイン処理に失敗しました', e, stackTrace);
      // 失敗結果とエラーメッセージを返す
      return AuthResult.failure('認証に失敗しました');
    }
  }

  /// ログアウト処理を実行します。
  ///
  /// ローカルに保存されている認証トークンをクリアします。
  @override
  Future<void> logout() async {
    talker.info('ログアウト処理を実行');
    // ローカルストレージからトークンを削除
    _authToken.clearToken();
    // ログアウト処理は通常、サーバー側への通知も伴う場合があるが、ここではローカルのみ
  }

  /// ユーザーが現在認証済みかどうかを確認します。
  ///
  /// 戻り値:
  /// * 認証済みであれば`true`、そうでなければ`false`を返すFuture
  @override
  Future<bool> isAuthenticated() async {
    // ローカルストレージにトークンが存在するかどうかで認証状態を判断
    return _authToken.hasToken;
  }

  /// 現在保存されている認証トークンを取得します。
  ///
  /// 戻り値:
  /// * 認証トークン文字列、またはトークンが存在しない場合は`null`を返すFuture
  @override
  Future<String?> getToken() async {
    // ローカルストレージから現在のトークンを取得
    return _authToken.currentToken;
  }

  /// デモ用の認証処理を実行します。
  ///
  /// 実際のAPI通信を行わず、固定のデモ用トークンを設定して成功として扱います。
  ///
  /// 戻り値:
  /// * デモ認証の結果(`AuthResult`)を含むFuture
  @override
  Future<AuthResult> demoAuthenticate() async {
    talker.info('デモ認証を実行');
    try {
      // デモ用の固定トークンを取得
      final token = ApiConfig.actualApiToken;
      // デモ用トークンをローカルストレージに設定
      _authToken.setToken(token);

      // 成功結果とトークンを返す
      return AuthResult.success(token);
    } catch (e, stackTrace) {
      // エラーが発生した場合、ログに出力
      talker.error('デモ認証に失敗しました', e, stackTrace);
      // 失敗結果とエラーメッセージを返す
      return AuthResult.failure('デモ認証に失敗しました');
    }
  }
}
