import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'customers_router.dart';
import 'settings_router.dart';

/// アプリケーションのルートナビゲーター用のキー
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// -----
/// [概要]   :アプリケーションのルーティング設定を提供するプロバイダー
/// [作成者] :AI Assistant
/// [作成日] :2024/06/29
/// -----
///
/// このプロバイダーは、アプリケーション全体のナビゲーション構造を定義します。
/// 以下の主要な機能を提供します:
/// * ホーム画面の分岐ナビゲーション
/// * 顧客管理機能へのルーティング
/// * 設定画面へのルーティング
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    routes: [
      StatefulShellRoute.indexedStack(
        pageBuilder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
          return NoTransitionPage(child: HomeScreen(navigationShell: navigationShell));
        },
        branches: [StatefulShellBranch(routes: customerRoutes), StatefulShellBranch(routes: settingRoutes)],
      ),
      GoRoute(path: '/', name: 'home', redirect: (context, state) => '/customers'),
    ],
    initialLocation: '/customers',
  );
});

/// -----
/// ホーム画面コンポーネント
/// -----
///
/// StatefulNavigationShellを使用したボトムナビゲーションを実装するスクリーン
class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '顧客'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定'),
        ],
      ),
    );
  }
}

/// -----
/// 新しい機能をルーティングに追加する方法
/// -----
///
/// TODO: 新しい機能のルーティングを追加するには以下の手順に従ってください:
/// 1. 新しい機能用のルーティングファイル（例: lib/routes/new_feature_router.dart）を作成
/// 2. 新しいファイルで GoRoute のリストを定義
/// 3. app_router.dart にインポートを追加
/// 4. StatefulShellRouteのbranchesリストに新しいStatefulShellBranchを追加
/// 5. HomeScreenのBottomNavigationBarにアイテムを追加
///
/// 例:
/// ```dart
/// // 1. new_feature_router.dart を作成
/// final List<GoRoute> newFeatureRoutes = [
///   GoRoute(
///     path: '/new-feature',
///     name: 'newFeature',
///     builder: (context, state) => const NewFeatureScreen(),
///     routes: [
///       // サブルート
///     ],
///   ),
/// ];
///
/// // 2. app_router.dart にインポートを追加
/// import 'new_feature_router.dart';
///
/// // 3. branches に追加
/// branches: [
///   StatefulShellBranch(routes: customerRoutes),
///   StatefulShellBranch(routes: settingRoutes),
///   StatefulShellBranch(routes: newFeatureRoutes),
/// ],
///
/// // 4. BottomNavigationBar に項目を追加
/// BottomNavigationBarItem(
///   icon: Icon(Icons.new_icon),
///   label: '新機能',
/// ),
/// ```
