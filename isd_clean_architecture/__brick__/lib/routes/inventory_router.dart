import 'package:go_router/go_router.dart';

import '../presentation/views/feature/inventory/inventory_detail_screen.dart';
import '../presentation/views/feature/inventory/inventory_search_screen.dart';

/// -----
/// [概要]   :在庫管理機能の画面遷移を定義するルーティング設定
/// [作成者] :AI Assistant
/// [作成日] :2024/06/29
/// -----
///
/// 在庫管理機能の画面遷移を定義します。
/// 以下の機能を含みます:
/// * 在庫一覧/検索画面
/// * 在庫詳細画面
final List<GoRoute> inventoryRoutes = [
  GoRoute(
    path: '/inventory',
    name: 'inventory',
    builder: (context, state) => const InventorySearchScreen(),
    routes: [
      GoRoute(
        path: ':id',
        name: 'inventoryDetail',
        builder: (context, state) {
          final productId = state.pathParameters['id'];
          return InventoryDetailScreen(id: productId);
        },
      ),
    ],
  ),
];
