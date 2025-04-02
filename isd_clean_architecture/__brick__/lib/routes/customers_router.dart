import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/views/feature/customer/customer_detail_screen.dart';
import '../presentation/views/feature/customer/customer_edit_screen.dart';
import '../presentation/views/feature/customer/customer_history_screen.dart';
import '../presentation/views/feature/customer/customer_search_screen.dart';

/// -----
/// [概要]   :顧客関連の画面遷移を定義するルーティング設定
/// [作成者] :AI Assistant
/// [作成日] :2024/06/29
/// -----
///
/// 顧客管理機能の画面遷移を定義します。
/// 以下の機能を含みます:
/// * 顧客一覧/検索画面
/// * 顧客詳細画面
/// * 顧客新規登録/編集画面
/// * 顧客履歴画面
final List<GoRoute> customerRoutes = [
  GoRoute(
    path: '/customers',
    name: 'customers',
    builder: (context, state) => const CustomerSearchScreen(),
    routes: [
      GoRoute(path: 'new', name: 'newCustomer', builder: (context, state) => const CustomerEditScreen(isNew: true)),
      GoRoute(
        path: ':customerId/detail',
        name: 'customerDetail',
        builder: (context, state) {
          final customerId = state.pathParameters['customerId'];
          return CustomerDetailScreen(customerId: customerId);
        },
        routes: [
          GoRoute(
            path: 'edit',
            name: 'editCustomer',
            builder: (context, state) {
              final customerId = state.pathParameters['customerId'];
              return CustomerEditScreen(customerId: customerId);
            },
          ),
        ],
      ),
      GoRoute(
        path: ':customerId/history',
        name: 'customerHistory',
        builder: (context, state) {
          final customerId = state.pathParameters['customerId'];
          return CustomerHistoryScreen(customerId: customerId);
        },
        routes: [
          GoRoute(
            path: 'new',
            name: 'newHistory',
            builder: (context, state) {
              final customerId = state.pathParameters['customerId'];
              // 履歴新規登録画面は未実装のため、一時的にダミー画面を表示
              return Scaffold(
                appBar: AppBar(title: const Text('来店記録登録')),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('顧客ID: $customerId の来店記録登録'),
                      ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('戻る')),
                    ],
                  ),
                ),
              );
            },
          ),
          GoRoute(
            path: ':historyId/detail',
            name: 'historyDetail',
            builder: (context, state) {
              final customerId = state.pathParameters['customerId'];
              final historyId = state.pathParameters['historyId'];
              // 履歴詳細画面は未実装のため、一時的にダミー画面を表示
              return Scaffold(
                appBar: AppBar(title: const Text('来店記録詳細')),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('顧客ID: $customerId の来店記録 $historyId の詳細'),
                      ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('戻る')),
                    ],
                  ),
                ),
              );
            },
            routes: [
              GoRoute(
                path: 'edit',
                name: 'editHistory',
                builder: (context, state) {
                  final customerId = state.pathParameters['customerId'];
                  final historyId = state.pathParameters['historyId'];
                  // 履歴編集画面は未実装のため、一時的にダミー画面を表示
                  return Scaffold(
                    appBar: AppBar(title: const Text('来店記録編集')),
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('顧客ID: $customerId の来店記録 $historyId の編集'),
                          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('戻る')),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
