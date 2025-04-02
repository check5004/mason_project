import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// -----
/// [概要]   :顧客情報の新規登録・編集画面を表示するウィジェット
/// [作成者] :AI Assistant
/// [作成日] :2024/06/29
/// -----
class CustomerEditScreen extends StatelessWidget {
  /// -----
  /// 顧客編集画面を構築するコンストラクタ
  ///
  /// 引数:
  /// * [key] - Widgetの識別キー
  /// * [customerId] - 編集する顧客のID（新規登録時はnull）
  /// * [isNew] - 新規登録モードの場合はtrue
  /// -----
  final String? customerId;
  final bool isNew;

  const CustomerEditScreen({super.key, this.customerId, this.isNew = false});

  /// -----
  /// 画面ビルド処理
  /// -----
  @override
  Widget build(BuildContext context) {
    final title = isNew ? '顧客新規登録' : '顧客情報編集';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            // key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBasicInfoSection(context),
                const SizedBox(height: 24),
                _buildContactInfoSection(context),
                const SizedBox(height: 24),
                _buildAdditionalInfoSection(context),
                const SizedBox(height: 32),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 基本情報セクションを構築
  Widget _buildBasicInfoSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('基本情報', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '顧客名',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '顧客名を入力してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '生年月日',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.cake),
                hintText: 'YYYY/MM/DD',
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 連絡先情報セクションを構築
  Widget _buildContactInfoSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('連絡先情報', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '電話番号',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '電話番号を入力してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'メールアドレス',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '住所',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.home),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 追加情報セクションを構築
  Widget _buildAdditionalInfoSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('追加情報', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '特記事項',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  /// アクションボタンを構築
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: () {
            // キャンセル処理
            context.pop();
          },
          icon: const Icon(Icons.cancel),
          label: const Text('キャンセル'),
        ),
        const SizedBox(width: 16),
        FilledButton.icon(
          onPressed: () {
            // 保存処理
            // フォームのバリデーションチェック
            // if (_formKey.currentState!.validate()) {
            //   // 処理を実行
            // }

            // 仮の実装 - 実際にはViewModel経由で保存
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('保存しました')));

            // 前の画面に戻る
            context.pop();
          },
          icon: const Icon(Icons.save),
          label: const Text('保存'),
        ),
      ],
    );
  }
}
