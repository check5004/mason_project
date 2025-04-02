import 'package:talker_flutter/talker_flutter.dart';

import '../constants/config.dart';

/// -----------------------------------------------
/// [概要]   :アプリケーション全体のログ管理を行うユーティリティ
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/25
/// -----------------------------------------------

/// アプリケーション全体で使用するTalkerインスタンス
final Talker talker = TalkerFlutter.init(
  settings: TalkerSettings(
    timeFormat: TimeFormat.yearMonthDayAndTime,
    maxHistoryItems: Config.talkerConfig.maxHistoryItems ?? 1000,
  ),
);

/// Talkerのログ設定を管理するクラス
class TalkerConfig {
  /// Riverpodのログを有効にするかどうか
  final bool enableRiverpodLogs;

  /// 最大履歴数
  final int? maxHistoryItems;

  /// Talkerの設定
  /// * [enableRiverpodLogs] : Riverpodのログを有効にするかどうか
  /// * [maxHistoryItems] : 最大履歴数 (default: 1000)
  const TalkerConfig({required this.enableRiverpodLogs, this.maxHistoryItems});
}
