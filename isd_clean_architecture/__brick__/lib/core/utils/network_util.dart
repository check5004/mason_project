import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../network/dio_interceptor.dart';
import 'message_util.dart' as message_util;
import 'talker_util.dart';

/// -----------------------------------------------
/// [概要]   :ネットワーク関連のユーティリティクラス
/// [作成者] :TCC S.Tate
/// [作成日] :2025/02/20
/// -----------------------------------------------
class NetworkUtil {
  /// ネットワーク接続をチェックし、接続が復帰するまで待機する
  ///
  /// ネットワーク接続状態を確認し、接続が切断されている場合は復帰するまで待機する
  /// タイムアウトが設定されている場合は、指定時間経過後に処理を終了する
  ///
  /// * [context] - 現在のビルドコンテキスト（null許可）
  /// * [ref] - ProviderのRefオブジェクト
  /// * [timeoutSeconds] - タイムアウト時間（秒）（デフォルト: -1）
  ///
  /// 戻り値:
  /// * [true] - 接続が確立されている場合、または接続が復帰した場合
  /// * [false] - タイムアウトした場合
  static Future<bool> checkAndWaitForConnectivity({BuildContext? context, ref, int timeoutSeconds = -1}) async {
    const delay = Duration(milliseconds: 100);
    final completer = Completer<bool>();
    late StreamSubscription<List<ConnectivityResult>> subscription;
    List<ConnectivityResult> latestResults = [];

    // 接続状態の監視を開始
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      latestResults = results;

      if (!results.contains(ConnectivityResult.none) && results.isNotEmpty) {
        subscription.cancel();

        if (context != null && context.mounted) {
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }

        if (!completer.isCompleted) {
          completer.complete(true);
        }
      }
    }, cancelOnError: false);

    // 現在の接続状態を確認
    final currentResults = await Connectivity().checkConnectivity();
    latestResults.addAll(currentResults);

    // 既に接続が確立されている場合は即時完了
    if (!currentResults.contains(ConnectivityResult.none) && currentResults.isNotEmpty) {
      subscription.cancel();
      if (!completer.isCompleted) {
        completer.complete(true);
      }
      return await completer.future;
    }

    // ダイアログ表示
    Future.delayed(delay).then((_) {
      if (latestResults.contains(ConnectivityResult.none) && ref != null) {
        final message = message_util.MessageUtil.message.networkUnavailable;
        if (context != null && context.mounted) {
          message_util.MessageUtil.showMsgDialog(
            context: context,
            title: 'エラー',
            msg: message,
            dialogType: DialogType.error,
            hideOkButton: timeoutSeconds == 0 ? false : true,
          );
        } else if (ref != null) {
          final dialogData = message_util.DialogData(
            message: message,
            dialogType: DialogType.error,
            hideOkButton: timeoutSeconds == 0 ? false : true,
          );
          ref.read(message_util.dialogStateProvider.notifier).showDialog(dialogData);
        }
      }
    });

    // タイムアウト設定
    if (timeoutSeconds > 0) {
      Future.delayed(Duration(seconds: timeoutSeconds)).then((_) {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      });
    } else if (timeoutSeconds == 0) {
      Future.delayed(delay).then((_) {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      });
    }

    // 処理終了後のダイアログ閉じる処理
    completer.future.then((value) {
      if (context != null && context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else if (ref != null) {
        final dialogData = ref.read(message_util.dialogStateProvider);
        if (dialogData?.hideOkButton == true) {
          ref.read(message_util.dialogStateProvider.notifier).hideDialog();
        }
      }
    });

    final result = await completer.future;
    return result;
  }

  /// ネットワーク接続を監視しながらAPI処理を実行する
  ///
  /// [apiCall] 実行したいAPI呼び出し処理
  /// [maxRetry] 最大リトライ回数
  /// [recoveryDelay] 復帰後の待機時間（秒）
  /// [enableRetry] リトライを有効にするかどうか
  /// [ref] プロバイダー参照
  static Future<T> withNetworkMonitoring<T>({
    required Future<T> Function() apiCall,
    int maxRetry = 2,
    int recoveryDelay = 5,
    bool enableRetry = true,
    required Ref ref,
  }) async {
    // リトライカウンター
    int retryCount = 0;

    // 最後に検知された接続状態
    bool lastConnectionState = true; // 初期状態は接続あり

    // リトライフラグ - リトライが予定されているかどうか
    bool retryScheduled = false;

    // 接続状態変更の処理中フラグ
    bool isProcessingConnectivityChange = false;

    // ノイズ吸収用のDelay時間（ミリ秒）
    const noiseFilterDelayMs = 100;

    // 最新の接続状態を追跡する変数
    List<ConnectivityResult> latestConnectivityResults = [];
    bool hasStableConnection = true; // 初期状態は接続ありと仮定

    // Completer
    final completer = Completer<T>();

    // 接続監視用のサブスクリプション
    StreamSubscription<List<ConnectivityResult>>? subscription;

    // リソース解放用の関数
    void cleanupResources() {
      if (subscription != null) {
        subscription!.cancel();
        subscription = null;
      }
    }

    // completerが完了した時の共通処理
    completer.future.whenComplete(() {
      cleanupResources();
    });

    try {
      // 接続状態を評価する関数
      bool evaluateConnection(List<ConnectivityResult> results) {
        return !results.contains(ConnectivityResult.none) && results.isNotEmpty;
      }

      // リクエスト実行関数
      Future<void> executeRequest() async {
        try {
          T result;

          // リトライが無効の場合は、既存の接続確認処理を使う
          if (!enableRetry) {
            // 実際のAPIコールを実行
            // 接続確認が完了している時点でリクエストができるため、
            // サーバーでの重複処理を防ぐ目的で特殊ヘッダーを追加
            Future<T> wrappedApiCall() async {
              // Dioのインスタンスを取得できる場合は、特殊ヘッダーを追加
              try {
                final dio = Dio()..interceptors.add(ErrorInterceptor(ref));
                dio.options.headers['X-Network-Connectivity-Check'] = 'true';

                // キャッチされたリクエストのみを実行し、サーバーでの処理を防ぐ
                await dio.head('/network-test');

                // 接続確認が成功した場合のみ実際のAPIコールを実行
                return await apiCall();
              } catch (e) {
                // ヘッダー追加に失敗した場合は元のAPIコールをそのまま実行
                return await apiCall();
              }
            }

            result = await wrappedApiCall();
          } else {
            // 通常のリクエスト実行（リトライ有効時）
            result = await apiCall();
          }

          if (!completer.isCompleted) {
            completer.complete(result);
          }
        } catch (e) {
          // 接続エラー関連のチェック（タイムアウト、Connection reset by peerなど）
          bool isNetworkError = _isNetworkRelatedError(e);

          // ネットワークエラーでなければそのまま例外を投げる
          if (!isNetworkError) {
            if (!completer.isCompleted) {
              // リトライが無効かつリトライ回数が最大回数に達した場合はエラーとする
              if (!enableRetry || retryCount >= maxRetry) {
                // APIエラーのダイアログ表示
                try {
                  String message = message_util.MessageUtil.message.serverError;
                  if (e is DioException) {
                    switch (e.type) {
                      case DioExceptionType.sendTimeout:
                      case DioExceptionType.receiveTimeout:
                      case DioExceptionType.connectionTimeout:
                        message = message_util.MessageUtil.message.timeoutError;
                        break;
                      default:
                        message = 'エラーが発生しました';
                    }
                  } else if (e is DioException && e.response?.data != null) {
                    // エラーレスポンスからメッセージ取得を試みる
                    try {
                      message = e.response?.data['message'];
                    } catch (_) {}
                  }

                  final dialogData = message_util.DialogData(
                    message: message,
                    dialogType: DialogType.error,
                    hideOkButton: false,
                  );
                  ref.read(message_util.dialogStateProvider.notifier).showDialog(dialogData);
                } catch (dialogError) {
                  talker.warning('【NetTest】エラーダイアログ表示中にエラー発生: $dialogError');
                }

                completer.completeError(e);
              }
            }
            return;
          } else if (ref.read(message_util.dialogStateProvider)?.message !=
              message_util.MessageUtil.message.networkUnavailable) {
            // ネットワークエラーの処理
            // timeoutエラーの場合はエラーメッセージを表示して終了
            if (e is DioException &&
                (e.type == DioExceptionType.sendTimeout ||
                    e.type == DioExceptionType.receiveTimeout ||
                    e.type == DioExceptionType.connectionTimeout)) {
              // エラーメッセージを表示して終了
              final dialogData = message_util.DialogData(
                message: message_util.MessageUtil.message.timeoutError,
                dialogType: DialogType.error,
              );
              ref.read(message_util.dialogStateProvider.notifier).showDialog(dialogData);
              completer.completeError(e);
              return;
            }
          }

          // ノイズ吸収のための短い待機
          await Future.delayed(const Duration(milliseconds: noiseFilterDelayMs));

          // 最新の安定した接続状態を使用
          final hasConnection = hasStableConnection;

          if (!hasConnection) {
            // リトライが無効の場合はすぐにエラーを返す
            if (!enableRetry) {
              // 切断時のダイアログ表示
              final message = message_util.MessageUtil.message.networkUnavailable;

              final dialogData = message_util.DialogData(
                message: message,
                dialogType: DialogType.error,
                hideOkButton: false,
              );
              ref.read(message_util.dialogStateProvider.notifier).showDialog(dialogData);

              completer.completeError(
                DioException(
                  requestOptions: e is DioException ? e.requestOptions : RequestOptions(path: ''),
                  type: DioExceptionType.connectionError,
                  message: message,
                  error: e is DioException ? e.error : e,
                ),
              );
              return;
            }

            // この時点で接続がなければ、subscription内のロジックで処理される
            // リトライカウントを増やす - ただし最大値を超えないように
            if (retryCount < maxRetry) {
              retryCount++;
            }
          } else if (!retryScheduled && retryCount < maxRetry && enableRetry) {
            // 接続があるがエラーが発生した場合は、少し待ってからリトライ
            retryScheduled = true;
            retryCount++;

            Future.delayed(Duration(seconds: recoveryDelay)).then((_) {
              if (!completer.isCompleted) {
                retryScheduled = false;
                executeRequest();
              }
            });
          } else if (retryCount >= maxRetry || !enableRetry) {
            if (!completer.isCompleted) {
              // ダイアログ表示（最大リトライ回数到達）
              String message;
              try {
                // リトライ失敗時または接続エラー時のメッセージ
                if (e is DioException &&
                    (e.type == DioExceptionType.unknown && e.error.toString().contains('Connection reset by peer'))) {
                  message = 'ネットワーク接続が切断されました。再度お試しください。';
                } else {
                  message = message_util.MessageUtil.message.networkRetryLimit;
                }
              } catch (e) {
                // メッセージが見つからない場合のフォールバック
                message = '通信エラーが発生しました。再接続してください。';
              }

              final dialogData = message_util.DialogData(
                message: message,
                dialogType: DialogType.error,
                hideOkButton: false,
              );
              ref.read(message_util.dialogStateProvider.notifier).showDialog(dialogData);

              completer.completeError(
                DioException(
                  requestOptions: e is DioException ? e.requestOptions : RequestOptions(path: ''),
                  type: DioExceptionType.connectionError,
                  message: message,
                  error: e is DioException ? e.error : e,
                ),
              );
            }
          }
        }
      }

      // 接続状態変化を処理する関数
      Future<void> processConnectivityChange(List<ConnectivityResult> results) async {
        // 最新の結果を即時保存（常に最新状態を維持）
        latestConnectivityResults = results;

        // 既に処理中なら何もしない（重複処理防止）
        if (isProcessingConnectivityChange) return;

        isProcessingConnectivityChange = true;

        try {
          // ノイズ吸収のための待機
          // この間もlisten関数は継続して最新状態をlatestConnectivityResultsに更新し続ける
          await Future.delayed(const Duration(milliseconds: noiseFilterDelayMs));

          // 待機後、最新の接続状態を評価（listenが更新し続けた最新値を使用）
          final hasConnection = evaluateConnection(latestConnectivityResults);
          hasStableConnection = hasConnection; // 安定した接続状態を更新

          // 接続状態が前回から変化した場合のみ処理
          if (hasConnection != lastConnectionState) {
            if (hasConnection && !lastConnectionState) {
              // 切断状態から接続復帰した場合
              // 接続状態を更新
              lastConnectionState = true;

              // 接続復帰時のダイアログ処理（ダイアログがあれば閉じる）
              final currentDialogData = ref.read(message_util.dialogStateProvider);
              if (currentDialogData != null) {
                if (currentDialogData.hideOkButton == true) {
                  ref.read(message_util.dialogStateProvider.notifier).hideDialog();
                }
              }

              // リトライがスケジュールされていない場合のみ処理
              if (!retryScheduled && !completer.isCompleted) {
                retryScheduled = true;

                // 遅延を入れてからリトライ
                await Future.delayed(Duration(seconds: recoveryDelay));

                // 既に完了していればスキップ
                if (completer.isCompleted) {
                  return;
                }

                retryScheduled = false;

                // リトライが有効な場合は通常のリトライを実行
                if (enableRetry && retryCount < maxRetry) {
                  executeRequest();
                }
                // リトライが無効な場合はエラーを強制的に完了する
                else if (!enableRetry) {
                  // 復帰時はユーザー向けエラーメッセージを表示
                  final message = message_util.MessageUtil.message.networkReconnected;

                  // ダイアログ表示
                  final dialogData = message_util.DialogData(
                    message: message,
                    dialogType: DialogType.warning,
                    hideOkButton: false,
                  );
                  ref.read(message_util.dialogStateProvider.notifier).showDialog(dialogData);

                  // 再度完了していないことを確認してからエラーを返す
                  if (!completer.isCompleted) {
                    try {
                      completer.completeError(
                        DioException(
                          requestOptions: RequestOptions(path: ''),
                          type: DioExceptionType.connectionError,
                          message: message,
                        ),
                      );
                    } catch (e) {
                      talker.warning('【NetTest】エラーダイアログ表示中にエラー発生: $e');
                    }
                  }
                }
              }
            } else if (!hasConnection && lastConnectionState) {
              // 接続状態から切断状態になった場合
              // 接続状態を更新
              lastConnectionState = false;

              // 切断時のダイアログ表示
              final message = message_util.MessageUtil.message.networkUnavailable;

              final dialogData = message_util.DialogData(
                message: message,
                dialogType: DialogType.error,
                hideOkButton: true, // 自動復帰を待つため、OKボタンは非表示
              );
              ref.read(message_util.dialogStateProvider.notifier).showDialog(dialogData);
            }
          }
        } finally {
          // 処理完了フラグを更新（finallyブロックで確実に実行）
          isProcessingConnectivityChange = false;
        }
      }

      // 接続状態の監視を開始
      subscription = Connectivity().onConnectivityChanged.listen((results) {
        // API処理が完了している場合は何もしない
        if (completer.isCompleted) return;

        // 最新の結果を即時保存してから非同期処理を開始
        latestConnectivityResults = results;
        // 非同期で処理開始（この関数はすぐに戻り、listenは継続して動作）
        processConnectivityChange(results);
      });

      // 最初のリクエスト実行
      executeRequest();

      // 結果を返却
      return completer.future;
    } catch (e) {
      // 予期せぬエラーの場合もリソースを解放
      cleanupResources();
      rethrow;
    }
  }

  /// ネットワーク接続を監視しながらAPI処理を実行する（エラー専用ハンドリング）
  ///
  /// [apiCall] 実行したいAPI呼び出し処理
  /// [maxRetry] 最大リトライ回数
  /// [recoveryDelay] 復帰後の待機時間（秒）
  /// [ref] プロバイダー参照
  @Deprecated('withNetworkMonitoringに統合されました。withNetworkMonitoring(enableRetry: false)を使用してください。')
  static Future<T> withErrorHandling<T>({
    required Future<T> Function() apiCall,
    int maxRetry = 0,
    int recoveryDelay = 1,
    required Ref ref,
  }) async {
    // withNetworkMonitoringに委譲
    return withNetworkMonitoring(
      ref: ref,
      apiCall: apiCall,
      maxRetry: maxRetry,
      recoveryDelay: recoveryDelay,
      enableRetry: false,
    );
  }

  /// ネットワークエラーかどうかを判定する
  static bool _isNetworkRelatedError(error) {
    // 明らかなネットワーク関連のエラータイプ
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionTimeout) {
      return true;
    }

    // エラーメッセージからネットワーク関連エラーを判定
    if (error.type == DioExceptionType.unknown && error.error != null) {
      final errorMessage = error.error.toString().toLowerCase();
      return errorMessage.contains('connection reset by peer') ||
          errorMessage.contains('connection closed') ||
          errorMessage.contains('socket') ||
          errorMessage.contains('network') ||
          errorMessage.contains('connection') ||
          errorMessage.contains('host') ||
          errorMessage.contains('lookup');
    }

    return false;
  }
}
