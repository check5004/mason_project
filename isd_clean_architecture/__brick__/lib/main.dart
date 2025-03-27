import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

/// -----
/// [概要]   :アプリケーションのエントリーポイント
/// [作成者] :AI Assistant
/// [作成日] :2024/06/29
/// -----
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

/// -----
/// [概要]   :アプリケーションのルートコンポーネント
/// [作成者] :AI Assistant
/// [作成日] :2024/06/29
/// -----
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // appRouterProviderからGoRouterインスタンスを取得
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'New App',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      // GoRouterの設定を適用
      routerConfig: router,
    );
  }
}

/// -----
/// 新しい機能を追加する方法 (TODO)
/// -----
///
/// TODO: このアプリに新しい機能を追加するための手順:
/// 1. lib/routes/ディレクトリに新しい機能用のルーティングファイルを作成
///    - 例: lib/routes/new_feature_router.dart
/// 2. 新しいルーティングファイル内でGoRouteのリストを定義
/// 3. lib/routes/app_router.dartファイルを更新:
///    - 新しいルーティングファイルをインポート
///    - StatefulShellBranchesリストに追加
///    - HomeScreenのBottomNavigationBarにアイテムを追加
/// 4. 必要な画面コンポーネントをlib/presentation/views/ディレクトリに配置
///    - 共通コンポーネント: lib/presentation/views/common/
///    - 機能固有コンポーネント: lib/presentation/views/feature/
/// 5. 状態管理が必要な場合は、対応するViewModelをlib/presentation/view_models/に作成
///
/// 例: 予約管理機能を追加する場合
/// 1. lib/routes/reservations_router.dartを作成
/// 2. lib/presentation/views/feature/reservation/に必要な画面を作成
/// 3. app_router.dartを更新して新しいルートを追加
/// 4. 必要に応じてViewModelを作成
