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

  // インストール結果の追跡用変数
  int successCount = 0;
  int failureCount = 0;
  int warningCount = 0;
  final List<String> failedPackages = [];
  final List<String> warningPackages = [];

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
    'flex_color_scheme',
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
    final currentIndex = pluginsToInstall.indexOf(packageName) + 1;
    context.logger.info("📦 インストール中($currentIndex/${pluginsToInstall.length}): $packageName");
    final result = Process.runSync('fvm', ['flutter', 'pub', 'add', packageName]);

    if (result.stdout.toString().isNotEmpty) {
      context.logger.info(result.stdout.toString());
    }

    final stderrOutput = result.stderr.toString();
    if (stderrOutput.isNotEmpty) {
      if (stderrOutput.contains('Warning')) {
        context.logger.warn("⚠️ $packageName のインストール中に警告が発生: ${stderrOutput}");
        warningCount++;
        warningPackages.add(packageName);
      } else {
        context.logger.err("❌ $packageName のインストール中にエラーが発生: ${stderrOutput}");
        failureCount++;
        failedPackages.add(packageName);
      }
    } else {
      successCount++;
    }
  }

  // 開発依存パッケージをインストール
  for (final devPackage in devDependencies) {
    final currentIndex = devDependencies.indexOf(devPackage) + 1;
    context.logger.info("📦 開発依存パッケージをインストール中($currentIndex/${devDependencies.length}): $devPackage");
    final result = Process.runSync('fvm', ['flutter', 'pub', 'add', '--dev', devPackage]);

    if (result.stdout.toString().isNotEmpty) {
      context.logger.info(result.stdout.toString());
    }

    final stderrOutput = result.stderr.toString();
    if (stderrOutput.isNotEmpty) {
      if (stderrOutput.contains('Warning')) {
        context.logger.warn("⚠️ $devPackage のインストール中に警告が発生: ${stderrOutput}");
        warningCount++;
        warningPackages.add(devPackage);
      } else {
        context.logger.err("❌ $devPackage のインストール中にエラーが発生: ${stderrOutput}");
        failureCount++;
        failedPackages.add(devPackage);
      }
    } else {
      successCount++;
    }
  }

  // Flutterパッケージを取得します。
  final pubGet = Process.runSync('fvm', ['flutter', 'pub', 'get']);
  context.logger.info(pubGet.stdout.toString());
  if (pubGet.stderr.toString().isNotEmpty) {
    context.logger.err(pubGet.stderr.toString());
  }

  // ビルドランナーを実行してコード生成を行います
  context.logger.info("🔄 build_runner を実行中...");
  final buildRunner = Process.runSync(
    'fvm',
    ['flutter', 'pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs']
  );
  context.logger.info(buildRunner.stdout.toString());

  bool buildRunnerSuccess = true;
  String buildRunnerMessage = "";

  if (buildRunner.stderr.toString().isNotEmpty) {
    final stderrOutput = buildRunner.stderr.toString();
    if (stderrOutput.contains('Warning')) {
      context.logger.warn("⚠️ build_runner 実行中に警告が発生: ${stderrOutput}");
      buildRunnerMessage = "⚠️ build_runner 実行中に警告が発生しました";
    } else {
      context.logger.err("❌ build_runner 実行中にエラーが発生: ${stderrOutput}");
      buildRunnerSuccess = false;
      buildRunnerMessage = "❌ build_runner 実行中にエラーが発生しました";
    }
  }

  // インストール結果の総括
  final totalPackages = pluginsToInstall.length + devDependencies.length;
  context.logger.info("\n📊 プラグインインストール結果");
  context.logger.info("----------------------------");
  context.logger.info("✅ 成功: $successCount / $totalPackages");

  if (warningCount > 0) {
    context.logger.warn("⚠️ 警告: $warningCount パッケージ");
    context.logger.warn("   警告が発生したパッケージ: ${warningPackages.join(', ')}");
  }

  if (failureCount > 0) {
    context.logger.err("❌ 失敗: $failureCount パッケージ");
    context.logger.err("   インストールに失敗したパッケージ: ${failedPackages.join(', ')}");
    context.logger.info("----------------------------");
    context.logger.warn("⚠️ 注意: いくつかのパッケージのインストールに問題が発生しました。");
    context.logger.warn("  手動でインストールするか、依存関係の競合を解決してください。");
  } else if (warningCount > 0) {
    context.logger.info("----------------------------");
    context.logger.warn("⚠️ 注意: いくつかのパッケージにバージョン競合の警告が発生しました。");
  }
  context.logger.info("----------------------------");

  // build_runnerの結果をレポート
  context.logger.info("\n📊 build_runner 実行結果");
  context.logger.info("----------------------------");
  if (buildRunnerSuccess) {
    context.logger.info("✅ build_runner によるコード生成が完了しました");
  } else {
    context.logger.err(buildRunnerMessage);
  }
  context.logger.info("----------------------------");

  // 最終的な成功メッセージ
  if (failureCount > 0 || !buildRunnerSuccess) {
    context.logger.success("✅ セットアッププロセスは完了しましたが、一部問題が発生しています。");
  } else if (warningCount > 0 || buildRunnerMessage.contains("警告")) {
    context.logger.success("✅ セットアッププロセスは完了しましたが、一部警告があります。");
  } else {
    context.logger.success("✅ すべてのセットアップが正常に完了しました！");
  }
}
