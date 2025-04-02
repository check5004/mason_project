import '../utils/talker_util.dart';

class Config {
  /// 現在のアプリモード設定
  static const AppEnvironment environment = AppEnvironment.internalDev;

  /// ページングのデフォルト取得件数
  static const int defaultPageLimit = 20;

  /// Talkerのログ設定
  static const TalkerConfig talkerConfig = TalkerConfig(
    enableRiverpodLogs: false, // Riverpodのログを有効にするかどうか
  );
}

/// アプリの環境設定を管理するクラス
class AppEnvironment {
  /// 環境名
  final String name;

  /// API URL
  final String apiUrl;

  /// コンストラクタ
  const AppEnvironment._({required this.name, required this.apiUrl});

  /// ローカル開発環境
  static const localDev = AppEnvironment._(name: 'localDev', apiUrl: 'http://127.0.0.1:8080'); //TODO: URLを設定

  /// 社内開発環境
  static const internalDev = AppEnvironment._(
    name: 'internalDev',
    apiUrl: 'https://eaetyibtqobfmgeztmxq.supabase.co/functions/v1', //TODO: URLを設定 ※Masonテスト用Supabase公開API(アカウント所有者：楯)
  );

  /// 社内テスト環境
  static const internalTest = AppEnvironment._(
    name: 'internalTest',
    apiUrl: 'https://test.api.example.com',
  ); //TODO: URLを設定

  /// 本番テスト環境
  static const productionTest = AppEnvironment._(
    name: 'productionTest',
    apiUrl: 'https://staging.api.example.com',
  ); //TODO: URLを設定

  /// 本番環境
  static const production = AppEnvironment._(
    name: 'production',
    apiUrl: 'https://production.api.example.com',
  ); //TODO: URLを設定

  /// デモ環境
  static const demo = AppEnvironment._(name: 'demo', apiUrl: 'https://demo.api.example.com'); //TODO: URLを設定
}
