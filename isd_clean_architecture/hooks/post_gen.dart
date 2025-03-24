import 'dart:io';
import 'package:mason/mason.dart';

/// -----------------------------------------------
/// [概要]   : Flutterプロジェクトのセットアップを行う関数
/// [作成者] : TCC S.Tate
/// [作成日] : 2025/03/24
/// -----------------------------------------------
void run(HookContext context) {
  // プロジェクト名を取得します。未設定の場合はデフォルト値を使用します。
  final projectName = context.vars['project_name'] ?? 'my_flutter_app';

  // 使用するFlutterのバージョンを取得します。未設定の場合はデフォルト値を使用します。
  final flutterVersion = context.vars['flutter_version'] ?? 'stable';

  // 対応するプラットフォームを取得します。未設定の場合はデフォルト値を使用します。
  final platforms = context.vars['platforms'] as String? ?? 'ios,android';

  context.logger.info("🔄 設定されたFlutterバージョン: $flutterVersion");
  context.logger.info("🔄 サポートするプラットフォーム: $platforms");
  context.logger.info("🔄 プロジェクト名: $projectName");

  // FVMを使用してFlutterバージョンを設定します。
  final fvmSetup = Process.runSync('fvm', ['use', flutterVersion]);
  context.logger.info(fvmSetup.stdout.toString());
  if (fvmSetup.stderr.toString().isNotEmpty) {
    context.logger.err(fvmSetup.stderr.toString());
  }

  // 現在のディレクトリにFlutterプロジェクトを作成します。
  final flutterCreate = Process.runSync(
    'fvm',
    ['flutter', 'create', '--platforms=$platforms', '.', '--project-name=$projectName'],
  );
  context.logger.info(flutterCreate.stdout.toString());
  if (flutterCreate.stderr.toString().isNotEmpty) {
    context.logger.err(flutterCreate.stderr.toString());
  }

  // Flutterパッケージを取得します。
  final pubGet = Process.runSync('fvm', ['flutter', 'pub', 'get']);
  context.logger.info(pubGet.stdout.toString());
  if (pubGet.stderr.toString().isNotEmpty) {
    context.logger.err(pubGet.stderr.toString());
  }

  context.logger.success("✅ Flutterプロジェクトのセットアップ完了！");
}
