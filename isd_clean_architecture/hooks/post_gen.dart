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

  // 自動インストールするプラグインのリスト（最新バージョンを使用）
  final pluginsToInstall = [
    // UI/UXコンポーネント
    'material_symbols_icons',
    'awesome_dialog',
    'google_fonts',
    'responsive_grid',
    'shimmer',
    // 状態管理とアーキテクチャ
    'hooks_riverpod',
    'riverpod_annotation',
    'go_router',
    'freezed_annotation',
    'json_annotation',
    // ネットワーク通信
    'dio',
    'retrofit',
    'connectivity_plus',
    // データ操作・保存
    'collection',
    'decimal',
    'shared_preferences',
    'sqflite',
    'path_provider',
    'kana_kit',
    // デバイス機能アクセス
    'image_picker',
    'pro_image_editor',
    'permission_handler',
    'package_info_plus',
    'barcode_scan2',
    'share_plus',
    'native_device_orientation',
    // 開発・デバッグ支援
    'talker_dio_logger',
    'talker_flutter',
    'flutter_launcher_icons',
    'flutter_native_splash',
    'upgrader',
    // 国際化・ローカライゼーション
    'intl',
    'flutter_localization',
  ];

  // 開発依存パッケージ
  final devDependencies = [
    'build_runner',
    'freezed',
    'json_serializable',
    'riverpod_generator',
    'retrofit_generator',
    'flutter_gen_runner',
  ];

  context.logger.info("🔄 プラグインのインストールを開始します...");

  // 通常の依存パッケージをインストール（最新バージョン）
  for (final packageName in pluginsToInstall) {
    context.logger.info("📦 インストール中: $packageName");
    final result = Process.runSync('fvm', ['flutter', 'pub', 'add', packageName]);

    if (result.stdout.toString().isNotEmpty) {
      context.logger.info(result.stdout.toString());
    }

    if (result.stderr.toString().isNotEmpty && !result.stderr.toString().contains('Warning')) {
      context.logger.err("⚠️ $packageName のインストール中にエラーが発生: ${result.stderr}");
    }
  }

  // 開発依存パッケージをインストール
  for (final devPackage in devDependencies) {
    context.logger.info("📦 開発依存パッケージをインストール中: $devPackage");
    final result = Process.runSync('fvm', ['flutter', 'pub', 'add', '--dev', devPackage]);

    if (result.stdout.toString().isNotEmpty) {
      context.logger.info(result.stdout.toString());
    }

    if (result.stderr.toString().isNotEmpty && !result.stderr.toString().contains('Warning')) {
      context.logger.err("⚠️ $devPackage のインストール中にエラーが発生: ${result.stderr}");
    }
  }

  // Flutterパッケージを取得します。
  final pubGet = Process.runSync('fvm', ['flutter', 'pub', 'get']);
  context.logger.info(pubGet.stdout.toString());
  if (pubGet.stderr.toString().isNotEmpty) {
    context.logger.err(pubGet.stderr.toString());
  }

  context.logger.success("✅ Flutterプロジェクトとプラグインのセットアップ完了！");
}
