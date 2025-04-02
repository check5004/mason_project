import 'package:flutter/material.dart';

import '../../../../data/models/feature/customer/get_kokyaku_list_response.dart';

/// -----
/// [概要]   : 顧客検索結果セクション
/// [作成者] : TCC S.Tate
/// [作成日] : 2025/03/26
/// -----
/// 顧客検索結果を表示するセクションです。
class CustomerResultSection extends StatelessWidget {
  /// 表示する顧客リスト
  final List<KokyakuListResult> kokyakuList;

  /// 検索結果総件数
  final int count;

  /// コンストラクタ
  const CustomerResultSection({super.key, required this.kokyakuList, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 検索件数表示
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text('検索結果: $count 件', style: Theme.of(context).textTheme.titleMedium),
        ),
        const SizedBox(height: 8),
        // 顧客一覧テーブル
        Expanded(
          child:
              kokyakuList.isEmpty
                  ? const Center(child: Text('該当する顧客がありません'))
                  : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 20,
                        columns: const [
                          DataColumn(label: Text('顧客ID')),
                          DataColumn(label: Text('氏名')),
                          DataColumn(label: Text('電話番号')),
                          DataColumn(label: Text('住所')),
                          DataColumn(label: Text('管理店舗')),
                          DataColumn(label: Text('担当者')),
                        ],
                        rows:
                            kokyakuList.map((customer) {
                              // 氏名を結合
                              final fullName = '${customer.kokyakuSei ?? ''} ${customer.kokyakuMei ?? ''}';

                              // 住所を結合
                              final address = [
                                customer.postCd1 != null && customer.postCd2 != null
                                    ? '〒${customer.postCd1}-${customer.postCd2}'
                                    : '',
                                customer.address1 ?? '',
                                customer.address2 ?? '',
                              ].where((s) => s.isNotEmpty).join(' ');

                              return DataRow(
                                onSelectChanged: (selected) {
                                  // TODO: 詳細画面への遷移処理を実装
                                  if (selected == true) {
                                    // GoRouterを使って詳細画面へ遷移する想定
                                    // context.go('/customer/detail/${customer.kokyakuId}');
                                  }
                                },
                                cells: [
                                  DataCell(Text(customer.kokyakuId?.toString() ?? '')),
                                  DataCell(Text(fullName)),
                                  DataCell(Text(customer.tel ?? customer.mobile ?? '')),
                                  DataCell(Text(address)),
                                  DataCell(Text(customer.kanriTenpo ?? '')),
                                  DataCell(Text(customer.kanriTantosha ?? '')),
                                ],
                              );
                            }).toList(),
                      ),
                    ),
                  ),
        ),
      ],
    );
  }
}
