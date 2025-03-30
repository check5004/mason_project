# {{project_name}} 🚀

[![Flutter](https://img.shields.io/badge/Flutter-{{flutter_version}}-blue.svg?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/platform-{{platforms_badge}}-blue)](https://docs.flutter.dev/reference/create-new-app)
[![Style: Lint](https://img.shields.io/badge/style-lint-4BC0F5.svg)](https://pub.dev/packages/lint)

## 概要 📋

{{project_name}}は、クリーンアーキテクチャとRiverpodを用いたFlutterアプリケーションです。このプロジェクトは再利用可能なコンポーネントと一貫性のあるコーディング規約に基づいて構築されています。

## 特徴 ✨

- **クリーンアーキテクチャ**: データ、ドメイン、プレゼンテーションレイヤーに分離された設計
- **状態管理**: Riverpodを使用した効率的な状態管理
- **ルーティング**: Go Routerによるシンプルで型安全なルーティング
- **データモデル**: Freezedによる不変オブジェクトモデル
- **API通信**: DioとRetrofitを使用したRESTful API通信
- **エラーハンドリング**: 統一的なエラー処理と表示の仕組み
- **ローカルストレージ**: SharedPreferencesとSQFliteによるデータ永続化
- **ユーティリティ**: 再利用可能なユーティリティクラスとウィジェット

## 開発ドキュメント 📚

詳細な開発ガイドとリファレンスドキュメントを提供しています：

- [**プラグイン一覧**](./docs/plugins.md) - 使用しているプラグインの詳細な解説
- [**クリーンアーキテクチャガイド**](./docs/clean_architecture.md) - プロジェクト構造とアーキテクチャの詳細解説
- [**Riverpodによる状態管理**](./docs/riverpod_guide.md) - MVVMパターンとRiverpodの使用方法
- [**APIインテグレーション**](./docs/api_integration.md) - RetrofitとDioを使用したAPI連携の実装方法

## セットアップ 🛠️

### 必要条件

- Flutter {{flutter_version}}
- Dart SDK
- Android Studio または Visual Studio Code

### インストール

1. リポジトリをクローン:

```bash
git clone https://github.com/yourusername/{{project_name}}.git
cd {{project_name}}
```

2. 依存関係のインストール:

```bash
flutter pub get
```

3. コードの生成:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. アプリの実行:

```bash
flutter run
```

## プロジェクト構造 🏗️

```
lib/
  ├── main.dart            # アプリケーションのエントリーポイント
  ├── core/                # アプリケーションのコア機能
  │   ├── constants/       # 定数とアプリケーション設定
  │   ├── exceptions/      # 例外クラス
  │   ├── network/         # ネットワーク関連（インターセプターなど）
  │   └── utils/           # ユーティリティ関数
  ├── data/                # データレイヤー
  │   ├── datasources/     # データソース（APIクライアントなど）
  │   ├── models/          # データモデル（Freezedモデルなど）
  │   ├── repositories/    # リポジトリの実装
  │   └── local/           # ローカルデータ関連
  ├── domain/              # ドメインレイヤー
  │   ├── entities/        # ドメインエンティティ
  │   ├── repositories/    # リポジトリのインターフェース
  │   └── use_cases/       # ビジネスロジックをカプセル化
  ├── presentation/        # プレゼンテーションレイヤー
  │   ├── view_models/     # ViewModel（Riverpodによる状態管理）
  │   ├── views/           # 画面単位のView
  │   └── widgets/         # 再利用可能なカスタムWidget
  ├── di/                  # 依存性注入
  └── routes/              # ルーティング(go_router)
```

## 使用している主なパッケージ 📦

- **UI/UX**: flex_color_scheme, material_symbols_icons, awesome_dialog, google_fonts
- **状態管理**: hooks_riverpod, riverpod_annotation
- **ルーティング**: go_router
- **データ処理**: freezed, json_serializable
- **ネットワーク通信**: dio, retrofit, connectivity_plus
- **ローカルストレージ**: shared_preferences, sqflite
- **開発ツール**: talker_flutter, talker_dio_logger

## コーディング規約 📏

- **命名規則**: パスカルケース（クラス）、キャメルケース（変数・メソッド）
- **ファイル名**: スネークケース
- **状態管理**: Riverpodのみを使用し、setState使用は避ける
- **テスト**: ビジネスロジックには単体テストを作成
