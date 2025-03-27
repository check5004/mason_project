import 'package:flutter/material.dart';
import 'package:kana_kit/kana_kit.dart';

/// -----------------------------------------------
/// [概要]   : フリガナ変換ユーティリティクラス
/// [作成者] : TCC S.Tate
/// [作成日] : 2024/11/27
/// -----------------------------------------------
///
/// 漢字かな混じり文からフリガナ（カタカナ）を自動生成するユーティリティクラス。
/// IMEによる漢字変換やかな入力に対応し、リアルタイムでフリガナを生成します。
///
/// 主な機能:
/// * 漢字→カタカナの自動変換
/// * IMEでの漢字変換の検出
/// * ひらがな/カタカナの入力追従
/// * 文字の削除操作への対応
///
/// 使用例:
/// ```dart
/// final converter = KanaConverterUtil();
///
/// // 入力テキストが変更されるたびに呼び出し
/// TextField(
///   onChanged: (value) {
///     final kana = converter.updateKana(value);
///     if (kana != null) {
///       // フリガナを更新
///       kanaController.text = kana;
///     }
///   },
/// )
/// ```
class KanaConverterUtil {
  final KanaKit _kanaKit;
  String _confirmedKana = ''; // 確定済みのフリガナ（漢字変換済み部分）
  String _currentKana = ''; // 現在処理中のフリガナ（ひらがな部分）
  String _previousHiraganaInput = ''; // 前回のひらがな入力値を保持する
  final fullWidthToHalfWidthMap = {
    'ア': 'ｱ',
    'イ': 'ｲ',
    'ウ': 'ｳ',
    'エ': 'ｴ',
    'オ': 'ｵ',
    'カ': 'ｶ',
    'キ': 'ｷ',
    'ク': 'ｸ',
    'ケ': 'ｹ',
    'コ': 'ｺ',
    'サ': 'ｻ',
    'シ': 'ｼ',
    'ス': 'ｽ',
    'セ': 'ｾ',
    'ソ': 'ｿ',
    'タ': 'ﾀ',
    'チ': 'ﾁ',
    'ツ': 'ﾂ',
    'テ': 'ﾃ',
    'ト': 'ﾄ',
    'ナ': 'ﾅ',
    'ニ': 'ﾆ',
    'ヌ': 'ﾇ',
    'ネ': 'ﾈ',
    'ノ': 'ﾉ',
    'ハ': 'ﾊ',
    'ヒ': 'ﾋ',
    'フ': 'ﾌ',
    'ヘ': 'ﾍ',
    'ホ': 'ﾎ',
    'マ': 'ﾏ',
    'ミ': 'ﾐ',
    'ム': 'ﾑ',
    'メ': 'ﾒ',
    'モ': 'ﾓ',
    'ヤ': 'ﾔ',
    'ユ': 'ﾕ',
    'ヨ': 'ﾖ',
    'ラ': 'ﾗ',
    'リ': 'ﾘ',
    'ル': 'ﾙ',
    'レ': 'ﾚ',
    'ロ': 'ﾛ',
    'ワ': 'ﾜ',
    'ヲ': 'ｦ',
    'ン': 'ﾝ',
    'ァ': 'ｧ',
    'ィ': 'ｨ',
    'ゥ': 'ｩ',
    'ェ': 'ｪ',
    'ォ': 'ｫ',
    'ッ': 'ｯ',
    'ャ': 'ｬ',
    'ュ': 'ｭ',
    'ョ': 'ｮ',
    'ガ': 'ｶﾞ',
    'ギ': 'ｷﾞ',
    'グ': 'ｸﾞ',
    'ゲ': 'ｹﾞ',
    'ゴ': 'ｺﾞ',
    'ザ': 'ｻﾞ',
    'ジ': 'ｼﾞ',
    'ズ': 'ｽﾞ',
    'ゼ': 'ｾﾞ',
    'ゾ': 'ｿﾞ',
    'ダ': 'ﾀﾞ',
    'ヂ': 'ﾁﾞ',
    'ヅ': 'ﾂﾞ',
    'デ': 'ﾃﾞ',
    'ド': 'ﾄﾞ',
    'バ': 'ﾊﾞ',
    'ビ': 'ﾋﾞ',
    'ブ': 'ﾌﾞ',
    'ベ': 'ﾍﾞ',
    'ボ': 'ﾎﾞ',
    'パ': 'ﾊﾟ',
    'ピ': 'ﾋﾟ',
    'プ': 'ﾌﾟ',
    'ペ': 'ﾍﾟ',
    'ポ': 'ﾎﾟ',
    'ヴ': 'ｳﾞ',
    'ー': 'ｰ',
    '　': ' '
  };

  /// KanaConverterUtilクラスのコンストラクタ
  ///
  /// 内部で使用する[KanaKit]インスタンスを初期化します。
  /// このクラスのインスタンスは、1つのテキスト入力フィールドに対して
  /// 1つ作成することを推奨します。
  KanaConverterUtil() : _kanaKit = const KanaKit();

  /// フリガナを更新する
  ///
  /// 入力された文字列からフリガナ（カタカナ）を生成します。
  ///
  /// パラメータ:
  /// * [value] - 変換対象の入力文字列
  ///
  /// 返り値:
  /// * 更新されたフリガナ（カタカナ）
  /// * 更新が不要な場合はnull
  /// * 入力が空の場合は空文字列
  ///
  /// 処理の流れ:
  /// 1. 空入力チェック
  /// 2. 入力全体をひらがなに変換
  /// 3. 漢字変換の検出と処理
  /// 4. ひらがな削除の処理
  /// 5. 新規入力のカナ変換
  String? updateKana(String value) {
    if (value.isEmpty) {
      reset();
      return '';
    }

    // 入力全体をひらがなに変換
    final hiraganaValue = _kanaKit.toHiragana(value);

    // 漢字変換の検出と処理
    if (_containsKanji(value)) {
      final lastKanjiIndex = _findLastKanjiIndex(value);
      if (lastKanjiIndex < value.length - 1) {
        // 漢字以降の部分のカナ変換
        final newInput = value.substring(lastKanjiIndex + 1);
        _currentKana = _extractKana(_kanaKit.toKatakana(newInput));
      } else {
        // 前回の入力と比較して漢字変換を検出
        final prevKanjiCount = _countKanji(_previousHiraganaInput);
        final currentKanjiCount = _countKanji(value);

        if (currentKanjiCount > prevKanjiCount) {
          // 漢字が増えている場合は漢字変換として扱う
          _confirmedKana += _currentKana;
          _currentKana = '';
        } else if (value.length < _previousHiraganaInput.length) {
          // 文字数が減少している場合は削除操作の可能性を確認
          final removedText = _previousHiraganaInput.substring(value.length);
          if (!_containsKanji(removedText)) {
            // 削除された文字が漢字を含まない場合は文字削除として扱う
            _currentKana = '';
          }
        } else {
          _currentKana = '';
        }
      }
    } else if (_currentKana.isNotEmpty && hiraganaValue.length < _previousHiraganaInput.length) {
      // ひらがな部分が減少している場合、漢字変換または削除と考える
      final removedLength = _previousHiraganaInput.length - hiraganaValue.length;
      if (removedLength > 0) {
        // 処理中の部分から削除される
        if (_currentKana.length >= removedLength) {
          _currentKana = _currentKana.substring(0, _currentKana.length - removedLength);
        } else {
          // 削除が確定済み部分にまで及ぶ場合
          final confirmedReduction = removedLength - _currentKana.length;
          _currentKana = '';
          _confirmedKana = _confirmedKana.substring(0, _confirmedKana.length - confirmedReduction);
        }
      }
      _previousHiraganaInput = hiraganaValue;
      return _confirmedKana + _currentKana;
    }

    // 新しい入力部分のカナを取得（漢字が含まれていない場合のみ）
    if (!_containsKanji(value) && value.length > _confirmedKana.length) {
      final newInput = value.substring(_confirmedKana.length);
      _currentKana = _extractKana(_kanaKit.toKatakana(newInput));
    }

    _previousHiraganaInput = hiraganaValue;
    return _confirmedKana + _currentKana;
  }

  /// フリガナの状態をリセットする
  ///
  /// 全ての内部状態を初期値に戻します。
  /// 新しい入力フィールドの処理を開始する前に呼び出してください。
  void reset() {
    _confirmedKana = '';
    _currentKana = '';
    _previousHiraganaInput = '';
  }

  /// 文字列からカタカナまたはひらがなのみを抽出する
  ///
  /// パラメータ:
  /// * [input] - 抽出対象の文字列
  ///
  /// 返り値:
  /// * カタカナまたはひらがなのみで構成された文字列
  String _extractKana(String input) {
    final buffer = StringBuffer();
    for (final char in input.characters) {
      if (fullWidthToHalfWidthMap.containsKey(char)) {
        buffer.write(fullWidthToHalfWidthMap[char] ?? char);
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  /// 文字列に漢字が含まれているかを判定する
  ///
  /// パラメータ:
  /// * [input] - 判定対象の文字列
  ///
  /// 返り値:
  /// * true: 漢字を含む
  /// * false: 漢字を含まない
  bool _containsKanji(String input) {
    for (final char in input.characters) {
      if (_kanaKit.isKanji(char)) {
        return true;
      }
    }
    return false;
  }

  /// 文字列内の最後の漢字の位置を取得する
  ///
  /// パラメータ:
  /// * [input] - 検索対象の文字列
  ///
  /// 返り値:
  /// * 最後の漢字のインデックス
  /// * 漢字が見つからない場合は-1
  int _findLastKanjiIndex(String input) {
    for (int i = input.length - 1; i >= 0; i--) {
      if (_kanaKit.isKanji(input[i])) {
        return i;
      }
    }
    return -1;
  }

  /// 文字列内の漢字の数をカウントする
  ///
  /// パラメータ:
  /// * [input] - カウント対象の文字列
  ///
  /// 返り値:
  /// * 漢字の文字数
  int _countKanji(String input) {
    int count = 0;
    for (final char in input.characters) {
      if (_kanaKit.isKanji(char)) {
        count++;
      }
    }
    return count;
  }
}
