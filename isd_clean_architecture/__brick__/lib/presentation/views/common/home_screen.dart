import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/common/progress_bar_widget.dart';

/// -----
/// ホーム画面コンポーネント
/// -----
///
/// StatefulNavigationShellを使用したNavigationRailを実装するスクリーン
class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GlobalProgressBar(),
          Expanded(
            child: Row(
              children: [
                NavigationRail(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: (index) => navigationShell.goBranch(index),
                  groupAlignment: -0.95,
                  labelType: NavigationRailLabelType.all,
                  leading: Builder(
                    builder:
                        (BuildContext context) => FloatingActionButton(
                          elevation: 0,
                          onPressed: () => Scaffold.of(context).openDrawer(),
                          child: const Icon(Icons.menu),
                        ),
                  ),
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.people), label: Text('顧客')),
                    NavigationRailDestination(icon: Icon(Icons.inventory_2), label: Text('在庫')),
                    NavigationRailDestination(icon: Icon(Icons.settings), label: Text('設定')),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: navigationShell),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            // ユーザー情報部分
            UserAccountsDrawerHeader(
              accountName: const Text('山田 太郎'),
              accountEmail: const Text('yamada.taro@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('山', style: TextStyle(fontSize: 24.0, color: Theme.of(context).primaryColor)),
              ),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),

            // メニュー項目部分
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('顧客'),
                    onTap: () {
                      Navigator.pop(context);
                      navigationShell.goBranch(0);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.inventory_2),
                    title: const Text('在庫'),
                    onTap: () {
                      Navigator.pop(context);
                      navigationShell.goBranch(1);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('設定'),
                    onTap: () {
                      Navigator.pop(context);
                      navigationShell.goBranch(2);
                    },
                  ),
                ],
              ),
            ),

            // 区切り線
            const Divider(),

            // ログアウトボタン（下部固定）
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('ログアウト'),
              onTap: () {
                Navigator.pop(context);
                // ログアウト処理
                // TODO: ログアウト処理を実装する
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
