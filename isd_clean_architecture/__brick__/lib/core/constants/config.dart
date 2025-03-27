class Config {
  /// 現在のアプリモード設定
  static const AppEnvironment environment = AppEnvironment.localDevelopment;
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
  static const localDevelopment = AppEnvironment._(name: 'localDevelopment', apiUrl: 'http://127.0.0.1:8080');

  /// 社内開発環境
  static const internalDevelopment = AppEnvironment._(
    name: 'internalDevelopment',
    apiUrl: 'https://dev.api.example.com',
  );

  /// 社内テスト環境
  static const internalTest = AppEnvironment._(name: 'internalTest', apiUrl: 'https://test.api.example.com');

  /// 本番テスト環境
  static const productionTest = AppEnvironment._(name: 'productionTest', apiUrl: 'https://staging.api.example.com');

  /// 本番環境
  static const production = AppEnvironment._(name: 'production', apiUrl: 'https://production.api.example.com');

  /// デモ環境
  static const demo = AppEnvironment._(name: 'demo', apiUrl: 'https://demo.api.example.com');
}

enum AppMode { localDevelopment, internalDevelopment, internalTest, productionTest, production, demo }
