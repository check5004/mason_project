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

## 使い方

```bash
# グローバルに追加
mason add -g isd_clean_architecture --path .

# Flutterプロジェクトを作成（出力先ディレクトリは自動的に作成されます）
mason make isd_clean_architecture -o ~/path/to/your_project_directory
```

プロンプトに従って情報を入力すると、指定したディレクトリにクリーンアーキテクチャ構成のFlutterプロジェクトが作成されます。

### 便利な機能

- **出力先ディレクトリ名をプロジェクト名として使用**: `-o`オプションで指定したディレクトリ名が、デフォルトのプロジェクト名として使用されます。例えば、`mason make isd_clean_architecture -o ~/Downloads/my_awesome_app`を実行すると、プロジェクト名のデフォルト値として「my_awesome_app」が提案されます。
