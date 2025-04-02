import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/utils/com_util.dart';

/// -----------------------------------------------
/// [概要]   :カスタム化されたセグメンテッドボタンウィジェット。
///           オプションのリストから選択し、変更をハンドルする。
///           単一選択・複数選択に対応し、選択解除機能も備えている。
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/15
/// -----------------------------------------------

/// 選択されたオプションを管理するStateProvider
///
/// キーごとに選択状態を保持するためのStateProvider。
/// Set<String>型で選択されたオプションを保持する。
final selectedOptionsProvider = StateProvider.family<Set<String>, String>((ref, key) => {});

/// カスタマイズ可能なセグメンテッドボタンウィジェット
class CustomSegmentedButtonWidget extends HookConsumerWidget {
  /// オプションのリストを提供する
  final List<String> options;

  /// 初期選択されているオプション
  final Set<String> selected;

  /// 複数選択を可能にするかどうか
  final bool isMultiSelect;

  /// 選択が変更されたときに呼び出されるコールバック
  final Function(Set<String>) onSelectionChanged;

  /// 読み取り専用モードのフラグ
  final bool isReadOnly;

  /// 選択解除を許可するかどうか（単一選択・複数選択両方に適用）
  final bool isDeselectEnabled;

  /// ## CustomSegmentedButton コンストラクタ
  ///
  /// カスタマイズ可能なセグメンテッドボタンを作成します。
  /// 単一選択・複数選択に対応し、選択解除機能も備えています。
  ///
  /// __パラメータ:__
  /// * `options`: 選択肢として表示される文字列のリスト
  /// * `selected`: 初期状態で選択されている選択肢（デフォルト: null）
  /// * `isMultiSelect`: 複数選択を許可するかどうか（デフォルト: false）
  /// * `onSelectionChanged`: 選択が変更されたときに呼び出される関数
  /// * `isReadOnly`: 読み取り専用モードを有効にするかどうか（デフォルト: false）
  /// * `isDeselectEnabled`: 選択解除を許可するかどうか（デフォルト: false）
  const CustomSegmentedButtonWidget({
    super.key,
    required this.options,
    this.selected = const {},
    this.isMultiSelect = false,
    required this.onSelectionChanged,
    this.isReadOnly = false,
    this.isDeselectEnabled = false,
  });

  /// -----------------------------------------------
  /// 画面ビルド処理
  /// -----------------------------------------------
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uniqueKey = useMemoized(() => UniqueKey().toString(), const []);

    useEffect(() {
      Future.microtask(() {
        if (selected.isNotEmpty && !isMultiSelect) {
          ref.read(selectedOptionsProvider(uniqueKey).notifier).state = {selected.first};
        } else if (isDeselectEnabled) {
          ref.read(selectedOptionsProvider(uniqueKey).notifier).state = selected;
        } else {
          ref.read(selectedOptionsProvider(uniqueKey).notifier).state = options.isNotEmpty ? {options.first} : {};
        }
      });
      return null;
    }, [selected, options, isDeselectEnabled]);

    final selectedOptions = ref.watch(selectedOptionsProvider(uniqueKey));
    TextStyle optionTextStyle = const TextStyle();
    final bool isSelected = options.any((option) => selectedOptions.contains(option));
    double maxOptionWidth = calculateMaxOptionWidth(options, optionTextStyle);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<String>(
        style: ButtonStyle(
          padding: isSelected ? null : WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 27)),
        ),
        segments:
            options.map((option) {
              return ButtonSegment(
                value: option,
                label: SizedBox(
                  width: maxOptionWidth,
                  child: Text(option, style: optionTextStyle, textAlign: TextAlign.center),
                ),
              );
            }).toList(),
        selected: selectedOptions.isEmpty && !isDeselectEnabled ? {options.first} : selectedOptions,
        onSelectionChanged:
            isReadOnly
                ? null
                : (newSelection) {
                  final notifier = ref.read(selectedOptionsProvider(uniqueKey).notifier);
                  if (isMultiSelect) {
                    if (isDeselectEnabled) {
                      notifier.state = newSelection;
                    } else {
                      notifier.state = newSelection.isEmpty ? selectedOptions : newSelection;
                    }
                  } else {
                    if (selectedOptions.isNotEmpty && newSelection.isEmpty) {
                      if (isDeselectEnabled) {
                        notifier.state = {};
                      }
                    } else {
                      notifier.state = {newSelection.last};
                    }
                  }
                  onSelectionChanged(notifier.state);
                },
        multiSelectionEnabled: isMultiSelect || isDeselectEnabled,
        emptySelectionAllowed: isDeselectEnabled,
      ),
    );
  }

  /// オプションの最大幅を計算する
  ///
  /// 与えられたオプションリストの中で最も幅の広いテキストの幅を計算して返します。
  /// これにより、すべてのセグメントが同じ幅を持つようになります。
  ///
  /// __パラメータ:__
  /// * `options`: 幅を計算する対象のオプションリスト
  /// * `textStyle`: テキストのスタイル設定
  ///
  /// __戻り値:__
  /// * `double`: 計算された最大幅
  double calculateMaxOptionWidth(List<String> options, TextStyle textStyle) {
    double maxWidth = 0.0;
    for (String option in options) {
      double width = ComUtil.getTextWidth(option, style: textStyle);
      if (width > maxWidth) {
        maxWidth = width;
      }
    }
    return maxWidth;
  }
}
