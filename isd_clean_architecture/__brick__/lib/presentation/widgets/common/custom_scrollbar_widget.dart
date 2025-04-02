import 'package:flutter/material.dart';

/// -----------------------------------------------
/// [概要]   :カスタマイズされたスクロールバーを提供するウィジェット
/// [作成者] :TCC S.Tate
/// [作成日] :2024/10/24
/// -----------------------------------------------
class CustomScrollbarWidget extends StatelessWidget {
  /// カスタマイズされたスクロールバーを作成します。
  ///
  /// このウィジェットは、標準のスクロールバーをカスタマイズして、
  /// より使いやすいインターフェースを提供します。
  ///
  /// 引数:
  /// - `controller`: スクロールの制御に使用される[ScrollController]
  /// - `child`: スクロール可能な内容を含むウィジェット
  const CustomScrollbarWidget({
    super.key,
    required this.controller,
    required this.child,
  });

  /// スクロールの制御に使用される[ScrollController]
  final ScrollController controller;

  /// スクロール可能な内容を含むウィジェット
  final Widget child;

  /// -----------------------------------------------
  /// 画面ビルド処理
  /// -----------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      radius: const Radius.circular(10),
      interactive: true,
      controller: controller,
      child: child,
    );
  }
}
