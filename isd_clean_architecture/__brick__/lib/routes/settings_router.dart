import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// -----
/// [概要]   :設定画面の画面遷移を定義するルーティング設定
/// [作成者] :AI Assistant
/// [作成日] :2024/06/29
/// -----
///
/// 設定機能の画面遷移を定義します。
/// 以下の機能を含みます:
/// * メイン設定画面
/// * 各種設定詳細画面
final List<GoRoute> settingRoutes = [
  GoRoute(
    path: '/settings',
    name: 'settings',
    builder: (context, state) => const SettingsScreen(),
    routes: [
      GoRoute(path: 'profile', name: 'profile', builder: (context, state) => const ProfileSettingsScreen()),
      GoRoute(path: 'app', name: 'appSettings', builder: (context, state) => const AppSettingsScreen()),
      GoRoute(path: 'about', name: 'about', builder: (context, state) => const AboutScreen()),
    ],
  ),
];

/// -----
/// 設定画面 (プレースホルダー)
/// -----
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('プロフィール設定'),
            onTap: () => context.push('/settings/profile'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('アプリ設定'),
            onTap: () => context.push('/settings/app'),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('このアプリについて'),
            onTap: () => context.push('/settings/about'),
          ),
        ],
      ),
    );
  }
}

/// -----
/// プロフィール設定画面 (プレースホルダー)
/// -----
class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('プロフィール設定')), body: const Center(child: Text('プロフィール設定画面')));
  }
}

/// -----
/// アプリ設定画面 (プレースホルダー)
/// -----
class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('アプリ設定')), body: const Center(child: Text('アプリ設定画面')));
  }
}

/// -----
/// アプリについて画面 (プレースホルダー)
/// -----
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('このアプリについて')), body: const Center(child: Text('バージョン情報やライセンス情報')));
  }
}

/// -----
/// 設定機能の拡張方法
/// -----
///
/// TODO: 設定機能に新しい設定画面を追加するには:
/// 1. 新しい設定画面クラスを作成する (lib/presentation/views/common/setting/ などに配置)
/// 2. settingRoutesリストに新しいGoRouteエントリを追加
/// 3. SettingsScreenのListViewに新しい設定項目を追加
///
/// 例:
/// ```dart
/// // 通知設定画面を追加する場合
/// GoRoute(
///   path: 'notifications',
///   name: 'notificationSettings',
///   builder: (context, state) => const NotificationSettingsScreen(),
/// ),
/// 
/// // SettingsScreenのListViewに項目を追加
/// ListTile(
///   leading: const Icon(Icons.notifications),
///   title: const Text('通知設定'),
///   onTap: () => context.push('/settings/notifications'),
/// ),
/// ``` 