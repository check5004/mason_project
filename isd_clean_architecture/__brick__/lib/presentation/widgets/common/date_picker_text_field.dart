import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../view_models/widget/date_picker_viewmodel.dart';
import '../parameter/custom_input_decoration.dart';

/// -----------------------------------------------
/// [概要]   :日付入力用のカスタムテキストフィールドウィジェット
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/06
/// -----------------------------------------------
class DatePickerTextField extends HookConsumerWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final double? width;
  final String? name;
  final int maxYear;
  final bool? isRequired;
  final String clearDate;
  final bool enabled;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final InputDecoration? decoration;

  /// -----------------------------------------------
  /// DatePickerTextFieldのコンストラクタ
  ///
  /// 日付入力フィールドを作成し、カレンダーからの日付選択や
  /// 手動入力による日付設定が可能なウィジェットを構築します。
  ///
  /// **パラメータ**:
  /// * `controller`: テキストフィールドの値を制御するコントローラ
  /// * `focusNode`: フォーカス制御用のノード
  /// * `width`: ウィジェットの幅
  /// * `name`: フィールドのラベル名
  /// * `maxYear`: 選択可能な最大年（デフォルト: 2100年）
  /// * `isRequired`: 必須入力項目かどうか
  /// * `isEnabled`: 入力できるかどうか
  /// * `clearDate`: クリア時の日付文字列
  /// * `textInputAction`: キーボードのアクション種別
  /// * `onFieldSubmitted`: フィールド確定時のコールバック
  /// * `onChanged`: 値変更時のコールバック
  /// * `decoration`: カスタム入力デコレーション
  /// -----------------------------------------------
  const DatePickerTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.width,
    this.name,
    this.maxYear = 2100,
    this.isRequired,
    this.enabled = true,
    this.clearDate = '',
    this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
    this.decoration,
  });

  /// -----------------------------------------------
  /// イベントコールバックを処理するヘルパーメソッド
  ///
  /// 指定された値に対して、onChangedとonFieldSubmittedの
  /// コールバックを実行します。
  ///
  /// **パラメータ**:
  /// * `text`: コールバックに渡すテキスト値
  /// * `onChanged`: 値変更時のコールバック関数
  /// * `onFieldSubmitted`: フィールド確定時のコールバック関数
  /// -----------------------------------------------
  void _handleEventCallbacks(String text, {Function? onChanged, Function? onFieldSubmitted}) {
    if (onChanged != null) {
      onChanged(text);
    }
    if (onFieldSubmitted != null) {
      onFieldSubmitted(text);
    }
  }

  /// -----------------------------------------------
  /// 画面ビルド処理
  /// -----------------------------------------------
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = useMemoized(() => (key ?? UniqueKey()).toString(), const []);
    final viewModel = ref.watch(datePickerViewModelProvider(id).notifier);
    final state = ref.watch(datePickerViewModelProvider(id));

    // エラーメッセージを管理するState
    final errorText = useState<String?>(null);

    // 初期化：コントローラの初期値がある場合、ViewModelの状態を更新
    useEffect(() {
      if (controller != null && controller!.text.isNotEmpty) {
        Future.microtask(() {
          viewModel.updateText(controller!.text);
        });
      }
      return null;
    }, []);

    // TextFieldの値を監視して更新（無限ループ防止のためのチェックを追加）
    useEffect(() {
      if (controller != null && controller!.text != state.dateText) {
        Future.microtask(() {
          controller!.text = state.dateText;
        });
      }
      return null;
    }, [state.dateText]);

    Future<void> selectDate() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: state.selectedDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(maxYear),
        locale: const Locale('ja', 'JP'),
      );

      if (picked != null) {
        // 先にViewModelの状態を更新
        viewModel.updateDate(picked);
        errorText.value = null;

        // 状態が更新された後の最新の値を使用してコールバックを実行
        final updatedText = ref.read(datePickerViewModelProvider(id)).dateText;
        _handleEventCallbacks(updatedText, onChanged: onChanged, onFieldSubmitted: onFieldSubmitted);
      }
    }

    return SizedBox(
      width: width,
      child: TextFormField(
        textInputAction: textInputAction ?? TextInputAction.next,
        focusNode: focusNode,
        enabled: enabled,
        controller: controller ?? TextEditingController(),
        keyboardType: TextInputType.number, // 数値キーボードを使用
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
          LengthLimitingTextInputFormatter(10), // 10桁までの制限
        ],
        validator: validator,
        decoration: (decoration ?? CustomInputDecoration(context)).copyWith(
          labelText: name,
          errorText: errorText.value,
          suffixIcon: UnconstrainedBox(
            child: IconButton(
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.edit_calendar),
              onPressed: selectDate,
            ),
          ),
        ),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: enabled ? null : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 100),
        ),
        onChanged: (value) {
          if (!enabled) return;
          if (!viewModel.isValidInputting(value)) {
            errorText.value = '日付が不正です。';
            return;
          }
          errorText.value = null; // エラーをクリア
          viewModel.updateText(value);

          // ViewModelの状態が更新された後にコールバックを実行
          if (onChanged != null && controller != null) {
            onChanged!(controller!.text);
          }
        },
        onEditingComplete: () {
          // フォーカスアウト時のバリデーション
          if (!viewModel.isCompleteDate(controller?.text ?? '')) {
            errorText.value = '日付が不正です。';
            return;
          }
          errorText.value = null;
        },
        onFieldSubmitted: (value) {
          if (!viewModel.isCompleteDate(value)) {
            errorText.value = '日付が不正です。';
            return;
          }
          errorText.value = null; // エラーをクリア

          // ViewModelの状態が更新された後にコールバックを実行
          if (onFieldSubmitted != null && controller != null) {
            onFieldSubmitted!(controller!.text);
          }
        },
      ),
    );
  }
}
