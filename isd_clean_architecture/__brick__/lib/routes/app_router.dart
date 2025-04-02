import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../core/utils/talker_util.dart';
import '../presentation/views/common/home_screen.dart';
import 'customers_router.dart';
import 'inventory_router.dart';
import 'settings_router.dart';

/// アプリケーションのルートナビゲーター用のキー
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// -----
/// [概要]   :アプリケーションのルーティング設定を提供するプロバイダー
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/25
/// -----
///
/// このプロバイダーは、アプリケーション全体のナビゲーション構造を定義します。
/// 以下の主要な機能を提供します:
/// * ホーム画面の分岐ナビゲーション
/// * 顧客管理機能へのルーティング
/// * 在庫管理機能へのルーティング
/// * 設定画面へのルーティング
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    observers: [TalkerRouteObserver(talker)],
    routes: [
      StatefulShellRoute.indexedStack(
        pageBuilder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
          return NoTransitionPage(child: HomeScreen(navigationShell: navigationShell));
        },
        branches: [
          StatefulShellBranch(routes: customerRoutes),
          StatefulShellBranch(routes: inventoryRoutes),
          StatefulShellBranch(routes: settingRoutes),
        ],
      ),
      GoRoute(path: '/', name: 'home', redirect: (context, state) => '/customers'),
      GoRoute(path: '/logs', name: 'logs', builder: (context, state) => TalkerScreen(talker: talker)),
    ],
    initialLocation: '/customers',
  );
});
