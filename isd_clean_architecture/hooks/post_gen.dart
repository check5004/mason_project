import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context) {
  final projectName = context.vars['project_name'] ?? 'my_flutter_app';
  final flutterVersion = context.vars['flutter_version'] ?? 'stable';
  final platforms = context.vars['platforms'] as String? ?? 'ios,android';

  context.logger.info("🔄 設定されたFlutterバージョン: $flutterVersion");
  context.logger.info("🔄 サポートするプラットフォーム: $platforms");
  context.logger.info("🔄 プロジェクト名: $projectName");

  // FVMを使用してFlutterバージョンを設定
  final fvmSetup = Process.runSync('fvm', ['use', flutterVersion]);
  context.logger.info(fvmSetup.stdout.toString());
  if (fvmSetup.stderr.toString().isNotEmpty) {
    context.logger.err(fvmSetup.stderr.toString());
  }

  // flutter create を現在のディレクトリに実行
  final flutterCreate = Process.runSync(
    'fvm',
    ['flutter', 'create', '--platforms=$platforms', '.', '--project-name=$projectName'],
  );
  context.logger.info(flutterCreate.stdout.toString());
  if (flutterCreate.stderr.toString().isNotEmpty) {
    context.logger.err(flutterCreate.stderr.toString());
  }

  // Flutterパッケージの取得
  final pubGet = Process.runSync('fvm', ['flutter', 'pub', 'get']);
  context.logger.info(pubGet.stdout.toString());
  if (pubGet.stderr.toString().isNotEmpty) {
    context.logger.err(pubGet.stderr.toString());
  }

  context.logger.success("✅ Flutterプロジェクトのセットアップ完了！");
}
