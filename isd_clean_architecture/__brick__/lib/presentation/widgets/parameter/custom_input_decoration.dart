import 'package:flutter/material.dart';

/// -----------------------------------------------
/// [概要]   :カスタム入力デコレーション
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/05
/// -----------------------------------------------
///
/// カスタム入力デコレーションを提供します。
/// デフォルトのOutlineInputBorderを使用します。
class CustomInputDecoration extends InputDecoration {
  CustomInputDecoration(BuildContext context)
      : super(
          border: const OutlineInputBorder(),
          counterText: '',
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.outline.withAlpha(156)),
        );
}

/// デコレーションなしの入力デコレーション
class NoDecorationInputDecoration extends InputDecoration {
  NoDecorationInputDecoration(BuildContext context)
      : super(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          counterText: '',
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.outline.withAlpha(156)),
        );
}
