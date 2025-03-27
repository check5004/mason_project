import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      ),
    ],
  ),
];

/// -----
/// 顧客検索画面 (プレースホルダー)
/// -----
class CustomerSearchScreen extends StatelessWidget {
  const CustomerSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('顧客検索')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('顧客検索画面'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.push('/customers/new');
              },
              child: const Text('新規顧客登録'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push('/customers/123/detail');
              },
              child: const Text('顧客詳細表示（サンプル）'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/customers/new');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// -----
/// 顧客詳細画面 (プレースホルダー)
/// -----
class CustomerDetailScreen extends StatelessWidget {
  final String? customerId;

  const CustomerDetailScreen({super.key, this.customerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('顧客詳細')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('顧客ID: $customerId の詳細画面'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.push('/customers/$customerId/edit');
              },
              child: const Text('顧客情報編集'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push('/customers/$customerId/history');
              },
              child: const Text('来店履歴表示'),
            ),
          ],
        ),
      ),
    );
  }
}

/// -----
/// 顧客編集画面 (プレースホルダー)
/// -----
class CustomerEditScreen extends StatelessWidget {
  final bool isNew;
  final String? customerId;

  const CustomerEditScreen({super.key, this.isNew = false, this.customerId});

  @override
  Widget build(BuildContext context) {
    final title = isNew ? '顧客新規登録' : '顧客情報編集';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isNew ? '新規顧客情報入力' : '顧客ID: $customerId の情報編集'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 保存後、前の画面に戻る
                context.pop();
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}

/// -----
/// 顧客履歴画面 (プレースホルダー)
/// -----
class CustomerHistoryScreen extends StatelessWidget {
  final String? customerId;

  const CustomerHistoryScreen({super.key, this.customerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('来店履歴')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('顧客ID: $customerId の来店履歴'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('戻る'),
            ),
          ],
        ),
      ),
    );
  }
}

/// -----
/// 新しい顧客関連機能の追加方法
/// -----
///
/// TODO: 顧客機能に新しい画面やフローを追加するには:
/// 1. 新しい画面クラスを作成する (lib/presentation/views/feature/customer/ などに配置)
/// 2. customerRoutesリストに新しいGoRouteエントリを追加
/// 3. 必要に応じて、既存のルートの子ルートとして設定
///
/// 例:
/// ```dart
/// // 顧客インポート機能を追加する場合
/// GoRoute(
///   path: 'import',
///   name: 'importCustomers',
///   builder: (context, state) => const CustomerImportScreen(),
/// ),
/// 
/// // 顧客詳細の子ルートとして分析機能を追加する場合
/// GoRoute(
///   path: 'analytics',
///   name: 'customerAnalytics',
///   builder: (context, state) {
///     final customerId = state.pathParameters['customerId'];
///     return CustomerAnalyticsScreen(customerId: customerId);
///   }, 
/// ),
/// ``` 