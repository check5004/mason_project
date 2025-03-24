# Mason Project

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)

Masonを使用したFlutterプロジェクトテンプレートのコレクションです。このリポジトリでは、再利用可能なプロジェクト構造やコンポーネントをMasonブリックとして管理しています。

## 概要

このリポジトリには、Flutterアプリケーション開発を迅速に始めるための様々なブリックテンプレートが含まれています。Masonブリックを使用することで、ボイラープレートコードの作成時間を削減し、一貫性のあるコードベースを維持できます。

## 含まれるブリック

現在、このリポジトリには以下のブリックが含まれています：

| ブリック名 | 説明 | パス |
|------------|------|------|
| [isd_clean_architecture](./isd_clean_architecture/README.md) | クリーンアーキテクチャに基づいたFlutterアプリケーションのテンプレート | `isd_clean_architecture` |

## 前提条件

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- [Mason CLI](https://github.com/felangel/mason/tree/master/packages/mason_cli#installation)

## セットアップ手順

### 1. Mason CLIのインストール

```bash
# Masonをグローバルにインストール
dart pub global activate mason_cli
```

### 2. ブリックの使用

各ブリックの詳細な使用方法は、それぞれのREADMEを参照してください。以下は、isd_clean_architectureブリックの使用例です。

#### isd_clean_architectureブリックの使用

```bash
# ブリックをグローバルにインストール
mason add -g isd_clean_architecture --git-url https://github.com/check5004/mason_project --git-path isd_clean_architecture

# プロジェクトを作成
mason make isd_clean_architecture -o ~/path/to/your_project_directory
```

詳細な手順と設定オプションについては、[isd_clean_architectureのREADME](./isd_clean_architecture/README.md)を参照してください。

## 固定リンク

以下のコマンドで直接isd_clean_architectureブリックをインストールできます：

```bash
# 固定リンクを使用したインストール
mason add -g isd_clean_architecture --git-url https://github.com/check5004/mason_project --git-path isd_clean_architecture
```

## 実行ステップの概要

1. Mason CLIをインストール: `dart pub global activate mason_cli`
2. 目的のブリックをインストール: `mason add -g <ブリック名> --git-url https://github.com/check5004/mason_project --git-path <ブリックのパス>`
3. ブリックを使用してプロジェクトを生成: `mason make <ブリック名> -o <出力先ディレクトリ>`
4. プロンプトに従って必要な情報を入力
5. 生成されたプロジェクトのディレクトリに移動: `cd <出力先ディレクトリ>`
6. 依存関係をインストール: `flutter pub get`
7. 必要に応じてコード生成を実行: `flutter pub run build_runner build --delete-conflicting-outputs`
8. アプリを実行: `flutter run`

## トラブルシューティング

ブリックのインストールや使用中に問題が発生した場合は、各ブリックのREADMEに記載されているトラブルシューティングセクションを参照してください。一般的な問題としては、同名のブリックが既にインストールされている場合の上書き確認などがあります。

## 貢献

このリポジトリへの貢献を歓迎します。新しいブリックの追加や既存ブリックの改善については、Pull Requestを作成してください。

## ライセンス

このプロジェクトは[LICENSE](./LICENSE)ファイルに記載されたライセンスの下で公開されています。
