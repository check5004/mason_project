import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// -----
/// [概要]   :在庫検索画面のウィジェット
/// [作成者] :AI Assistant
/// [作成日] :2024/06/29
/// -----
class InventorySearchScreen extends StatelessWidget {
  /// -----
  /// 在庫検索画面を構築するコンストラクタ
  ///
  /// 引数:
  /// * [key] - Widgetの識別キー
  /// -----
  const InventorySearchScreen({super.key});

  /// -----
  /// 画面ビルド処理
  /// -----
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        title: const Text('在庫一覧'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchForm(context),
              const SizedBox(height: 16),
              _buildSearchButton(context),
              const SizedBox(height: 24),
              _buildResultTable(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 検索フォームを構築
  Widget _buildSearchForm(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('検索条件', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTextField(context, '品番', Icons.tag)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField(context, 'ブランド', Icons.shop)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField(context, '価格(From)', Icons.monetization_on)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField(context, '価格(To)', Icons.monetization_on)),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(context, '在庫店舗', Icons.store),
          ],
        ),
      ),
    );
  }

  /// テキストフィールドを構築
  Widget _buildTextField(BuildContext context, String label, IconData icon) {
    return TextField(
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: const OutlineInputBorder()),
    );
  }

  /// 検索ボタンを構築
  Widget _buildSearchButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: () {
            // クリア処理
          },
          icon: const Icon(Icons.clear),
          label: const Text('クリア'),
        ),
        const SizedBox(width: 16),
        FilledButton.icon(
          onPressed: () {
            // 検索処理
          },
          icon: const Icon(Icons.search),
          label: const Text('検索'),
        ),
      ],
    );
  }

  /// 検索結果テーブルを構築
  Widget _buildResultTable(BuildContext context) {
    // サンプルデータ
    final List<Map<String, String>> products = [
      {'id': '001', 'name': 'ゴールドネックレス', 'brand': 'LUXURY', 'price': '120,000円', 'store': '東京店'},
      {'id': '002', 'name': 'シルバーバングル', 'brand': 'SILVERY', 'price': '35,000円', 'store': '大阪店'},
      {'id': '003', 'name': 'ダイヤモンドリング', 'brand': 'LUXURY', 'price': '250,000円', 'store': '名古屋店'},
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
                const Text('検索結果', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${products.length}件', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('商品ID')),
                  DataColumn(label: Text('商品名')),
                  DataColumn(label: Text('ブランド')),
                  DataColumn(label: Text('価格')),
                  DataColumn(label: Text('在庫店舗')),
                  DataColumn(label: Text('操作')),
                ],
                rows:
                    products.map((product) {
                      return DataRow(
                        cells: [
                          DataCell(Text(product['id']!)),
                          DataCell(Text(product['name']!)),
                          DataCell(Text(product['brand']!)),
                          DataCell(Text(product['price']!)),
                          DataCell(Text(product['store']!)),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.visibility),
                              onPressed: () {
                                context.push('/inventory/${product['id']}');
                              },
                              tooltip: '詳細',
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
