import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// -----------------------------------------------
/// [概要]   :日付選択用のボトムシートウィジェット
/// [作成者] :Tcc S.Tate
/// [作成日] :2024/11/05
/// -----------------------------------------------
class DatePickerBottomSheetWidget extends StatelessWidget {
  /// DatePickerボトムシートのコンストラクタ
  ///
  /// 引数:
  /// - `initialDate`: 初期選択日。nullの場合は現在日時が使用される
  /// - `onDateChanged`: 日付が変更された時のコールバック
  /// - `maximumDate`: 選択可能な最大日付。デフォルトは現在日時
  /// - `minimumDate`: 選択可能な最小日付。デフォルトはnull
  const DatePickerBottomSheetWidget({
    super.key,
    this.initialDate,
    required this.onDateChanged,
    this.maximumDate,
    this.minimumDate,
  });

  final DateTime? initialDate;
  final void Function(DateTime) onDateChanged;
  final DateTime? maximumDate;
  final DateTime? minimumDate;

  /// ボトムシートを表示する静的メソッド
  static Future<void> show({
    required BuildContext context,
    DateTime? initialDate,
    required void Function(DateTime) onDateChanged,
    DateTime? maximumDate,
    DateTime? minimumDate,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => DatePickerBottomSheetWidget(
        initialDate: initialDate,
        onDateChanged: onDateChanged,
        maximumDate: maximumDate,
        minimumDate: minimumDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          // ボトムシートのヘッダー
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('キャンセル'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('完了'),
                ),
              ],
            ),
          ),
          // DatePicker
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: initialDate ?? DateTime.now(),
              maximumDate: maximumDate ?? DateTime.now(),
              minimumDate: minimumDate,
              onDateTimeChanged: onDateChanged,
              use24hFormat: true,
            ),
          ),
        ],
      ),
    );
  }
}
