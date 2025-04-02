import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../view_models/widget/progress_viewmodel.dart';

/// -----------------------------------------------
/// [概要]   :アプリケーション全体の進捗状況を表示するプログレスバーウィジェット
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/08
/// -----------------------------------------------
///
/// アプリケーション内の非同期処理の進捗状況を視覚的に表示するグローバルなプログレスバーです。
/// 進捗がある場合のみ表示され、進捗がない場合は自動的に非表示になります。
///
/// 主な特徴:
/// * 進捗状況に応じて動的に表示/非表示が切り替わる
/// * アニメーション付きの表示切り替え
/// * マテリアルデザインに準拠したスタイリング
class GlobalProgressBar extends ConsumerWidget {
  /// -----------------------------------------------
  /// GlobalProgressBarを構築するコンストラクタ
  ///
  /// 引数:
  /// * [key] - ウィジェットを識別するためのキー
  /// -----------------------------------------------
  const GlobalProgressBar({super.key});

  /// -----------------------------------------------
  /// 画面ビルド処理
  /// -----------------------------------------------
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalProgress = ref.watch(totalProgressProvider);
    final hasProgress = totalProgress > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: hasProgress ? 2 : 0,
      child:
          hasProgress
              ? LinearProgressIndicator(
                value: totalProgress,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
              )
              : null,
    );
  }
}
