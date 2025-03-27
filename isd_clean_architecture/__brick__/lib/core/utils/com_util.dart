import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComUtil {
  /// -----------------------------------------------
  /// 現在日付を取得
  /// -----------------------------------------------
  /// 戻り値:
  /// * `yyyy/MM/dd`
  /// -----------------------------------------------
  static String getNowDate() {
    return DateFormat('yyyy/MM/dd').format(DateTime.now());
  }

  /// -----------------------------------------------
  /// 日付をフォーマットする
  /// -----------------------------------------------
  /// 戻り値:
  /// * `yyyy/MM/dd`
  /// -----------------------------------------------
  static String formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }

  /// -----------------------------------------------
  /// 日付の正当性をチェックする（yyyy/MM/dd または yyyy/MM/dd HH:mm）
  /// -----------------------------------------------
  static bool checkDate(String val) {
    var dateRegex = RegExp(r'^(\d{4})/(\d{1,2})/(\d{1,2})(?: (\d{1,2}):(\d{1,2}))?$');
    var match = dateRegex.firstMatch(val);
    if (match != null) {
      // DateTimeを使って日付の妥当性をチェック
      try {
        var year = int.parse(match.group(1)!);
        var month = int.parse(match.group(2)!);
        var day = int.parse(match.group(3)!);
        var hour = match.group(4) != null ? int.parse(match.group(4)!) : 0;
        var minute = match.group(5) != null ? int.parse(match.group(5)!) : 0;

        var date = DateTime(year, month, day, hour, minute);
        // DateTimeのコンストラクタは無効な日付で別の日付を生成するので、
        // 元の値と一致するかチェックする
        if (date.year == year && date.month == month && date.day == day && date.hour == hour && date.minute == minute) {
          return true;
        }
      } catch (e) {
        // 解析エラー（例：intへの変換失敗）
        return false;
      }
    }
    return false;
  }

  /// -----------------------------------------------
  /// 末日の取得
  /// -----------------------------------------------
  static String getEndOfMonthDay(String year, String month) {
    try {
      final date = DateTime(int.parse(year), int.parse(month) + 1, 0);
      return DateFormat('dd').format(date);
    } on Exception {
      return '';
    }
  }

  /// -----------------------------------------------
  /// 指定した数の数カ月前を返す。
  /// 数カ月前の月末日が小さい場合は、その月の月末する。
  /// 例:
  ///  date=2023/03/31,val=1の場合
  ///   返却値 2023/02/28
  ///  date=2023/02/28,val=1の場合
  ///   返却値 2023/01/28
  /// -----------------------------------------------
  static String getBeforeMonthDate(String date, int val) {
    String resultDate = '';
    String deteVal = date.replaceAll('/', '');
    int subVal = val - 1;
    if (isDate(deteVal)) {
      final baseDate = DateTime.parse(deteVal);
      final prevMonthLastDay = DateTime(baseDate.year, baseDate.month + (subVal * -1), 0);
      // 基準日のddより数カ月前の月末日ddが大きい場合は、基準日のddとし、
      // 数カ月前の月末日ddが同じ、または小さい場合は、数カ月前の月末日ddを日付とする。
      final prevDay = baseDate.day < prevMonthLastDay.day ? baseDate.day : prevMonthLastDay.day;
      final prevMonth = DateTime(prevMonthLastDay.year, prevMonthLastDay.month, prevDay); // a month ago
      resultDate = DateFormat('yyyy/MM/dd').format(prevMonth);
    }
    return resultDate;
  }

  /// -----------------------------------------------
  /// 曜日の取得
  /// @param date `yyyy/MM/dd`
  /// -----------------------------------------------
  static String getWeekDay(String date) {
    try {
      final dateStr = DateTime.parse(date.replaceAll('/', ''));
      final weekDay = dateStr.weekday;
      return ['月', '火', '水', '木', '金', '土', '日'][weekDay - 1];
    } on Exception {
      return '';
    }
  }

  /// -----------------------------------------------
  ///日付判定のチェック
  /// -----------------------------------------------
  static bool isDate(String ymd) {
    //null,空文字はエラーとしない
    if (ymd == '') {
      return true;
    }
    //日付に変換できなかった場合、falseを返す。
    try {
      final date = DateTime.parse(ymd);
      final convYmd =
          date.year.toString().padLeft(4, '0') +
          date.month.toString().padLeft(2, '0') +
          date.day.toString().padLeft(2, '0');
      //引数と一致しない場合は、02/30などの日付の為、falseを返す。
      if (ymd == convYmd) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      return false;
    }
  }

  /// 日付と時刻の文字列からDateTimeオブジェクトを生成
  ///
  /// 引数:
  /// * `date`: 日付文字列 (yyyy/MM/dd, yyyy-MM-dd, yyyyMMdd形式)
  /// * `time`: 時刻文字列 (HH:mm, HH:mm:ss, HHmm, HHmmss形式)。
  ///          nullまたは空の場合、useEndTimeがtrueなら'23:59:59.999'、falseなら'00:00:00.000'が設定される
  /// * `useEndTime`: 時刻が未指定の場合、終了時刻（23:59:59.999）を使用するかどうか。
  ///                 デフォルトはfalse（00:00:00.000を使用）
  ///
  /// 戻り値:
  /// * `DateTime`: 変換後のDateTimeオブジェクト
  ///
  /// 例外:
  /// * `FormatException`: 日付の形式が不正な場合
  /// * `ArgumentError`: 日付がnullまたは空文字の場合
  static DateTime parseDateTime(String? date, String? time, {bool useEndTime = false}) {
    // 日付のnull/空文字チェック
    if (date == null || date.trim().isEmpty) {
      throw ArgumentError('日付が指定されていません');
    }

    try {
      // 日付文字列の正規化（区切り文字を除去）
      final dateStr = date.trim().replaceAll(RegExp(r'[-/]'), '');
      if (dateStr.length != 8) {
        throw FormatException('日付の形式が不正です: $date');
      }

      // 数値としての妥当性チェック（日付）
      if (!RegExp(r'^\d+$').hasMatch(dateStr)) {
        throw FormatException('日付に数値以外の文字が含まれています: $date');
      }

      DateTime dateTime;
      if (time == null || time.trim().isEmpty) {
        // 時刻が未指定の場合、デフォルト値を設定
        if (useEndTime) {
          dateTime = DateTime.parse('$dateStr 235959').add(const Duration(milliseconds: 999));
        } else {
          dateTime = DateTime.parse('$dateStr 000000');
        }
      } else {
        // 時刻文字列の正規化（区切り文字を除去）
        var timeStr = time.trim().replaceAll(':', '');

        // 数値としての妥当性チェック（時刻）
        if (!RegExp(r'^\d+$').hasMatch(timeStr)) {
          // 不正な場合はデフォルト値を使用
          if (useEndTime) {
            dateTime = DateTime.parse('$dateStr 235959').add(const Duration(milliseconds: 999));
          } else {
            dateTime = DateTime.parse('$dateStr 000000');
          }
        } else {
          // 4桁の場合は秒を追加
          if (timeStr.length == 4) {
            timeStr = '${timeStr}00';
          }
          dateTime = DateTime.parse('$dateStr $timeStr');
          // useEndTimeがtrueで、明示的に時刻が指定されている場合でも
          // その秒の最後のミリ秒を設定
          if (useEndTime) {
            dateTime = dateTime.add(const Duration(milliseconds: 999));
          }
        }
      }

      // 年月日の妥当性チェック（DateTime.parseは2月31日などを自動的に修正してしまうため）
      final year = int.parse(dateStr.substring(0, 4));
      final month = int.parse(dateStr.substring(4, 6));
      final day = int.parse(dateStr.substring(6, 8));
      if (dateTime.year != year || dateTime.month != month || dateTime.day != day) {
        throw FormatException('不正な日付です: $date');
      }

      return dateTime;
    } catch (e) {
      if (e is ArgumentError || e is FormatException) {
        rethrow;
      }
      throw FormatException('日付時刻の解析に失敗しました: $date $time');
    }
  }

  /// -----------------------------------------------
  ///年齢算出
  /// -----------------------------------------------
  static String calcAge(String birthYear, String birthMonth, String birthDay) {
    final strnow = DateFormat('yyyyMMdd').format(DateTime.now());

    //入力チェック
    if (birthYear == '' || birthMonth == '' || birthDay == '') {
      return '';
    } else {
      final birthymd = '$birthYear$birthMonth$birthDay';
      if (!ComUtil.isDate(birthymd)) {
        return '';
      } else {
        return ((int.parse(strnow) - int.parse(birthymd)) / 10000).floor().toString();
      }
    }
  }

  /// -----------------------------------------------
  ///日付FromToの正当性判定のチェック
  /// -----------------------------------------------
  static bool isDateRange(String? from, String? to) {
    // 日付形式のフォーマットを定義
    final dateFormat = DateFormat('yyyy/MM/dd');
    // どちらか片方がnullの場合はtrue
    if (from == null || to == null || from.isEmpty || to.isEmpty) {
      return true;
    }
    try {
      // 入力された日付文字列をDateTimeに変換
      final fromDate = dateFormat.parse(from);
      final toDate = dateFormat.parse(to);

      // 日付を比較
      return fromDate.isBefore(toDate) || fromDate.isAtSameMomentAs(toDate);
    } catch (e) {
      return false;
    }
  }

  /// -----------------------------------------------
  ///int型FromToの正当性判定のチェック
  /// -----------------------------------------------
  static bool isIntRange(int? from, int? to) {
    // どちらか片方がnullの場合はtrue
    if (from == null || to == null) {
      return true;
    }
    try {
      // 数値を比較
      return from <= to;
    } catch (e) {
      return false;
    }
  }

  /// -----------------------------------------------
  ///double型FromToの正当性判定のチェック
  /// -----------------------------------------------
  static bool isDoubleRange(double? from, double? to) {
    // どちらか片方がnullの場合はtrue
    if (from == null || to == null) {
      return true;
    }
    try {
      // 数値を比較
      return from <= to;
    } catch (e) {
      return false;
    }
  }

  /// -----------------------------------------------
  /// 郵便番号整形
  /// -----------------------------------------------
  static String convertToZip(String zip) {
    // 999-9999の形に自動整形する
    const zipDigit = 8;
    final arrStr = <String>[];
    final str = zip.trim().replaceAll('-', '');
    String left, right;

    if (str == '') {
      return '';
    }
    // 一旦分解する ------------------------------------------
    if (str.length == zipDigit - 1) {
      left = str.substring(0, 3);
      right = str.substring(3, 7);

      // 合体
      arrStr.add(left.toString());
      arrStr.add(right.toString());

      return arrStr.join('-');
    } else {
      return str;
    }
  }

  /// -----------------------------------------------
  /// カンマ削除
  /// -----------------------------------------------
  static String removeComma(String? val) {
    if (val == null || val == '' || val == 'null') {
      return '';
    }
    return val.toString().replaceAll(',', '');
  }

  /// -----------------------------------------------
  /// カンマ付与
  /// val: 対象数値
  /// decLen: 小数点表示桁数
  /// -----------------------------------------------
  static String addComma(String? val, [int? decLen]) {
    dynamic i, ch;
    var sVal = val.toString();

    if (sVal == '-') {
      return '';
    }
    sVal = removeComma(sVal.replaceAll(r'[ 　]', ''));

    if (sVal == '' || sVal == 'null' || double.tryParse(sVal) == null) return '';
    String? newString = '';
    var flag = ''; // マイナスの時'-'を格納

    // 小数点7桁以降を削除(7桁を超えると指数表示になる)
    if (sVal.contains('.')) {
      if (sVal.substring(sVal.indexOf('.')).length > 6) {
        sVal = sVal.substring(0, sVal.indexOf('.') + 7);
      }
    }

    var flg = 1; // ピリオドの有無フラグ
    for (i = sVal.length - 1; i >= 0; i--) {
      ch = sVal.substring(i, i + 1);
      if (ch == '-' && i == 0) {
        // 左端に'-'がある場合はマイナス記号
        flag = ch;
      } else if (RegExp(r'[0-9.]').hasMatch(ch)) {
        // 整数の場合
        if (RegExp(r'[0-9]').hasMatch(ch)) {
          newString = ch + newString;
        }
        // ピリオドの場合
        else if (flg == 1 && ch == '.') {
          newString = ch + newString;
          flg = 0;
        } else {
          return '0';
        }
      }
    }

    // カンマ区切りにする
    var cnt = 0;
    var n = '';
    final parseNum = Decimal.parse(newString!); // 123.0→123, 123.1→123.1
    newString = parseNum.toString();

    // double.parseで除去された小数部を付与しなおす
    // → 小数部が「0」の時、parseFloatで小数部が除去されてしまいカンマ付が正しく行えなくなるため
    if (flg == 0 && !newString.contains('.')) {
      newString += val!.substring(val.indexOf('.'));
    }

    for (i = newString.length - 1; i >= 0; i--) {
      // ch = sVal.substring(i, i + 1);
      ch = newString.substring(i, i + 1);
      if (flg == 1) {
        // 整数の場合
        if (RegExp(r'[0-9]').hasMatch(ch)) {
          n = newString[i] + n;
          cnt++;
          if (cnt % 3 == 0 && i != 0) {
            n = ',$n';
          }
        }
      } else {
        n = newString[i] + n;
      }

      if (newString[i] == '.') {
        flg = 1;
      }
    }

    // 小数部整形
    if (decLen != null) {
      var j = n.indexOf('.');
      if (decLen < 1 && j != -1) {
        // 小数部桁数が0以下の場合、小数点以下を切り捨て
        n = n.split('.')[0];
      } else {
        // 小数部がない場合は小数点を付与
        if (j == -1) n += '.';
        // 小数部に引数「小数部桁数」分の0を付与
        for (i = 0; i < decLen; i++) {
          n += '0';
        }
        // 整数部に、小数点と引数「小数部桁数」分の数値を結合
        if (j != -1) {
          n = '${n.split('.')[0]}.${n.substring(j + 1, decLen)}';
        }
      }
    }
    return (flag + n);
  }

  /// -----------------------------------------------
  /// 強化版toString
  /// nullまたは'null'の文字列を空白に変換する
  /// @param val 対象の値
  /// @return 変換後の文字列
  /// -----------------------------------------------
  static String enhancedToString(dynamic val) {
    if (val == null || val.toString() == 'null') {
      return '';
    }
    return val.toString();
  }

  /// -----------------------------------------------
  /// 空白をNULLに変換
  /// @param val 対象の文字列
  /// @return 変換後の文字列（null可能）
  /// -----------------------------------------------
  static String? convertBlankToNull(String? val) {
    if (val == null || val.trim().isEmpty || val == 'null') {
      return null;
    }
    return val;
  }

  /// -----------------------------------------------
  /// 文字列フォーマット
  /// -----------------------------------------------
  /// [template] に含まれるプレースホルダー (例: "{0}", "{1}") を
  /// [values] の対応する値で置き換えてフォーマットします。
  ///
  /// [values] 内に `null`、空文字のみの値が含まれている場合、
  /// [returnNull] が true の場合は `null` を、false の場合は空文字を返します。
  /// これにより、不完全なデータが部分的にフォーマットされた文字列を生成することを防ぎます。
  ///
  /// 使用例:
  /// ```dart
  /// String? result1 = StringFormatter.formatWithNullCheck("({0} {1})", ['25', '%']);
  /// print(result1); // 出力: (25 %)
  ///
  /// String? result2 = StringFormatter.formatWithNullCheck("({0} {1})", ['25', null]);
  /// print(result2); // 出力: ''
  ///
  /// String? result3 = StringFormatter.formatWithNullCheck("({0} {1})", ['25', ''], returnNull: true);
  /// print(result3); // 出力: null
  /// ```
  ///
  /// - [template]: "{0}", "{1}" のようなプレースホルダーを含む文字列テンプレート。
  /// - [values]: テンプレート内のプレースホルダーを置き換えるための値のリスト。
  /// - [returnNull]: true の場合、無効な値が含まれる場合に null を返します。デフォルトは false。
  ///
  /// 全ての値が非NULL、かつ空白文字以外の場合、フォーマットされた文字列を返します。
  /// それ以外の場合は、[returnNull] の値に応じて null または空文字を返します。
  static String? formatWithNullCheck(String template, List<String?> values, {bool returnNull = false}) {
    // リスト内にNULL、空文字の値が含まれている場合は
    // returnNull の値に応じて null または空文字を返す
    if (values.any((value) => convertBlankToNull(value) == null)) {
      return returnNull ? null : '';
    }

    // プレースホルダーを対応する値で置き換える
    String result = template;
    for (int i = 0; i < values.length; i++) {
      result = result.replaceAll('{$i}', values[i]!);
    }
    return result;
  }

  /// -----------------------------------------------
  /// 浮動小数点数の計算誤差対応 足し算
  /// -----------------------------------------------
  static Decimal plusNum(String num1, String num2) {
    num1 = removeComma(num1);
    num2 = removeComma(num2);

    return Decimal.parse(num1) + Decimal.parse(num2);
  }

  /// -----------------------------------------------
  /// 浮動小数点数の計算誤差対応 引き算
  /// -----------------------------------------------
  static Decimal minusNum(String num1, String num2) {
    num1 = removeComma(num1);
    num2 = removeComma(num2);

    return Decimal.parse(num1) - Decimal.parse(num2);
  }

  /// -----------------------------------------------
  /// 浮動小数点数の計算誤差対応 掛け算
  /// -----------------------------------------------
  static Decimal multiNum(String? num1, String? num2) {
    String vNum1 = removeComma(num1 == 'null' ? '0' : num1);
    String vNum2 = removeComma(num2 == 'null' ? '0' : num2);

    return Decimal.parse(vNum1) * Decimal.parse(vNum2);
  }

  /// -----------------------------------------------
  /// 浮動小数点数の計算誤差対応 割り算
  /// -----------------------------------------------
  static Decimal divNum(String num1, String num2) {
    num1 = removeComma(num1);
    num2 = removeComma(num2);
    //小数は、15桁で返す。
    return (Decimal.parse(num1) / Decimal.parse(num2)).toDecimal(scaleOnInfinitePrecision: 15);
  }

  /// -----------------------------------------------
  /// 端数処理（端数区分値がDBの区分と一致するバージョン）
  /// strVal: 対象文字列
  /// type: 端数区分(1:切り捨て、2:切り上げ、3:四捨五入)
  /// keta: 処理桁位置
  /// 既存の「JS_toRounding」は端数区分がDB区分値と一致していないためDB値で処理する場合こちらを使用
  /// -----------------------------------------------
  static Decimal? toRounding(String strVal, int? type, int keta) {
    var sign = '1';
    try {
      // 数値、定義check falseならnullを返却
      var num = strVal.replaceAll(',', '');
      if (Decimal.parse(num).isInteger) {
        return Decimal.parse(num);
      }
      if (keta.isNaN) {
        return null;
      }
      if (keta < 0) {
        return null;
      }
      if (!(type! > 0 && type < 4)) {
        return null;
      }

      // 小数部桁数チェック
      // ※少数桁数が10を超えたら切り捨てる
      final val = num.split('.');
      var ketaMax = keta + 1;
      ketaMax = (keta < 10) ? ketaMax : 10;
      if (val.length == 2) {
        if (val[1].length > ketaMax) {
          val[1] = val[1].substring(0, ketaMax);
          num = val.join('.');
        }
      }

      var ret = Decimal.parse(num);

      // 符号セット
      if (ret < Decimal.zero) {
        sign = '-1';
      }

      // 絶対値を取得
      ret = ret.abs();
      // 処理桁位置調整用
      final exp = Decimal.parse(math.pow(10, keta).toString());

      // 端数区分：切り捨て
      if (type == 1) {
        ret = ((ret * exp).floor() / exp).toDecimal(); // 123.45 → 1234.5 → 1234 → 123.4
      }
      // 端数区分：切り上げ
      if (type == 2) {
        ret = ((ret * exp).ceil() / exp).toDecimal(); // 123.45 → 1234.5 → 1235 → 123.5
      }
      // 端数区分：四捨五入
      if (type == 3) {
        ret = ((ret * exp).round() / exp).toDecimal(); // 123.45 → 1234.5 → 1235 → 123.5
      }

      // 負数判定
      ret = ret * Decimal.parse(sign);
      return ret;
    } on Exception {
      return null;
    }
  }

  /// -----------------------------------------------
  /// From, To整合性チェック(コード、日付)
  /// strFrom, strTo: yyyy/MM/dd
  /// -----------------------------------------------
  static bool chkValidFromTo(String strFrom, String strTo) {
    DateTime dtFrom;
    DateTime dtTo;

    //両方空欄の場合true
    if (strFrom == '' && strTo == '') {
      return true;
    }
    //片落ちの場合true
    if (strFrom == '' || strTo == '') {
      return true;
    }

    // 日付型に変更可能の場合、日付として比較
    if (checkDate(strFrom) || checkDate(strTo)) {
      dtFrom = DateTime.parse(strFrom.replaceAll('/', '')); // ※ yyyyMMdd形式でないとparseできない
      dtTo = DateTime.parse(strTo.replaceAll('/', ''));

      // FromがToより後の日付の場合はfalse
      if (dtFrom.compareTo(dtTo) == 1) {
        return false;
      }
      return true;
    }
    // 日付型に変更不可の場合、文字列として比較
    else if (int.tryParse(strFrom) != null && int.tryParse(strFrom) != null) {
      if (int.parse(strFrom) > int.parse(strTo)) {
        return false;
      }
      return true;
    } else {
      // // 日付でも数値でもない場合
      // if (strFrom > strTo){
      //   return false;
      // }
      return true;
    }
  }

  /// テキストの幅を取得する
  ///
  /// 指定されたテキストとスタイルに基づいて、テキストの幅を計算します。
  ///
  /// 注意: スペースは幅に含まれない可能性があります。
  ///
  /// - [text]: 幅を計算するテキスト
  /// - [style]: テキストのスタイル
  ///
  /// 戻り値:
  /// - テキストの幅（ピクセル単位）
  static double getTextWidth(String text, {required TextStyle style}) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: ui.TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.width + 6;
  }

  /// スクロールビューを最上部までスクロールします。
  ///
  /// [scrollController] を使用して、指定された [chunkSize] と [jumpThresholdInPixels] の値に基づいてスクロールを制御します。
  /// [chunkSize] はスクロールするサイズを指定し、デフォルトは1600.0です。
  /// [jumpThresholdInPixels] はジャンプスクロールを開始する閾値を指定し、デフォルトは50000.0です。
  ///
  /// スクロール位置が [jumpThresholdInPixels] を超える場合、アニメーションなしで即座にスクロールします。
  /// それ未満の場合は、アニメーションを伴ってスクロールします。
  static Future<void> scrollToTop(
    ScrollController scrollController, {
    double chunkSize = 1600.0,
    double jumpThresholdInPixels = 50000.0,
  }) async {
    // Topまでスクロールする
    while (scrollController.offset > 0) {
      final double target = scrollController.offset - chunkSize < 0 ? 0 : scrollController.offset - chunkSize;
      if (scrollController.offset >= jumpThresholdInPixels) {
        // 規定値を超えた場合、アニメーションなしでスクロールする
        await Future.delayed(const Duration(milliseconds: 1));
        scrollController.jumpTo(target);
      } else {
        // 規定値を超えていない場合、アニメーションでスクロールする
        await scrollController.animateTo(target, duration: const Duration(milliseconds: 1), curve: Curves.linear);
      }
      if (target == 0) break;
    }
  }

  /// 指定色が暗い色かどうかを判定
  ///
  /// 与えられた色の明るさを計算し、暗い色かどうかを判定します。
  ///
  /// - [color]: 判定する色
  ///
  /// 戻り値:
  /// - `true`: 暗い色の場合
  /// - `false`: 明るい色の場合
  static bool isColorDark(Color color) {
    final brightness = ThemeData.estimateBrightnessForColor(color);
    return brightness == Brightness.dark;
  }

  static void nextFocus(List<FocusNode> focusNodes, BuildContext context, int currentIndex) {
    focusNodes[currentIndex].unfocus();
    FocusScope.of(context).requestFocus(focusNodes[currentIndex + 1]);
  }

  /// 改行含むテキストにインデントを付ける（主にメール用）
  static String strToIndent(String str, int indent) {
    String val = '';
    for (int i = 0; i < str.length; i++) {
      if (['{', '}', '[', ']', '(', ')', ','].contains(str[i])) {
        if (!['}', ']', ')'].contains(str[i])) {
          val += str[i];
        }
        val += '\n';
        if (['{', '[', '('].contains(str[i])) {
          indent++;
          val += ' ';
        }
        if (['}', ']', ')'].contains(str[i])) {
          indent--;
          val += ' ';
        }
        for (int j = 0; j < indent; j++) {
          val += '  ';
        }
        if (['}', ']', ')'].contains(str[i])) {
          val += str[i];
        }
      } else {
        val += str[i];
      }
    }
    return val;
  }
}
