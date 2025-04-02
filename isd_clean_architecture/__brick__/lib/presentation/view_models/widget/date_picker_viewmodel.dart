import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/utils/com_util.dart';

/// -----------------------------------------------
/// [概要]   :日付選択機能のViewModelを提供するProvider
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/06
/// -----------------------------------------------
final datePickerViewModelProvider = StateNotifierProvider.family<DatePickerViewModel, DatePickerState, String>(
  (ref, id) => DatePickerViewModel(),
);

/// -----------------------------------------------
/// [概要]   :日付選択機能の状態を管理するStateクラス
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/06
/// -----------------------------------------------
class DatePickerState {
  final DateTime? selectedDate;
  final String dateText;

  /// -----------------------------------------------
  /// DatePickerStateのコンストラクタ
  ///
  /// 日付選択機能の状態を初期化します。
  ///
  /// **パラメータ**:
  /// * `selectedDate`: 選択された日付
  /// * `dateText`: 表示用の日付テキスト
  /// -----------------------------------------------
  DatePickerState({this.selectedDate, this.dateText = ''});

  /// -----------------------------------------------
  /// 状態を複製して新しい値で更新するメソッド
  ///
  /// **パラメータ**:
  /// * `selectedDate`: 更新する選択日付
  /// * `dateText`: 更新する日付テキスト
  ///
  /// **戻り値**:
  /// * 更新された新しいDatePickerStateインスタンス
  /// -----------------------------------------------
  DatePickerState copyWith({DateTime? selectedDate, String? dateText}) {
    return DatePickerState(selectedDate: selectedDate ?? this.selectedDate, dateText: dateText ?? this.dateText);
  }
}

/// -----------------------------------------------
/// [概要]   :日付選択機能のビジネスロジックを管理するViewModelクラス
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/06
/// -----------------------------------------------
class DatePickerViewModel extends StateNotifier<DatePickerState> {
  /// -----------------------------------------------
  /// DatePickerViewModelのコンストラクタ
  ///
  /// 初期状態のDatePickerStateを生成します。
  /// -----------------------------------------------
  DatePickerViewModel() : super(DatePickerState());

  /// -----------------------------------------------
  /// 日付を更新するメソッド
  ///
  /// カレンダーから選択された日付で状態を更新します。
  ///
  /// **パラメータ**:
  /// * `date`: 更新する日付
  /// -----------------------------------------------
  void updateDate(DateTime date) {
    state = state.copyWith(selectedDate: date, dateText: ComUtil.formatDate(date));
  }

  /// -----------------------------------------------
  /// テキスト入力から日付を更新するメソッド
  ///
  /// 入力されたテキストを日付形式に変換して状態を更新します。
  ///
  /// **パラメータ**:
  /// * `text`: 入力された日付テキスト
  /// -----------------------------------------------
  void updateText(String text) {
    // テキストをフォーマット
    final formattedText = _formatInputText(text);

    // 入力中の値が無効な場合は更新しない
    if (!isValidInputting(formattedText)) {
      return;
    }

    // 状態が変化している場合のみ更新
    if (formattedText != state.dateText) {
      state = state.copyWith(dateText: formattedText, selectedDate: _tryParseDate(formattedText));
    }
  }

  /// -----------------------------------------------
  /// 日付をクリアするメソッド
  ///
  /// 状態を初期状態にリセットします。
  /// -----------------------------------------------
  void clearDate() {
    state = DatePickerState();
  }

  /// -----------------------------------------------
  /// 入力テキストをフォーマットするプライベートメソッド
  ///
  /// **パラメータ**:
  /// * `input`: フォーマットする入力テキスト
  ///
  /// **戻り値**:
  /// * yyyy/MM/dd形式に整形された文字列
  /// -----------------------------------------------
  String _formatInputText(String input) {
    // 数字以外を除去
    final numbers = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (numbers.isEmpty) return '';

    final buffer = StringBuffer();
    var i = 0;
    for (final char in numbers.split('')) {
      if (i == 4 || i == 6) buffer.write('/');
      if (i >= 8) break;
      buffer.write(char);
      i++;
    }
    return buffer.toString();
  }

  /// -----------------------------------------------
  /// 日付文字列をDateTime型に変換を試みるプライベートメソッド
  ///
  /// **パラメータ**:
  /// * `text`: 変換する日付文字列
  ///
  /// **戻り値**:
  /// * 変換成功時はDateTime、失敗時はnull
  /// -----------------------------------------------
  DateTime? _tryParseDate(String text) {
    if (text.isEmpty) return null;
    try {
      final parts = text.split('/');
      if (parts.length != 3) return null;

      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      final date = DateTime(year, month, day);
      if (date.year == year && date.month == month && date.day == day) {
        return date;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  /// -----------------------------------------------
  /// 日付の妥当性をチェックするメソッド
  ///
  /// **パラメータ**:
  /// * `value`: チェックする日付文字列
  ///
  /// **戻り値**:
  /// * 日付として有効な場合はtrue
  /// -----------------------------------------------
  bool isValidDate(String value) {
    if (value.isEmpty) return true;
    return _tryParseDate(value) != null;
  }

  /// -----------------------------------------------
  /// 入力中の日付文字列の妥当性をチェックするメソッド
  ///
  /// 入力途中の日付文字列が最終的に有効な日付になり得るかを判定します。
  ///
  /// **パラメータ**:
  /// * `value`: チェックする入力中の日付文字列
  ///
  /// **戻り値**:
  /// * 入力として有効な場合はtrue
  /// -----------------------------------------------
  bool isValidInputting(String value) {
    if (value.isEmpty) return true;

    // 数字以外を除去
    final numbers = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (numbers.isEmpty) return true;

    // 入力中の数字を取得
    final inputLength = numbers.length;
    if (inputLength > 8) return false; // 8桁以上は無効

    try {
      String year, month, day;

      if (inputLength <= 4) {
        // 年の入力中: 残りを正しい日付になるように補完
        year = numbers + '0' * (4 - inputLength);
        month = '01';
        day = '01';
      } else if (inputLength <= 6) {
        // 月の入力中: 残りを正しい日付になるように補完
        year = numbers.substring(0, 4);
        month = numbers.substring(4) + '1' * (2 - (inputLength - 4));
        day = '01';
      } else {
        // 日の入力中: 残りを正しい日付になるように補完
        year = numbers.substring(0, 4);
        month = numbers.substring(4, 6);
        final dayPart = numbers.substring(6);

        // 日付の最後の1桁の場合のみ0で補完
        if (dayPart.length == 1) {
          if (dayPart != '0') {
            day = '${dayPart}0';
          } else {
            day = '${dayPart}1';
          }
        } else {
          day = dayPart;
        }
      }

      final yearNum = int.parse(year);
      final monthNum = int.parse(month);
      final dayNum = int.parse(day);

      final date = DateTime(yearNum, monthNum, dayNum);
      return date.year == yearNum && date.month == monthNum && date.day == dayNum;
    } catch (e) {
      return false;
    }
  }

  /// -----------------------------------------------
  /// 完全な日付形式としての妥当性をチェックするメソッド
  ///
  /// Submit時に使用され、yyyy/MM/dd形式として完全な日付であるかを検証します。
  ///
  /// **パラメータ**:
  /// * `value`: チェックする日付文字列
  ///
  /// **戻り値**:
  /// * 完全な日付形式として有効な場合はtrue
  /// -----------------------------------------------
  bool isCompleteDate(String value) {
    if (value.isEmpty) return true;

    final date = _tryParseDate(value);
    if (date == null) return false;

    // yyyy/mm/dd形式になっているかチェック
    final parts = value.split('/');
    return parts.length == 3 && parts[0].length == 4 && parts[1].length == 2 && parts[2].length == 2;
  }
}
