# isd_clean_architecture

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
Mason CLIを使用して作成された新しいブリックです。

_生成元: [mason][1] 🧱_

## はじめに 🚀

これは新しいブリックの出発点です。
これが初めてのブリックテンプレートである場合、始めるためのいくつかのリソースを紹介します：

- [公式Masonドキュメント][2]
- [Masonによるコード生成ブログ][3]
- [Very Good Livestream: Felix AngelovがMasonをデモ][4]
- [今週のFlutterパッケージ: Mason][5]
- [Observable Flutter: Masonブリックの構築][6]
- [Masonに会おう: Flutter Vikings 2022][7]

[1]: https://github.com/felangel/mason
[2]: https://docs.brickhub.dev
[3]: https://verygood.ventures/blog/code-generation-with-mason
[4]: https://youtu.be/G4PTjA6tpTU
[5]: https://youtu.be/qjA0JFiPMnQ
[6]: https://youtu.be/o8B1EfcUisw
[7]: https://youtu.be/LXhgiF5HiQg

## インストール方法 📥

### 方法1: GitHubリポジトリから直接インストール（グローバル）

```bash
# Masonがインストールされていない場合は先にインストール
dart pub global activate mason_cli

# グローバルにブリックを追加（-gオプションを必ず追加）
mason add -g isd_clean_architecture --git-url https://github.com/check5004/mason_project --git-path isd_clean_architecture
```

> **注意**: 同名のブリックが既にインストールされている場合、以下のように上書き確認が表示されます:
> ```
> conflict: /Users/.../isd_clean_architecture
> Overwrite isd_clean_architecture? (y/N) y
> ```
> この場合、最新バージョンをインストールするために `y` を入力してEnterキーを押してください。キャンセルする場合は `N` を入力するか、Enterキーを押してください。

### 方法2: プロジェクト内でローカルにインストール

```bash
# Masonがインストールされていない場合は先にインストール
dart pub global activate mason_cli

# プロジェクトディレクトリを作成して移動
mkdir my_flutter_project
cd my_flutter_project

# Masonの初期化（これによりmason.yamlが作成されます）
mason init

# ローカルにブリックを追加
mason add isd_clean_architecture --git-url https://github.com/check5004/mason_project --git-path isd_clean_architecture

# ブリックをインストール
mason get
```

### 方法3: ローカル開発用（開発者向け）

```bash
# リポジトリをクローン
git clone https://github.com/check5004/mason_project
cd mason_project

# グローバルに追加
mason add -g isd_clean_architecture --path ./isd_clean_architecture
```

## 使い方 🚀

```bash
# グローバルインストールした場合は任意のディレクトリで実行可能
mason make isd_clean_architecture -o ~/path/to/your_project_directory

# ローカルインストールした場合は、mason.yamlのあるディレクトリで実行
cd my_flutter_project  # mason.yamlがあるディレクトリ
mason make isd_clean_architecture -o ./my_app
```

> **注意**: 出力先ディレクトリが既に存在する場合、ファイルの上書き確認のプロンプトが表示されることがあります。新規プロジェクトの場合は新しい空のディレクトリを指定することをお勧めします。

プロンプトに従って情報を入力すると、指定したディレクトリにクリーンアーキテクチャ構成のFlutterプロジェクトが作成されます。

### 便利な機能

- **出力先ディレクトリ名をプロジェクト名として使用**: `-o`オプションで指定したディレクトリ名が、デフォルトのプロジェクト名として使用されます。例えば、`mason make isd_clean_architecture -o ~/Downloads/my_awesome_app`を実行すると、プロジェクト名のデフォルト値として「my_awesome_app」が提案されます。

## トラブルシューティング 🔧

### 上書き確認について

- **ブリックのインストール時**: `mason add` コマンド実行時に、すでに同名のブリックがインストールされていると以下のメッセージが表示されます：
  ```
  conflict: /Users/.../isd_clean_architecture
  Overwrite isd_clean_architecture? (y/N)
  ```
  - `y` を入力: 既存のブリックを最新バージョンで上書きします（推奨）
  - `N` を入力またはEnterを押す: 既存のブリックをそのまま使用します

- **プロジェクト生成時**: `mason make` コマンド実行時に、出力先に既存のファイルがある場合、それらのファイルを上書きするかどうかの確認が表示されることがあります。新しいプロジェクトを作成する場合は、空のディレクトリを指定することをお勧めします。

## セットアップ手順の概要 🔍

### グローバルインストールを使用する場合（推奨）

1. Mason CLIをインストール: `dart pub global activate mason_cli`
2. ブリックをグローバルにインストール: `mason add -g isd_clean_architecture --git-url https://github.com/check5004/mason_project --git-path isd_clean_architecture`
3. プロジェクトを作成: `mason make isd_clean_architecture -o プロジェクト作成先パス`
4. プロンプトに従って必要な情報を入力
5. 作成されたプロジェクトディレクトリに移動: `cd プロジェクト作成先パス`
6. Flutterパッケージを取得: `flutter pub get`
7. コード生成を実行: `flutter pub run build_runner build --delete-conflicting-outputs`
8. アプリを実行: `flutter run`

### ローカルインストールを使用する場合

1. Mason CLIをインストール: `dart pub global activate mason_cli`
2. プロジェクトディレクトリを作成: `mkdir my_flutter_project && cd my_flutter_project`
3. Masonを初期化: `mason init`
4. ブリックをローカルに追加: `mason add isd_clean_architecture --git-url https://github.com/check5004/mason_project --git-path isd_clean_architecture`
5. ブリックをインストール: `mason get`
6. ブリックを使用してアプリを生成: `mason make isd_clean_architecture -o ./my_app`
7. 以降、上記の手順5〜8と同様

## 自動インストールされるプラグイン 📦

このブリックではプロジェクト作成時に以下のプラグインが自動的にインストールされます。すべてのプラグインは最新バージョンでインストールされます。

### UI/UXコンポーネント
- flex_color_scheme
- material_symbols_icons
- awesome_dialog
- google_fonts
- responsive_grid
- shimmer

### 状態管理とアーキテクチャ
- hooks_riverpod
- riverpod_annotation
- go_router
- freezed_annotation
- json_annotation

### ネットワーク通信
- dio
- retrofit
- connectivity_plus

### データ操作・保存
- collection
- decimal
- shared_preferences
- sqflite
- path_provider
- kana_kit

### デバイス機能アクセス
- image_picker
- pro_image_editor
- permission_handler
- package_info_plus
- barcode_scan2
- share_plus
- native_device_orientation

### 開発・デバッグ支援
- talker_dio_logger
- talker_flutter
- flutter_launcher_icons
- flutter_native_splash
- upgrader

### 国際化・ローカライゼーション
- intl
- flutter_localization

### 開発依存パッケージ
- build_runner
- freezed
- json_serializable
- riverpod_generator
- retrofit_generator
- flutter_gen_runner

> **注意**: `responsive_framework`, `webview_flutter`, `talker_riverpod_logger`, `widgetbook`, `flutter_staggered_animations`, `local_hero` などのプラグインは「おすすめプラグイン」として位置づけられているため、自動インストールの対象から意図的に除外しています。これらのプラグインはプロジェクトの要件に応じて手動でインストールしてください。追加方法： `flutter pub add プラグイン名`
