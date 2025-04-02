import 'package:flutter/material.dart';

import '../../../core/theme/app_color_scheme.dart';

/// 入力フォームのウィジェット
///
/// 4列の入力フォーム
/// 1. タイトル [`String`]
/// 2. ファーストウィジェット [`Widget`]
/// 3. 繋ぎウィジェット [`Widget`]
/// 4. セカンドウィジェット [`Widget`]
/// 5. 下ウィジェット [`Widget`]
class InputWidget extends StatefulWidget {
  const InputWidget({
    super.key,
    required this.title,
    this.height,
    this.citationColor = InputWidgetCitationColor.normal,
    this.isFirstWidgetExpanded = false,
    required this.firstWidget,
    this.middleWidget,
    this.secondWidget,
    this.underWidget,
  });

  final String title;
  final double? height;
  final InputWidgetCitationColor citationColor;
  final bool isFirstWidgetExpanded;
  final Widget firstWidget;
  final Widget? middleWidget;
  final Widget? secondWidget;
  final Widget? underWidget;
  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  Widget build(BuildContext context) {
    const double textFieldHeight = 58;

    return Container(
      height: widget.height,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              // 左の線
              Container(
                width: 4,
                height: textFieldHeight,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: widget.citationColor.getColor(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              // タイトル
              Container(
                width: 100,
                height: textFieldHeight,
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(widget.title, style: Theme.of(context).textTheme.bodyMedium),
                ),
              ),
              const SizedBox(width: 12),
              // ファーストウィジェット
              Expanded(flex: widget.isFirstWidgetExpanded ? 2 : 1, child: Center(child: widget.firstWidget)),
              if (!widget.isFirstWidgetExpanded) ...[
                // 繋ぎウィジェット
                SizedBox(
                  height: textFieldHeight,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [widget.middleWidget ?? const SizedBox.shrink(), const SizedBox(width: 40)],
                  ),
                ),
                // セカンドウィジェット
                Expanded(child: Center(child: widget.secondWidget)),
              ],
              const SizedBox(width: 12),
            ],
          ),
          // 下ウィジェット
          if (widget.underWidget != null)
            Padding(padding: const EdgeInsets.only(top: 2, left: 128), child: widget.underWidget),
        ],
      ),
    );
  }
}

/// タイトル横に引用っぽく色をつける色の定義クラス
enum InputWidgetCitationColor {
  /// 必須項目
  required,

  /// 一つだけ必須の項目
  singleRequired,

  /// 通常項目
  normal,

  /// 透明
  transparent;

  Color getColor(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;

    switch (this) {
      case InputWidgetCitationColor.required:
        return appColorScheme.inputRequired;
      case InputWidgetCitationColor.singleRequired:
        return appColorScheme.inputSingleRequired;
      case InputWidgetCitationColor.normal:
        return appColorScheme.inputNormal;
      case InputWidgetCitationColor.transparent:
        return Colors.transparent;
    }
  }
}
