import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// -----
/// [概要]   :在庫商品の詳細情報を表示する画面
/// [作成者] :AI Assistant
/// [作成日] :2024/06/29
/// -----
class InventoryDetailScreen extends StatelessWidget {
  /// -----
  /// 在庫詳細画面を構築するコンストラクタ
  ///
  /// 引数:
  /// * [key] - Widgetの識別キー
  /// * [id] - 表示する商品のID
  /// -----
  final String? id;

  const InventoryDetailScreen({super.key, this.id});

  /// -----
  /// 画面ビルド処理
  /// -----
  @override
  Widget build(BuildContext context) {
    // ダミーデータ (実際にはViewModelから取得)
    final product = {
      'id': id,
      'name': 'ゴールドネックレス',
      'brand': 'LUXURY',
      'price': '120,000円',
      'cost': '80,000円',
      'store': '東京店',
      'size': '45cm',
      'material': 'K18YG',
      'weight': '10g',
      'stock_date': '2024/03/15',
      'supplier': '株式会社GOLD',
      'notes': '特記事項なし',
    };

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        title: const Text('在庫詳細'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImageSection(context),
              const SizedBox(height: 16),
              _buildProductInfoCard(context, product),
              const SizedBox(height: 16),
              _buildProductDetailsCard(context, product),
              const SizedBox(height: 16),
              _buildSupplierInfoCard(context, product),
              const SizedBox(height: 16),
              _buildNotesCard(context, product),
              const SizedBox(height: 24),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 商品画像セクションを構築
  Widget _buildProductImageSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 実際のアプリではネットワーク画像や保存された画像を表示
            Container(
              height: 200,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
              child: const Center(child: Icon(Icons.image, size: 80, color: Colors.grey)),
            ),
            const SizedBox(height: 16),
            Text('ゴールドネックレス', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  /// 商品基本情報カードを構築
  Widget _buildProductInfoCard(BuildContext context, Map<String, dynamic> product) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('基本情報', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInfoRow('商品ID', product['id'] ?? ''),
            _buildInfoRow('商品名', product['name'] ?? ''),
            _buildInfoRow('ブランド', product['brand'] ?? ''),
            _buildInfoRow('販売価格', product['price'] ?? ''),
            _buildInfoRow('仕入価格', product['cost'] ?? ''),
            _buildInfoRow('在庫店舗', product['store'] ?? ''),
          ],
        ),
      ),
    );
  }

  /// 商品詳細情報カードを構築
  Widget _buildProductDetailsCard(BuildContext context, Map<String, dynamic> product) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('商品詳細', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInfoRow('サイズ', product['size'] ?? ''),
            _buildInfoRow('素材', product['material'] ?? ''),
            _buildInfoRow('重量', product['weight'] ?? ''),
          ],
        ),
      ),
    );
  }

  /// 仕入れ情報カードを構築
  Widget _buildSupplierInfoCard(BuildContext context, Map<String, dynamic> product) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('仕入れ情報', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInfoRow('仕入日', product['stock_date'] ?? ''),
            _buildInfoRow('仕入先', product['supplier'] ?? ''),
          ],
        ),
      ),
    );
  }

  /// 特記事項カードを構築
  Widget _buildNotesCard(BuildContext context, Map<String, dynamic> product) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('特記事項', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(product['notes'] ?? ''),
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
    return Center(
      child: FilledButton.icon(
        onPressed: () {
          context.pop();
        },
        icon: const Icon(Icons.arrow_back),
        label: const Text('戻る'),
      ),
    );
  }
}
