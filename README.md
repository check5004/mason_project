# Mason Project

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.0.0-blue.svg?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-blue)](https://flutter.dev)

Masonを使用したFlutterプロジェクトテンプレートのコレクションです。再利用可能なプロジェクト構造やコンポーネントをMasonブリックとして管理しています。

## ⚠️ Windowsでの既知の問題

**重要**: このブリックはWindows環境では完全には動作しません。Windowsで`mason make`を実行すると、`fvm use`コマンドで処理が停止してしまいます。事前にFVMを設定していても同様の問題が発生します。

**Windows環境での代替手順**:

1. まず通常通り`mason make`コマンドを実行して、テンプレートファイルを生成します：
   ```bash
   mason make isd_clean_architecture -o your_project_directory
   ```

2. プロジェクト名などの情報を入力し、ファイル生成処理を開始します。

3. `fvm use`コマンドで処理が止まったら、`Ctrl+C`を押して処理を中断します。
   この時点でテンプレートファイルは生成されていますが、Flutter SDKのセットアップは未完了です。

4. 以下のコマンドを手動で実行して、プロジェクトのセットアップを完了させます：
   ```bash
   cd your_project_directory
   flutter create --platforms=ios,android . --project-name=your_app_name
   ```

5. 必要なパッケージをインストール（フックスクリプト`isd_clean_architecture/hooks/post_gen.dart`に記載されているパッケージリストを参照）：
   ```bash
   flutter pub add hooks_riverpod flutter_hooks riverpod_annotation go_router ...
   flutter pub add --dev build_runner freezed json_serializable riverpod_generator ...
   ```

6. コード生成を実行：
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

詳しくは「トラブルシューティング」セクションをご確認ください。

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

- **Windowsでのプロジェクト生成問題**：
  現在、Windowsプラットフォームでは、`fvm use`コマンドで処理が停止する問題があり、ブリックの自動セットアップが機能しません。この問題は以下の方法で回避できます：

  1. まず`mason make`コマンドを実行してテンプレートファイルを生成し、`fvm use`で処理が止まったら`Ctrl+C`で中断します：
     ```bash
     mason make isd_clean_architecture -o your_project_directory
     # 情報を入力後、fvm useで処理が止まったらCtrl+Cで中断
     cd your_project_directory
     ```

  2. その後、フックスクリプト(`isd_clean_architecture/hooks/post_gen.dart`)を参照して、以下のコマンドを手動で実行：
     ```bash
     # 新しいFlutterプロジェクトを作成
     flutter create --platforms=ios,android . --project-name=your_app_name

     # 必要なパッケージをインストール
     flutter pub add hooks_riverpod flutter_hooks riverpod_annotation
     flutter pub add go_router freezed_annotation json_annotation dio
     flutter pub add retrofit connectivity_plus collection decimal
     flutter pub add shared_preferences sqflite path_provider
     flutter pub add flutter_localization intl
     # その他のパッケージも同様に追加...

     # 開発依存パッケージをインストール
     flutter pub add --dev build_runner freezed json_serializable
     flutter pub add --dev riverpod_generator retrofit_generator
     # その他のパッケージも同様に追加...

     # コード生成を実行
     flutter pub run build_runner build --delete-conflicting-outputs
     ```

  3. macOSまたはLinux環境でプロジェクトを生成し、生成されたコードをWindowsに移行する

  4. WSL (Windows Subsystem for Linux)を使用してLinux環境で実行する

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
