# Riverpodによる状態管理ガイド 🌊

<div align="center">
<a href="https://riverpod.dev/ja/" target="_blank">
<img src="https://raw.githubusercontent.com/rrousselGit/riverpod/refs/heads/master/resources/icon/Facebook%20Cover%20A.png" width="600" />
</a>
</div>

## 目次

- [MVVMアーキテクチャとRiverpod](#mvvmアーキテクチャとriverpod)
- [Riverpodの基本概念](#riverpodの基本概念)
- [@riverpodアノテーション](#riverpodアノテーション)
- [ViewModelの実装パターン](#viewmodelの実装パターン)
  - [基本的なViewModel](#基本的なviewmodel)
  - [パラメータ付きViewModel](#パラメータ付きviewmodel)
  - [更新可能なViewModel](#更新可能なviewmodel)
  - [グローバル状態管理](#グローバル状態管理)
- [UIからのアクセス](#uiからのアクセス)
- [ベストプラクティス](#ベストプラクティス)
- [よくあるパターンと実装例](#よくあるパターンと実装例)

## MVVMアーキテクチャとRiverpod 🏗️

MVVMアーキテクチャはModel-View-ViewModelの略で、アプリケーションを3つの主要コンポーネントに分離する設計パターンです：

- **Model**: データとビジネスロジック
- **View**: ユーザーインターフェース
- **ViewModel**: ViewとModelの間の仲介

このプロジェクトでは、MVVMパターンをクリーンアーキテクチャと組み合わせて使用しています：

- **Model**: ドメイン層のエンティティとユースケース
- **View**: プレゼンテーション層のFlutterウィジェット
- **ViewModel**: Riverpodプロバイダーで実装された状態管理クラス

Riverpodは、フレキシブルで型安全な状態管理ライブラリで、ViewModelを実装するのに最適です。特に`@riverpod`アノテーションを使用することで、ボイラープレートコードを大幅に削減できます。

## Riverpodの基本概念 💡

Riverpodの基本的な概念を理解しておくことが重要です：

- **Provider**: 状態を提供するコンテナ
- **Consumer**: プロバイダーから値を読み取るウィジェット
- **ProviderRef**: プロバイダー間の相互依存関係を管理するオブジェクト
- **ProviderScope**: プロバイダーのスコープを定義するウィジェット

## @riverpodアノテーション 🏷️

このプロジェクトでは、Riverpod 2.0から導入された`@riverpod`アノテーションを使用しています。このアノテーションは、多くのボイラープレートコードを削減し、型安全に状態を管理できます。

主なアノテーションの種類：

1. **関数プロバイダー**: 読み取り専用の値を提供する関数に使用
   ```dart
   @riverpod
   String helloWorld(HelloWorldRef ref) {
     return 'Hello World';
   }
   ```

2. **クラスプロバイダー**: 状態を更新可能なプロバイダーに使用
   ```dart
   @riverpod
   class Counter extends _$Counter {
     @override
     int build() {
       return 0;
     }

     void increment() {
       state = state + 1;
     }
   }
   ```

### アノテーションオプション

`@riverpod`アノテーションには以下のオプションを指定できます：

- **keepAlive**: プロバイダーの値をリスナーがいなくなっても保持するかどうか
  ```dart
  @Riverpod(keepAlive: true)
  class AppState extends _$AppState { ... }
  ```

- **dependencies**: プロバイダーが依存している他のプロバイダーを明示的に示す
  ```dart
  @Riverpod(dependencies: [userRepository])
  class UserViewModel extends _$UserViewModel { ... }
  ```

## ViewModelの実装パターン 📊

### 基本的なViewModel

最もシンプルなViewModelは、単一の状態を管理するものです：

```dart
// counter_view_model.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_view_model.g.dart';

@riverpod
class CounterViewModel extends _$CounterViewModel {
  @override
  int build() {
    return 0; // 初期値
  }

  // 状態を更新するメソッド
  void increment() {
    state = state + 1;
  }

  void decrement() {
    state = state - 1;
  }

  void reset() {
    state = 0;
  }
}
```

### パラメータ付きViewModel

ViewModel生成時にパラメータを渡すことで、動的な状態を管理できます：

```dart
// user_details_view_model.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_details_view_model.g.dart';

@riverpod
class UserDetailsViewModel extends _$UserDetailsViewModel {
  @override
  Future<User> build(String userId) async {
    return _fetchUser(userId);
  }

  Future<User> _fetchUser(String userId) async {
    final userRepository = ref.read(userRepositoryProvider);
    return await userRepository.getUser(userId);
  }

  Future<void> refreshUser() async {
    state = const AsyncValue.loading();
    try {
      final user = await _fetchUser(state.value!.id);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
```

使用例：
```dart
// user_details_screen.dart
class UserDetailsScreen extends ConsumerWidget {
  final String userId;

  const UserDetailsScreen({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDetailsViewModelProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('ユーザー詳細')),
      body: userAsync.when(
        data: (user) => UserDetailsContent(user: user),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('エラー: $error')),
      ),
    );
  }
}
```

### 更新可能なViewModel

非同期処理と状態の更新を組み合わせたViewModel：

```dart
// auth_view_model.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_view_model.g.dart';

@Riverpod(keepAlive: true) // アプリ全体で認証状態を保持
class AuthViewModel extends _$AuthViewModel {
  @override
  FutureOr<User?> build() {
    return _checkCurrentUser();
  }

  Future<User?> _checkCurrentUser() async {
    final authRepository = ref.read(authRepositoryProvider);
    return await authRepository.getCurrentUser();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final user = await authRepository.login(email, password);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.logout();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
```

### グローバル状態管理

アプリ全体で共有する状態を管理する例：

```dart
// app_preferences_view_model.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_preferences_view_model.g.dart';

@Riverpod(keepAlive: true)
class AppPreferencesViewModel extends _$AppPreferencesViewModel {
  @override
  AppPreferences build() {
    _loadPreferences(); // バックグラウンドで非同期読み込み
    return AppPreferences.defaultPreferences(); // デフォルト値を返す
  }

  Future<void> _loadPreferences() async {
    final preferencesRepository = ref.read(preferencesRepositoryProvider);
    final loadedPreferences = await preferencesRepository.getPreferences();
    // 読み込み完了後に状態を更新
    state = loadedPreferences;
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    // 現在の状態をコピーして特定のフィールドのみ更新
    final updatedPreferences = state.copyWith(themeMode: themeMode);
    state = updatedPreferences;

    // 更新した設定を保存
    final preferencesRepository = ref.read(preferencesRepositoryProvider);
    await preferencesRepository.savePreferences(updatedPreferences);
  }
}
```

## UIからのアクセス 📲

ViewModelにアクセスする主な方法は3つあります：

### 1. ConsumerWidgetの使用

```dart
class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('カウンター')),
      body: Center(child: Text('Count: $count')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterViewModelProvider.notifier).increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### 2. ConsumerStatefulWidgetの使用

```dart
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),
      body: Column(
        children: [
          TextField(controller: _emailController),
          TextField(controller: _passwordController, obscureText: true),
          ElevatedButton(
            onPressed: () {
              ref.read(authViewModelProvider.notifier).login(
                _emailController.text,
                _passwordController.text,
              );
            },
            child: const Text('ログイン'),
          ),
          if (authState.isLoading)
            const CircularProgressIndicator(),
          if (authState.hasError)
            Text('エラー: ${authState.error}'),
        ],
      ),
    );
  }
}
```

### 3. Consumer/Consumerメソッドパターン

ウィジェット階層の一部だけを更新したい場合：

```dart
class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({required this.productId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('商品詳細')),
      body: Column(
        children: [
          const ProductHeader(),

          // viewModelにアクセスする部分だけをConsumerで囲む
          Consumer(
            builder: (context, ref, child) {
              final productAsync =
                  ref.watch(productDetailsViewModelProvider(productId));

              return productAsync.when(
                data: (product) => ProductInfo(product: product),
                loading: () => const CircularProgressIndicator(),
                error: (error, _) => Text('エラー: $error'),
              );
            },
          ),

          const ProductReviews(),
        ],
      ),
    );
  }
}
```

## ベストプラクティス 🏆

Riverpodと@riverpodアノテーションを効果的に使用するためのベストプラクティス：

1. **コード生成を自動化する**
   新しいプロバイダーを作成したり変更した後は、必ず下記のコマンドを実行してコードを生成します：
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **状態の適切な粒度を選択する**
   - 小さすぎる粒度: 多くのプロバイダー間で状態を同期する必要がある
   - 大きすぎる粒度: 1つの変更で関係のない部分も再描画される

3. **非同期状態を適切に処理する**
   AsyncValueを使って、loading/data/errorの状態をすべて適切に処理します：
   ```dart
   userState.when(
     data: (user) => UserContent(user: user),
     loading: () => const LoadingIndicator(),
     error: (error, stackTrace) => ErrorWidget(error: error),
   );
   ```

4. **状態を更新する時は元の状態を考慮する**
   特に複雑なオブジェクトでは、copyWithメソッドを使用して既存の状態を保持したまま一部だけ更新します：
   ```dart
   void updateUserName(String name) {
     state = state.copyWith(name: name);
   }
   ```

5. **keepAliveフラグを適切に使用する**
   - グローバルな状態（認証情報、アプリ設定など）: `keepAlive: true`
   - 画面に依存する一時的な状態: `keepAlive: false`（デフォルト）

6. **副作用の処理**
   `ref.listen` を使用して、状態変更時に副作用（ナビゲーション、スナックバーの表示など）を処理します：
   ```dart
   @override
   Widget build(BuildContext context, WidgetRef ref) {
     ref.listen<AsyncValue<User?>>(
       authViewModelProvider,
       (previous, current) {
         if (previous?.value == null && current.value != null) {
           // ログイン成功時のナビゲーション
           Navigator.of(context).pushReplacementNamed('/home');
         }
       },
     );
     // ...
   }
   ```

## よくあるパターンと実装例 🛠️

### フォームの状態管理

```dart
// form_view_model.dart
@riverpod
class ProfileFormViewModel extends _$ProfileFormViewModel {
  @override
  ProfileFormState build() {
    return const ProfileFormState(
      name: '',
      email: '',
      isSubmitting: false,
    );
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  Future<void> submit() async {
    // 送信中状態に更新
    state = state.copyWith(isSubmitting: true);

    try {
      final userRepository = ref.read(userRepositoryProvider);
      await userRepository.updateProfile(
        ProfileUpdateParams(
          name: state.name,
          email: state.email,
        ),
      );

      // 送信完了
      state = state.copyWith(isSubmitting: false, isSuccess: true);
    } catch (e) {
      // エラー状態に更新
      state = state.copyWith(
        isSubmitting: false,
        error: e.toString(),
      );
    }
  }
}

// ProfileFormState同じファイル内で定義
@freezed
class ProfileFormState with _$ProfileFormState {
  const factory ProfileFormState({
    required String name,
    required String email,
    @Default(false) bool isSubmitting,
    @Default(false) bool isSuccess,
    String? error,
  }) = _ProfileFormState;
}
```

### リスト表示と詳細画面の連携

```dart
// list_view_model.dart
@riverpod
class ProductListViewModel extends _$ProductListViewModel {
  @override
  Future<List<Product>> build() async {
    return _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    final productRepository = ref.read(productRepositoryProvider);
    return await productRepository.getProducts();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final products = await _fetchProducts();
      state = AsyncValue.data(products);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// detail_view_model.dart
@riverpod
class ProductDetailViewModel extends _$ProductDetailViewModel {
  @override
  Future<Product> build(String productId) async {
    return _fetchProduct(productId);
  }

  Future<Product> _fetchProduct(String productId) async {
    final productRepository = ref.read(productRepositoryProvider);
    return await productRepository.getProduct(productId);
  }
}
```

### ページネーション

```dart
// paginated_list_view_model.dart
@riverpod
class PaginatedProductsViewModel extends _$PaginatedProductsViewModel {
  int _page = 1;
  final int _pageSize = 20;
  bool _hasMore = true;

  @override
  Future<List<Product>> build() async {
    return _fetchPage(1);
  }

  Future<List<Product>> _fetchPage(int page) async {
    final productRepository = ref.read(productRepositoryProvider);
    final products = await productRepository.getProducts(
      page: page,
      pageSize: _pageSize,
    );

    // 最後のページかどうかを判定
    _hasMore = products.length == _pageSize;

    return products;
  }

  Future<void> loadMore() async {
    if (!_hasMore || state is AsyncLoading) {
      return;
    }

    _page++;

    state = const AsyncValue.loading();

    try {
      final currentProducts = state.value ?? [];
      final newProducts = await _fetchPage(_page);

      state = AsyncValue.data([...currentProducts, ...newProducts]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      _page--; // 失敗した場合はページを戻す
    }
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;

    state = const AsyncValue.loading();

    try {
      final products = await _fetchPage(1);
      state = AsyncValue.data(products);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  bool get hasMore => _hasMore;
}
```

### キャッシュと状態の永続化

```dart
// cached_repository.dart
@riverpod
class CachedUserRepository extends _$CachedUserRepository {
  @override
  UserRepository build() {
    final apiClient = ref.watch(userApiClientProvider);
    final localStorage = ref.watch(localStorageProvider);

    return CachedUserRepositoryImpl(apiClient, localStorage);
  }
}

// cached_repository_impl.dart
class CachedUserRepositoryImpl implements UserRepository {
  final UserApiClient apiClient;
  final LocalStorage localStorage;

  CachedUserRepositoryImpl(this.apiClient, this.localStorage);

  @override
  Future<User> getUser(String id) async {
    // キャッシュを確認
    final cachedUser = await localStorage.getUser(id);
    if (cachedUser != null) {
      return cachedUser;
    }

    // APIから取得
    final user = await apiClient.getUser(id);

    // キャッシュに保存
    await localStorage.saveUser(user);

    return user;
  }

  // 他のメソッドも同様にキャッシュを活用...
}
```

これらのパターンを使いこなすことで、Riverpodと@riverpodアノテーションを使用した効率的な状態管理が可能になります。
