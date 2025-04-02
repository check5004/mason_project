import 'package:flutter/material.dart';

/// -----------------------------------------------
/// [概要]   : キーボードを閉じるためのウィジェット
/// [作成者] : TCC S.Tate
/// [作成日] : 2024/11/06
/// -----------------------------------------------
class DismissKeyboard extends StatelessWidget {
  /// 子ウィジェットを保持するプロパティ
  final Widget child;

  /// -----------------------------------------------
  /// DismissKeyboardのコンストラクタ
  ///
  /// 引数:
  /// - `child`: 表示する子ウィジェットを指定します。
  ///
  /// このウィジェットは、画面のタップを検出してキーボードを閉じます。
  /// -----------------------------------------------
  const DismissKeyboard({super.key, required this.child});

  /// -----------------------------------------------
  /// 画面ビルド処理
  /// -----------------------------------------------
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent, // 子ウィジェットへのタップを許可
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
