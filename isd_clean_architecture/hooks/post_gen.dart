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
  context.logger.info("🔄 プロジェクト名: $projectName\n");

  // fvmのチェック
  final fvmCheck = Process.runSync('fvm', ['--version']);
  if (fvmCheck.exitCode != 0) {
    context.logger.err('fvmが見つかりません');
    throw Exception('fvmが見つかりません。セットアップを中止します。');
  } else {
    context.logger.info('fvmが見つかりました: ${fvmCheck.stdout}');
  }

  // FVMを使用してFlutterバージョンを設定します。
  final fvmInstall = Process.runSync('fvm', ['install', flutterVersion]);
  context.logger.info(fvmInstall.stdout.toString());
  if (fvmInstall.stderr.toString().isNotEmpty) {
    context.logger.err(fvmInstall.stderr.toString());
  }
  final fvmSetup = Process.runSync('fvm', ['use', flutterVersion]);
  context.logger.info(fvmSetup.stdout.toString());
  if (fvmSetup.stderr.toString().isNotEmpty) {
    context.logger.err(fvmSetup.stderr.toString());
  }

  // 必要なコマンドの存在を確認します
  final commands = [
    ['fvm', '--version'],
    ['fvm', 'flutter', '--version'],
    ['dart', '--version'],
    ['mason', '--version'],
  ];

  // 各コマンドの存在チェック
  for (final command in commands) {
    try {
      // バージョンコマンドを実行してコマンドが機能するか確認
      final result = Process.runSync(
        command[0],
        command.sublist(1),
      );

      if (result.exitCode != 0) {
        context.logger.err('${command.join(" ")}コマンドが正常に動作しません');
        throw Exception('必要なコマンド ${command.join(" ")} が正常に動作しません。セットアップを中止します。');
      }

      context.logger.info('${command.join(" ")}コマンドの動作を確認しました: ${result.stdout}');
    } catch (e) {
      context.logger.err('${command.join(" ")}コマンドの確認中にエラーが発生しました:');
      context.logger.err(e.toString());
      throw Exception('必要なコマンド ${command.join(" ")} が正常に動作しません。セットアップを中止します。');
    }
  }

  // インストール結果の追跡用変数
  int successCount = 0;
  int failureCount = 0;
  int warningCount = 0;
  final List<String> failedPackages = [];
  final List<String> warningPackages = [];

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
    // 国際化・ローカライゼーション
    'flutter_localization',
    'intl',
    // UI/UXコンポーネント
    'flex_color_scheme',
    'material_symbols_icons',
    'awesome_dialog',
    'google_fonts',
    'responsive_grid',
    'shimmer',
    // 状態管理とアーキテクチャ
    'hooks_riverpod',
    'flutter_hooks',
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
    'talker_flutter',
    'talker_dio_logger',
    'talker_riverpod_logger',
    'flutter_launcher_icons',
    'flutter_native_splash',
    'upgrader',
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
  final buildRunner =
      Process.runSync('fvm', ['flutter', 'pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs']);
  context.logger.info(buildRunner.stdout.toString());

  bool buildRunnerSuccess = true;
  String buildRunnerMessage = "";

  if (buildRunner.stderr.toString().isNotEmpty) {
    final stderrOutput = buildRunner.stderr.toString();
    // 無視する警告のリスト
    final ignoredWarnings = ['Specified build.yaml as input but the file does not exists', 'FlutterGen'];

    // 無視する警告が含まれているかチェック
    bool containsIgnoredWarning = ignoredWarnings.any((warning) => stderrOutput.contains(warning));

    if (stderrOutput.contains('Warning') || containsIgnoredWarning) {
      context.logger.info("ℹ️ build_runner からの情報: ${stderrOutput}");
      buildRunnerMessage = "ℹ️ build_runner の出力を確認してください";
    } else if (stderrOutput.contains('Error') || stderrOutput.contains('Exception')) {
      context.logger.err("❌ build_runner 実行中にエラーが発生: ${stderrOutput}");
      buildRunnerSuccess = false;
      buildRunnerMessage = "❌ build_runner 実行中にエラーが発生しました";
    } else {
      // その他のエラー出力は情報として扱う
      context.logger.info("ℹ️ build_runner からの出力: ${stderrOutput}");
    }
  }

  // APIトークン設定ファイルの生成
  context.logger.info("🔄 APIトークン設定ファイルを生成中...");
  try {
    final sourceFile = File('lib/core/constants/api_config.dart.example');
    final targetFile = File('lib/core/constants/api_config.dart');

    if (sourceFile.existsSync()) {
      sourceFile.copySync(targetFile.path);
      context.logger.info("✅ api_config.dartを生成しました\n　 このファイルでsupabaseのAPIトークンを設定してください");
    } else {
      context.logger.err("❌ api_config.dart.exampleが見つかりません");
    }
  } catch (e) {
    context.logger.err("❌ api_config.dartの生成中にエラーが発生しました: $e");
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
  context.logger.info("----------------------------\n");

  // 最終的な成功メッセージ
  if (failureCount > 0 || !buildRunnerSuccess) {
    context.logger.success("✅ セットアッププロセスは完了しましたが、一部問題が発生しています。");
  } else if (warningCount > 0 || buildRunnerMessage.contains("警告")) {
    context.logger.success("✅ セットアッププロセスは完了しましたが、一部警告があります。");
  } else {
    context.logger.success("✅ すべてのセットアップが正常に完了しました！");
  }
  context.logger.info("");
}
