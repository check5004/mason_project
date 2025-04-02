import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// -----
/// [概要]   :顧客詳細画面を表示するウィジェット
/// [作成者] :AI Assistant
/// [作成日] :2024/06/29
/// -----
class CustomerDetailScreen extends StatelessWidget {
  /// -----
  /// 顧客詳細画面を構築するコンストラクタ
  ///
  /// 引数:
  /// * [key] - Widgetの識別キー
  /// * [customerId] - 表示する顧客のID
  /// -----
  final String? customerId;

  const CustomerDetailScreen({super.key, this.customerId});

  /// -----
  /// 画面ビルド処理
  /// -----
  @override
  Widget build(BuildContext context) {
    // ダミーデータ (実際にはViewModelから取得)
    final customer = {
      'id': customerId,
      'name': '山田太郎',
      'phone': '090-1234-5678',
      'address': '東京都新宿区新宿1-1-1',
      'email': 'yamada@example.com',
      'birthday': '1980/01/01',
      'lastVisit': '2024/06/01',
      'notes': '特記事項なし',
    };

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        title: const Text('顧客詳細'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push('/customers/$customerId/edit');
            },
            tooltip: '編集',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomerInfoCard(context, customer),
              const SizedBox(height: 16),
              _buildActionButtons(context),
              const SizedBox(height: 16),
              _buildHistorySection(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 顧客情報カードを構築
  Widget _buildCustomerInfoCard(BuildContext context, Map<String, dynamic> customer) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('基本情報', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInfoRow('顧客ID', customer['id'] ?? ''),
            _buildInfoRow('顧客名', customer['name'] ?? ''),
            _buildInfoRow('電話番号', customer['phone'] ?? ''),
            _buildInfoRow('住所', customer['address'] ?? ''),
            _buildInfoRow('メールアドレス', customer['email'] ?? ''),
            _buildInfoRow('生年月日', customer['birthday'] ?? ''),
            _buildInfoRow('最終来店日', customer['lastVisit'] ?? ''),
            _buildInfoRow('特記事項', customer['notes'] ?? ''),
          ],
        ),
      ),
    );
  }

  /// 情報行を構築
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  /// アクションボタンを構築
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FilledButton.icon(
          onPressed: () {
            context.push('/customers/$customerId/history');
          },
          icon: const Icon(Icons.history),
          label: const Text('来店履歴'),
        ),
      ],
    );
  }

  /// 履歴セクションを構築
  Widget _buildHistorySection(BuildContext context) {
    // ダミーの履歴データ (実際にはViewModelから取得)
    final List<Map<String, String>> history = [
      {'date': '2024/06/01', 'type': '来店', 'memo': '定期メンテナンス'},
      {'date': '2024/05/15', 'type': '来店', 'memo': '商品購入'},
      {'date': '2024/04/10', 'type': '来店', 'memo': '相談のみ'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('最近の来店履歴', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    context.push('/customers/$customerId/history');
                  },
                  child: const Text('すべて表示'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return ListTile(
                  leading: const Icon(Icons.event_note),
                  title: Text(item['date']! + ' - ' + item['type']!),
                  subtitle: Text(item['memo']!),
                  onTap: () {
                    // 履歴詳細へのナビゲーション
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
