import 'package:hooks_riverpod/hooks_riverpod.dart';

/// -----------------------------------------------
/// [概要]   :アプリケーション全体の進捗状態を管理するProvider
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/08
/// -----------------------------------------------
///
/// 複数の非同期処理の進捗状況を一元管理し、UIに反映するためのProviderです。
///
/// 使用例:
/// ```dart
/// // 進捗状態の監視
/// final progress = ref.watch(progressManagerProvider);
///
/// // 進捗状態の更新
/// ref.read(progressManagerProvider.notifier).startProgress('operation1');
/// ```
final progressManagerProvider = StateNotifierProvider<ProgressManager, Map<String, double>>((ref) {
  return ProgressManager();
});

/// -----------------------------------------------
/// [概要]   :全ての進捗状態の合計値を計算するProvider
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/08
/// -----------------------------------------------
///
/// 現在実行中の全ての進捗の平均値を計算し、0.0から1.0の範囲で提供します。
///
/// 使用例:
/// ```dart
/// // 全体の進捗状況を取得
/// final totalProgress = ref.watch(totalProgressProvider);
/// ```
final totalProgressProvider = Provider<double>((ref) {
  final progressMap = ref.watch(progressManagerProvider);
  if (progressMap.isEmpty) return 0.0;

  final total = progressMap.values.reduce((a, b) => a + b);
  return total / progressMap.length;
});

/// -----------------------------------------------
/// [概要]   :進捗状態を管理するStateNotifierクラス
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/08
/// -----------------------------------------------
///
/// 複数の非同期処理の進捗状態を管理し、進捗の開始、更新、完了を制御します。
///
/// 主な機能:
/// * 個別の進捗状態の管理
/// * 進捗状態の更新と監視
/// * 非同期処理の進捗付き実行
class ProgressManager extends StateNotifier<Map<String, double>> {
  /// -----------------------------------------------
  /// ProgressManagerを初期化するコンストラクタ
  ///
  /// 空の進捗マップで初期化されます。
  /// -----------------------------------------------
  ProgressManager() : super({});

  /// -----------------------------------------------
  /// 指定されたIDの進捗を開始する
  ///
  /// 引数:
  /// * [id] - 進捗を識別するための一意のID
  ///
  /// 使用例:
  /// ```dart
  /// progressManager.startProgress('download_operation');
  /// ```
  /// -----------------------------------------------
  void startProgress(String id) {
    state = {...state, id: 0.0};
  }

  /// -----------------------------------------------
  /// 指定されたIDの進捗を更新する
  ///
  /// 引数:
  /// * [id] - 更新する進捗のID
  /// * [progress] - 新しい進捗値（0.0から1.0の範囲）
  ///
  /// 使用例:
  /// ```dart
  /// progressManager.updateProgress('download_operation', 0.5);
  /// ```
  /// -----------------------------------------------
  void updateProgress(String id, double progress) {
    if (state.containsKey(id)) {
      state = {...state, id: progress.clamp(0.0, 1.0)};
    }
  }

  /// -----------------------------------------------
  /// 指定されたIDの進捗を完了し、状態から削除する
  ///
  /// 引数:
  /// * [id] - 完了する進捗のID
  ///
  /// 使用例:
  /// ```dart
  /// progressManager.completeProgress('download_operation');
  /// ```
  /// -----------------------------------------------
  void completeProgress(String id) {
    final newState = Map<String, double>.from(state);
    newState.remove(id);
    state = newState;
  }

  /// -----------------------------------------------
  /// 全ての進捗状態をリセットする
  ///
  /// 使用例:
  /// ```dart
  /// progressManager.reset();
  /// ```
  /// -----------------------------------------------
  void reset() {
    state = {};
  }

  /// -----------------------------------------------
  /// 進捗状態付きで非同期処理を実行する
  ///
  /// 引数:
  /// * [progressId] - 進捗を識別するための一意のID
  /// * [operation] - 実行する非同期処理
  ///
  /// 使用例:
  /// ```dart
  /// final result = await progressManager.executeWithProgress(
  ///   progressId: 'download',
  ///   operation: ({onSendProgress, onReceiveProgress}) =>
  ///     api.downloadFile(
  ///       onSendProgress: onSendProgress,
  ///       onReceiveProgress: onReceiveProgress,
  ///     ),
  /// );
  /// ```
  /// -----------------------------------------------
  Future<T> executeWithProgress<T>({
    required String progressId,
    required Future<T> Function({
      void Function(int, int)? onSendProgress,
      void Function(int, int)? onReceiveProgress,
    }) operation,
  }) async {
    startProgress(progressId);

    try {
      final result = await operation(
        onSendProgress: (sent, total) {
          final progress = total > 0 ? (sent / total) * 0.5 : 0.0;
          updateProgress(progressId, progress);
        },
        onReceiveProgress: (received, total) {
          final progress = total > 0 ? 0.5 + (received / total) * 0.5 : 0.5;
          updateProgress(progressId, progress);
        },
      );

      completeProgress(progressId);
      return result;
    } catch (e) {
      completeProgress(progressId);
      rethrow;
    }
  }
}

/// -----------------------------------------------
/// [概要]   :1ページあたりの表示件数を管理するViewModel
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/13
/// -----------------------------------------------
class ItemsPerPageSelectorViewModel extends StateNotifier<int> {
  ItemsPerPageSelectorViewModel({int initialValue = 15}) : super(initialValue);

  void changeItemsPerPage(int newValue) {
    state = newValue;
  }
}

/// -----------------------------------------------
/// [概要]   :ItemsPerPageSelectorViewModelのプロバイダーを生成する関数
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/13
/// -----------------------------------------------
StateNotifierProvider<ItemsPerPageSelectorViewModel, int> createItemsPerPageSelectorProvider({
  int initialValue = 15,
}) {
  return StateNotifierProvider<ItemsPerPageSelectorViewModel, int>(
    (ref) => ItemsPerPageSelectorViewModel(initialValue: initialValue),
  );
}
