import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_settings.dart';

import 'core/constants/config.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/talker_util.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'routes/app_router.dart';

/// -----
/// [概要]   :アプリケーションのエントリーポイント
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/25
/// -----
void main() {
  // runZonedGuardedでアプリ全体のエラーをキャッチ
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // エラーハンドリングの設定
      FlutterError.onError = (details) {
        talker.handle(details.exception, details.stack);
      };

      final List<ProviderObserver> observers = [];

      // Riverpodのログ設定がオンならオブザーバーを追加
      if (Config.talkerConfig.enableRiverpodLogs) {
        observers.add(
          TalkerRiverpodObserver(
            talker: talker,
            settings: TalkerRiverpodLoggerSettings(enabled: Config.talkerConfig.enableRiverpodLogs),
          ),
        );
      }

      final container = ProviderContainer(observers: observers);

      // デモアプリのため、起動時に自動的にデモ認証を実行
      _initDemoAuthentication(container); //TODO: デモ認証を削除する

      runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
    },
    (error, stackTrace) {
      // ゾーン内で捕捉されたエラーのハンドリング
      if (error is DioException) {
        // DioExceptionの場合は、警告レベルでログ出力
        talker.warning('Uncaught DioException', error, stackTrace);
        return;
      }
      // その他のエラーの場合は、エラーレベルでログ出力
      talker.error('Uncaught exception', error, stackTrace);
    },
  );
}

/// デモ認証の初期化を行う
/// TODO: デモ認証を削除する
void _initDemoAuthentication(ProviderContainer container) {
  // 非同期でデモ認証を実行
  Future.microtask(() async {
    try {
      final authRepository = container.read(authRepositoryProvider);
      final result = await authRepository.demoAuthenticate();

      if (result.isSuccess) {
        talker.info('デモ認証に成功しました: トークンを設定済み');
      } else {
        talker.error('デモ認証に失敗しました: ${result.errorMessage}');
      }
    } catch (e, stackTrace) {
      talker.error('デモ認証の初期化でエラーが発生しました', e, stackTrace);
    }
  });
}

/// -----
/// [概要]   :アプリケーションのルートコンポーネント
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/25
/// -----
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Talkerのルート監視を設定したGoRouterプロバイダーを取得
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'New App', //TODO: アプリ名を設定
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
      // 日本語ローカライゼーションの設定
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ja', 'JP')],
      locale: const Locale('ja', 'JP'),
    );
  }
}
