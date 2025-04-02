import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/utils/com_util.dart';
import '../../../core/utils/talker_util.dart';
import '../parameter/custom_input_decoration.dart';

/// -----------------------------------------------
/// [概要]   :数値入力部品クラス
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/15
/// -----------------------------------------------
class NumberTextField extends ConsumerStatefulWidget {
  /// テキストフィールドのコントローラー
  final TextEditingController? controller;

  /// ウィジェットの幅
  final double? width;

  /// ウィジェットの高さ（オプショナル）
  final double? height;

  /// フィールド名（ラベル用、オプショナル）
  final String? name;

  /// 最大文字数（オプショナル）
  /// 小数点以下を含む、純粋な数値の桁数を指定してください。
  /// 例：maxLength=5の場合、"123.45"や"12345"が入力可能。
  /// カンマ区切り（isComma=true）、マイナス記号（isNegative=true）、小数点記号（isDecimalFraction=true）は
  /// 自動的に文字数制限に追加されるため考慮不要です。
  final int? maxLength;

  /// 必須フィールドかどうか
  final bool isRequired;

  /// 有効/無効フラグ
  final bool isEnabled;

  /// 読み取り専用フラグ（オプショナル、デフォルトはfalse）
  final bool? readOnly;

  /// フォーカスノード（オプショナル）
  final FocusNode? focusNode;

  /// テキストの整列（オプショナル、デフォルトは右揃え）
  final TextAlign? textAlign;

  /// 内部パディング（オプショナル）
  final EdgeInsets? contentPadding;

  /// テキストスタイル（オプショナル）
  final TextStyle? style;

  /// フォントサイズ（オプショナル）
  final double? fontSize;

  /// テキスト入力アクション（オプショナル）
  final TextInputAction? textInputAction;

  /// バリデーション関数（オプショナル）
  final String? Function(String?)? validator;

  /// フィールド送信時のコールバック関数（オプショナル）
  final Function? onFieldSubmitted;

  /// フィールド入力完了時のコールバック関数（オプショナル）
  final Function? onEditingComplete;

  /// フィールド変更時のコールバック関数（オプショナル）
  final Function(String)? onChanged;

  /// アイコンデータ（オプショナル）
  final IconData? icon;

  /// カンマ区切りを使用するかどうか
  final bool isComma;

  /// 小数点入力制御(false=入力不可、true=入力可 ※デフォルトはfalse)
  final bool isDecimalFraction;

  /// マイナス数値対応フラグ（オプショナル、デフォルトはfalse）
  final bool isNegative;

  /// インタラクションを無視するかどうか
  final bool isIgnore;

  /// 小数点以下の桁数（オプショナル）
  final int? decimalPlaces;

  /// 数値モードフラグ（true=数値モード：先頭0削除、false=コードモード：先頭0許容）
  final bool isNumberMode;

  /// ヒントテキスト（オプショナル）
  final String? hintText;

  /// デコレーションタイプ（オプショナル、デフォルトは通常のデコレーション）
  final bool noDecoration;

  /// -----------------------------------------------
  /// 数値入力部品クラスのコンストラクタ
  ///
  /// 数値のみを入力可能なテキストフィールドウィジェットを提供します。
  /// カンマ区切りの表示や、最大文字数の制限など、数値入力に特化した機能を持っています。
  ///
  /// パラメータ:
  /// * [controller] - テキストフィールドの入力を制御するコントローラー
  /// * [width] - ウィジェットの幅
  /// * [height] - ウィジェットの高さ
  /// * [name] - フィールド名（ラベル表示用）
  /// * [maxLength] - 最大入力文字数
  /// * [isRequired] - 必須入力項目かどうか
  /// * [isEnabled] - 入力可能かどうか
  /// * [readOnly] - 読み取り専用かどうか
  /// * [focusNode] - フォーカス制御用ノード
  /// * [textAlign] - テキストの配置
  /// * [contentPadding] - 内部の余白
  /// * [style] - テキストのスタイル
  /// * [fontSize] - フォントサイズ
  /// * [textInputAction] - キーボードのアクションボタン種別
  /// * [validator] - バリデーション関数
  /// * [onFieldSubmitted] - 入力確定時の処理
  /// * [onEditingComplete] - 編集完了時の処理
  /// * [onChanged] - テキスト変更時の処理
  /// * [icon] - 表示するアイコン
  /// * [isComma] - カンマ区切り表示の有無
  /// * [isDecimalFraction] - 小数点入力の可否
  /// * [isNegative] - マイナス値入力の可否
  /// * [isIgnore] - タッチ操作の無視
  /// * [decimalPlaces] - 小数点以下の桁数
  /// * [isNumberMode] - 数値モードの有無
  /// * [hintText] - プレースホルダーテキスト
  /// * [noDecoration] - デコレーション無しの設定
  /// -----------------------------------------------
  const NumberTextField({
    super.key,
    this.controller,
    this.width,
    this.height,
    this.name,
    this.maxLength,
    this.isRequired = false,
    this.isEnabled = true,
    this.readOnly = false,
    this.focusNode,
    this.textAlign = TextAlign.right,
    this.contentPadding,
    this.style,
    this.fontSize,
    this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onChanged,
    this.icon,
    this.isComma = false,
    this.isDecimalFraction = false,
    this.isNegative = false,
    this.isIgnore = false,
    this.decimalPlaces,
    this.isNumberMode = false,
    this.hintText,
    this.noDecoration = false,
  });

  @override
  NumberTextFieldState createState() => NumberTextFieldState();
}

/// -----------------------------------------------
/// [概要]   :数値入力部品の状態管理クラス
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/15
/// -----------------------------------------------
class NumberTextFieldState extends ConsumerState<NumberTextField> {
  late FocusNode _focusNode;

  /// -----------------------------------------------
  /// 初期化処理
  /// -----------------------------------------------
  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  /// -----------------------------------------------
  /// 破棄処理
  /// -----------------------------------------------
  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  /// -----------------------------------------------
  /// フォーカス変更時の処理
  ///
  /// フォーカスを取得した際にテキストを全選択状態にします
  /// -----------------------------------------------
  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      widget.controller?.selection = TextSelection(baseOffset: 0, extentOffset: widget.controller?.text.length ?? 0);
    }
  }

  /// -----------------------------------------------
  /// 画面ビルド処理
  /// -----------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width, // ウィジェットの幅を設定
      height: widget.height, // ウィジェットの高さを設定
      child: IgnorePointer(
        ignoring: widget.isIgnore || (widget.readOnly ?? false), // readOnlyまたはisIgnoreがtrueの場合、インタラクションを無視
        child: Focus(
          child: TextFormField(
            controller: widget.controller ?? TextEditingController(),
            maxLength:
                widget.maxLength != null
                    ? widget.maxLength! +
                        (widget.isComma ? (widget.maxLength! - 1) ~/ 3 : 0) + // カンマの数
                        (widget.isNegative ? 1 : 0) + // マイナス記号の分
                        (widget.isDecimalFraction ? 1 : 0) // 小数点の分
                    : null,
            keyboardType:
                widget.isNegative
                    ? const TextInputType.numberWithOptions(signed: true, decimal: true) // マイナスと小数点の入力を許可
                    : const TextInputType.numberWithOptions(decimal: true), // 数値入力キーボードを使用
            enabled: widget.isEnabled, // ウィジェットの有効/無効を設定
            focusNode: _focusNode, // カスタムフォーカスノードを使用
            textAlign: widget.textAlign ?? TextAlign.right, // テキストの整列を設定
            textAlignVertical: TextAlignVertical.center, // テキストの垂直方向の整列を中央に設定
            textInputAction: widget.textInputAction ?? TextInputAction.next, // テキスト入力アクションを設定
            inputFormatters: [
              _CustomNumberTextInputFormatter(
                isNegative: widget.isNegative,
                isDecimalFraction: widget.isDecimalFraction,
                decimalPlaces: widget.decimalPlaces,
                maxLength: widget.maxLength,
                isNumberMode: widget.isNumberMode,
              ),
            ],
            style: widget.style,
            readOnly: widget.readOnly ?? false,
            validator: (value) {
              if (widget.validator != null) return widget.validator!(value); // バリデーション関数がある場合はそれを返す

              if (widget.isRequired && value!.isEmpty) {
                return (widget.name ?? '') != '' ? '${widget.name}を入力してください' : '入力してください';
              }
              return null;
            },
            onTap: () {
              if (!(widget.readOnly ?? false)) {}
            },
            decoration: (widget.noDecoration ? NoDecorationInputDecoration(context) : CustomInputDecoration(context))
                .copyWith(
                  prefixIcon: widget.icon != null ? Icon(widget.icon) : null, // アイコンを設定
                  labelText: widget.name, // ラベルテキストを設定
                  hintText: widget.hintText, // ヒントテキストを設定
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.outline.withAlpha(156)),
                  contentPadding: widget.noDecoration ? const EdgeInsets.all(12) : widget.contentPadding, // 内部パディングを設定
                ),
            onChanged: (value) {
              if (widget.onChanged != null) widget.onChanged!(value); // フィールド変更時のコールバックを実行
            },
            onEditingComplete: () {
              if (widget.onEditingComplete != null) widget.onEditingComplete!();
              _formatAndUpdateText();
            },
            onFieldSubmitted: (value) {
              _formatAndUpdateText();
              if (widget.onFieldSubmitted != null) {
                widget.onFieldSubmitted!(value); // フィールド送信時のコールバックを実行
              } else if (widget.textInputAction == TextInputAction.next) {
                // textInputActionがNextの場合、フォーカスを次のTextFieldに移動する
                FocusScope.of(context).nextFocus();
              } else if (widget.textInputAction == TextInputAction.done) {
                // textInputActionがDoneの場合、キーボードを閉じる
                FocusScope.of(context).unfocus();
              }
            },
          ),
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              _formatAndUpdateText();
              _removeInvalidCharacters();
            }
          },
        ),
      ),
    );
  }

  /// -----------------------------------------------
  /// テキストのフォーマットと更新処理
  ///
  /// 入力されたテキストを適切な数値形式にフォーマットし、
  /// コントローラーの値を更新します。
  /// -----------------------------------------------
  void _formatAndUpdateText() {
    String text = widget.controller?.text ?? '';
    if (text.isEmpty) {
      return; // 空の入力の場合は何もしない
    }
    bool isNegative = text.startsWith('-');
    text = text.replaceAll('-', '');
    List<String> parts = text.split('.');
    String integerPart = widget.isComma ? ComUtil.removeComma(parts[0]) : parts[0];
    String fractionalPart = parts.length > 1 ? parts[1] : '';

    if (integerPart.isEmpty && fractionalPart.isEmpty) {
      widget.controller?.text = ''; // 整数部も小数部も空の場合は空文字を設定
      return;
    }

    // 数値モードの場合、先頭の0を削除
    if (widget.isNumberMode && integerPart.isNotEmpty) {
      integerPart = int.parse(integerPart).toString();
    }

    if (widget.isDecimalFraction && widget.decimalPlaces != null) {
      // 小数点以下の桁数が指定されている場合、常に指定された桁数で0埋めする
      fractionalPart = fractionalPart.padRight(widget.decimalPlaces!, '0').substring(0, widget.decimalPlaces!);
    } else if (!widget.isDecimalFraction) {
      fractionalPart = ''; // 小数点入力が許可されていない場合は小数部を空にする
    }

    if (widget.isComma) {
      integerPart = integerPart.isEmpty ? '0' : ComUtil.addComma(integerPart);
    } else {
      integerPart = integerPart.isEmpty ? '0' : integerPart;
    }

    text = integerPart + (fractionalPart.isNotEmpty ? '.$fractionalPart' : '');
    text = isNegative ? '-$text' : text;

    widget.controller?.text = text;
    widget.controller?.selection = TextSelection.fromPosition(TextPosition(offset: text.length));
  }

  /// -----------------------------------------------
  /// 無効な文字の削除処理
  ///
  /// 入力された文字列から数値として無効な文字を
  /// 削除します。
  /// -----------------------------------------------
  void _removeInvalidCharacters() {
    String text = widget.controller?.text ?? '';
    // ここで入力禁止文字を削除するロジックを追加
    // 例: 数字と小数点のみを許可する場合
    text = text.replaceAll(RegExp(r'[^0-9,.-]'), '');
    widget.controller?.text = text;
  }
}

/// -----------------------------------------------
/// [概要]   :カスタム数値入力フォーマッタークラス
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/15
/// -----------------------------------------------
class _CustomNumberTextInputFormatter extends TextInputFormatter {
  /// マイナス数値対応フラグ
  final bool isNegative;

  /// 小数点入力制御
  final bool isDecimalFraction;

  /// 小数点以下の桁数
  final int? decimalPlaces;

  /// 最大文字数
  final int? maxLength;

  /// 数値モードフラグ
  final bool isNumberMode;

  /// -----------------------------------------------
  /// カスタム数値入力フォーマッタークラスのコンストラクタ
  ///
  /// パラメータ:
  /// * [isNegative] - マイナス値入力の可否
  /// * [isDecimalFraction] - 小数点入力の可否
  /// * [decimalPlaces] - 小数点以下の桁数
  /// * [maxLength] - 最大入力文字数
  /// * [isNumberMode] - 数値モードの有無
  /// -----------------------------------------------
  _CustomNumberTextInputFormatter({
    required this.isNegative,
    required this.isDecimalFraction,
    this.decimalPlaces,
    this.maxLength,
    this.isNumberMode = false,
  });

  /// -----------------------------------------------
  /// テキスト編集時のフォーマット処理
  /// -----------------------------------------------
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // 変換中の文字列がある場合はそのまま返す
    if (newValue.composing.isValid) return newValue;

    try {
      String newText = newValue.text;

      // マイナス記号の処理
      bool isNegativeStart = newText.startsWith('-');
      newText = newText.replaceAll('-', '');

      // 入力値が空の場合は空の値を返す
      if (newText.isEmpty) {
        return TextEditingValue(
          text: isNegativeStart ? '-' : '',
          selection: TextSelection.collapsed(offset: isNegativeStart ? 1 : 0),
        );
      }

      // 小数点の処理
      List<String> parts = newText.split('.');
      String integerPart = parts[0].replaceAll(RegExp(r'[^0-9]'), '');
      String fractionalPart = parts.length > 1 ? parts[1].replaceAll(RegExp(r'[^0-9]'), '') : '';

      // 整数部の桁数制限
      int maxIntegerDigits = maxLength != null && decimalPlaces != null ? maxLength! - decimalPlaces! : maxLength ?? -1;
      if (maxIntegerDigits > 0 && integerPart.length > maxIntegerDigits) {
        integerPart = integerPart.substring(0, maxIntegerDigits);
      }

      // 小数部の桁数制限
      if (isDecimalFraction) {
        if (decimalPlaces != null && fractionalPart.length > decimalPlaces!) {
          fractionalPart = fractionalPart.substring(0, decimalPlaces!);
        }
      } else {
        fractionalPart = '';
      }

      // 数値モードの場合、先頭の0を削除
      if (isNumberMode && integerPart.isNotEmpty) {
        integerPart = int.parse(integerPart).toString();
      }

      // テキストの再構築
      String formattedText = integerPart;
      if (isDecimalFraction && (fractionalPart.isNotEmpty || newText.endsWith('.'))) {
        formattedText += '.$fractionalPart';
      }
      if (isNegativeStart && isNegative) {
        formattedText = '-$formattedText';
      }

      // カーソル位置の調整
      int selectionIndex = formattedText.length;
      return TextEditingValue(text: formattedText, selection: TextSelection.collapsed(offset: selectionIndex));
    } catch (e, stackTrace) {
      talker.warning(e, stackTrace);
      return newValue;
    }
  }
}
