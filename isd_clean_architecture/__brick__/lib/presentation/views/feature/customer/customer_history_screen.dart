import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// -----
/// [概要]   :顧客の来店履歴画面を表示するウィジェット
/// [作成者] :AI Assistant
/// [作成日] :2024/06/29
/// -----
class CustomerHistoryScreen extends StatelessWidget {
  /// -----
  /// 顧客履歴画面を構築するコンストラクタ
  ///
  /// 引数:
  /// * [key] - Widgetの識別キー
  /// * [customerId] - 表示する顧客のID
  /// -----
  final String? customerId;

  const CustomerHistoryScreen({super.key, this.customerId});

  /// -----
  /// 画面ビルド処理
  /// -----
  @override
  Widget build(BuildContext context) {
    // ダミーの履歴データ (実際にはViewModelから取得)
    final List<Map<String, String>> historyItems = [
      {'id': '101', 'date': '2024/06/01', 'type': '来店', 'memo': '定期メンテナンス'},
      {'id': '102', 'date': '2024/05/15', 'type': '来店', 'memo': '商品購入 - 腕時計'},
      {'id': '103', 'date': '2024/04/10', 'type': '来店', 'memo': '相談のみ - 新商品について'},
      {'id': '104', 'date': '2024/03/22', 'type': '来店', 'memo': '修理依頼 - ネックレス'},
      {'id': '105', 'date': '2024/02/05', 'type': '来店', 'memo': '商品返品'},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        title: const Text('顧客履歴'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('山田太郎', style: Theme.of(context).textTheme.titleLarge),
                          Text('顧客ID: $customerId', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.push('/customers/$customerId/detail');
                      },
                      child: const Text('詳細'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('来店履歴一覧', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                FilledButton.icon(
                  onPressed: () {
                    context.push('/customers/$customerId/history/new');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('履歴追加'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: historyItems.length,
              itemBuilder: (context, index) {
                final item = historyItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text('${item['date']} - ${item['type']}'),
                    subtitle: Text(item['memo'] ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () {
                            // 履歴詳細画面へ
                            context.push('/customers/$customerId/history/${item['id']}/detail');
                          },
                          tooltip: '詳細',
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // 履歴編集画面へ
                            context.push('/customers/$customerId/history/${item['id']}/detail/edit');
                          },
                          tooltip: '編集',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
