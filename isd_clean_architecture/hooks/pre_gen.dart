import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context) {
  // 現在のディレクトリパスを取得
  final currentDir = Directory.current;

  // ディレクトリ名を取得（パスの最後の部分）
  final dirName = currentDir.path.split(Platform.pathSeparator).last;

  // varsにproject_nameが未設定の場合や空の場合にディレクトリ名を設定
  if (!context.vars.containsKey('project_name') ||
      context.vars['project_name'] == null ||
      context.vars['project_name'].toString().trim().isEmpty) {
    context.vars['project_name'] = dirName;
    context.logger.info('🔄 出力先ディレクトリ名をプロジェクト名として使用します: $dirName');
  }
}
