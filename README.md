# Mason Project

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.0.0-blue.svg?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-blue)](https://flutter.dev)

Masonを使用したFlutterプロジェクトテンプレートのコレクションです。再利用可能なプロジェクト構造やコンポーネントをMasonブリックとして管理しています。

## プロジェクト概要

このリポジトリは、Flutterアプリケーション開発のためのテンプレートをMasonブリックとして提供します。Masonブリックを使用することで、ボイラープレートコードの作成時間を削減し、一貫性のあるコードベースを維持できます。

### 提供しているブリック

| ブリック名 | 説明 | 機能 |
|------------|------|------|
| [isd_clean_architecture](./isd_clean_architecture/README.md) | クリーンアーキテクチャベースのFlutterアプリテンプレート | ・プロジェクト構造の自動生成<br>・必要なパッケージの自動インストール<br>・コード生成の設定 |

## セットアップガイド

### 前提条件

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- [Mason CLI](https://github.com/felangel/mason/tree/master/packages/mason_cli#installation)

### 1. Mason CLIのインストール

```bash
# Masonをグローバルにインストール
dart pub global activate mason_cli
```

### 2. テンプレートの使用方法

#### 方法1: GitHubリポジトリから直接インストール（推奨）

```bash
# ブリックをグローバルにインストール
mason add -g isd_clean_architecture --git-url https://github.com/check5004/mason_project --git-path isd_clean_architecture

# プロジェクトを生成
mason make isd_clean_architecture -o ~/path/to/your_project_directory
```

#### 方法2: ローカルリポジトリからインストール（開発者向け）

```bash
# リポジトリをクローン
git clone https://github.com/check5004/mason_project
cd mason_project

# ブリックをグローバルにインストール
mason add -g isd_clean_architecture --path ./isd_clean_architecture

# プロジェクトを生成
mason make isd_clean_architecture -o ~/path/to/your_project_directory
```

### 3. プロジェクト生成後の手順

プロジェクト生成時に表示されるプロンプトに従って必要な情報を入力すると、以下の手順が自動的に実行されます：

1. Flutterプロジェクトの作成
2. 必要なパッケージのインストール
3. プロジェクト構造の設定
4. コード生成の初期設定

生成後、以下のコマンドを実行してプロジェクトを完全にセットアップします：

```bash
# プロジェクトディレクトリに移動
cd your_project_directory

# 必要に応じてコード生成を実行
flutter pub run build_runner build --delete-conflicting-outputs

# アプリを実行
flutter run
```

## ブリックの詳細

### isd_clean_architecture

クリーンアーキテクチャに基づいたFlutterアプリケーションの雛形を生成します。

**主な機能：**
- プロジェクト名、Flutterバージョン、対応プラットフォームをカスタマイズ可能
- 推奨パッケージの自動インストール
- クリーンアーキテクチャに基づいたディレクトリ構造の自動生成
- VSCode設定の自動セットアップ

詳細な情報と設定オプションについては、[isd_clean_architectureのREADME](./isd_clean_architecture/README.md)を参照してください。

## トラブルシューティング

### よくある問題

- **ブリックのインストールで競合が発生する場合**：
  ```
  conflict: /Users/.../isd_clean_architecture
  Overwrite isd_clean_architecture? (y/N)
  ```
  `y`を入力して上書きすることで最新バージョンのブリックを使用できます。

- **プロジェクト生成時のファイル競合**：
  新規プロジェクトの場合は、空のディレクトリを出力先として指定することをお勧めします。

## 貢献

このリポジトリへの貢献を歓迎します。新しいブリックの追加や既存ブリックの改善については、Pull Requestを作成してください。

## ライセンス

このプロジェクトは[LICENSE](./LICENSE)ファイルに記載されたライセンスの下で公開されています。
