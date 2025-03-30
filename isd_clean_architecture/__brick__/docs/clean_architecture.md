# クリーンアーキテクチャガイド 🏛️

<div align="center">
<img src="https://blog.cleancoder.com/uncle-bob/images/2012-08-13-the-clean-architecture/CleanArchitecture.jpg" width="500" />
<p><small>出典: <a href="https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html">The Clean Architecture by Robert C. Martin</a></small></p>
</div>

## 目次

- [クリーンアーキテクチャとは](#クリーンアーキテクチャとは)
- [プロジェクトの層構造](#プロジェクトの層構造)
  - [Presentation層](#presentation層)
  - [Domain層](#domain層)
  - [Data層](#data層)
  - [Core層](#core層)
- [依存関係のルール](#依存関係のルール)
- [データの流れ](#データの流れ)
- [実装の具体例](#実装の具体例)
- [テスタビリティ](#テスタビリティ)
- [利点と注意点](#利点と注意点)

## クリーンアーキテクチャとは 🧩

クリーンアーキテクチャは、ソフトウェア設計の原則で、ビジネスロジックをUIやデータベース、フレームワークなどの外部要素から分離することを目的としています。この設計手法により、以下の利点が得られます：

- **テスタビリティの向上**: ビジネスロジックを独立させることで、単体テストが容易になります
- **保守性の向上**: 各コンポーネントが明確に分離されるため、影響範囲を限定した変更が可能になります
- **柔軟性の向上**: 外部システムやフレームワークの変更があっても、ビジネスロジックを変更せずに対応できます

## プロジェクトの層構造 📚

このプロジェクトでは、クリーンアーキテクチャを以下の4つの層に分けて実装しています：

```
lib/
  ├── presentation/  # プレゼンテーション層
  ├── domain/        # ドメイン層
  ├── data/          # データ層
  └── core/          # コア層
```

### Presentation層 🖼️

ユーザーインターフェースと状態管理を担当します。

**ディレクトリ構造**:
```
presentation/
  ├── view_models/  # ビューモデル（Riverpodプロバイダー）
  ├── views/        # 画面を構成するウィジェット
  └── widgets/      # 再利用可能なウィジェット
```

**役割**:
- ユーザーからの入力の受け付け
- 画面の表示とUI状態の管理
- ドメイン層の呼び出し
- ビューモデルによる状態管理

**主な構成要素**:
- **View**: Flutterのウィジェットで実装されたUI
- **ViewModel**: Riverpodプロバイダーで実装された状態管理クラス

**実装例**:
```dart
// views/user_profile_screen.dart
class UserProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ユーザープロフィール')),
      body: userState.when(
        data: (user) => UserProfileContent(user: user),
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => ErrorView(message: error.toString()),
      ),
    );
  }
}

// view_models/user_view_model.dart
@riverpod
class UserViewModel extends _$UserViewModel {
  @override
  FutureOr<User> build() {
    return _fetchUserProfile();
  }

  Future<User> _fetchUserProfile() async {
    final userRepository = ref.read(userRepositoryProvider);
    return await userRepository.getCurrentUser();
  }

  Future<void> updateProfile(UserUpdateParams params) async {
    state = const AsyncValue.loading();
    try {
      final userRepository = ref.read(userRepositoryProvider);
      final updatedUser = await userRepository.updateUser(params);
      state = AsyncValue.data(updatedUser);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
```

### Domain層 💼

アプリケーションのビジネスロジックを担当します。このレイヤーは外部の依存関係から独立しています。

**ディレクトリ構造**:
```
domain/
  ├── entities/      # ビジネスロジックで使用するドメインモデル
  ├── repositories/  # リポジトリのインターフェース（抽象クラス）
  └── use_cases/     # ビジネスロジックをカプセル化するユースケース
```

**役割**:
- ビジネスロジックの定義
- ドメインモデル（エンティティ）の定義
- リポジトリのインターフェースを通じたデータ層との通信

**主な構成要素**:
- **Entity**: ビジネスロジックで使用するドメインモデル
- **Repository Interface**: データ取得のための抽象インターフェース
- **UseCase**: 特定のビジネスロジックをカプセル化するクラス

**実装例**:
```dart
// entities/user.dart
class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});
}

// repositories/user_repository.dart
abstract class UserRepository {
  Future<User> getCurrentUser();
  Future<User> updateUser(UserUpdateParams params);
  Future<void> logout();
}

// use_cases/get_current_user_use_case.dart
class GetCurrentUserUseCase {
  final UserRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<User> execute() async {
    return await repository.getCurrentUser();
  }
}
```

### Data層 💾

外部データソースからのデータ取得と変換を担当します。

**ディレクトリ構造**:
```
data/
  ├── datasources/   # APIクライアントなど外部データソースへのアクセス
  ├── models/        # APIレスポンスのデータモデル
  ├── repositories/  # リポジトリの実装
  └── local/         # ローカルデータ保存（SharedPreferences、SQLiteなど）
```

**役割**:
- 外部データソース（API、データベースなど）からのデータ取得
- データモデルとドメインエンティティの相互変換
- ドメイン層で定義されたリポジトリインターフェースの実装

**主な構成要素**:
- **Data Source**: APIクライアントやデータベースヘルパーなど
- **Model**: APIからのレスポンスデータ構造
- **Repository Implementation**: ドメイン層のリポジトリインターフェースを実装したクラス

**実装例**:
```dart
// datasources/user_api_client.dart
@RestApi(baseUrl: "https://api.example.com")
abstract class UserApiClient {
  factory UserApiClient(Dio dio) = _UserApiClient;

  @GET("/user/profile")
  Future<UserResponse> getUserProfile();

  @PUT("/user/profile")
  Future<UserResponse> updateUserProfile(@Body() Map<String, dynamic> data);
}

// models/user_response.dart
@freezed
class UserResponse with _$UserResponse {
  const factory UserResponse({
    required String id,
    required String name,
    required String email,
  }) = _UserResponse;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}

// repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  final UserApiClient apiClient;
  final LocalStorage localStorage;

  UserRepositoryImpl(this.apiClient, this.localStorage);

  @override
  Future<User> getCurrentUser() async {
    try {
      final response = await apiClient.getUserProfile();
      return User(
        id: response.id,
        name: response.name,
        email: response.email,
      );
    } catch (e) {
      throw UserException("ユーザー情報の取得に失敗しました");
    }
  }

  @override
  Future<User> updateUser(UserUpdateParams params) async {
    try {
      final response = await apiClient.updateUserProfile(params.toJson());
      return User(
        id: response.id,
        name: response.name,
        email: response.email,
      );
    } catch (e) {
      throw UserException("プロフィールの更新に失敗しました");
    }
  }

  @override
  Future<void> logout() async {
    await localStorage.clear();
  }
}
```

### Core層 🧰

アプリケーション全体で使用される共通機能を提供します。

**ディレクトリ構造**:
```
core/
  ├── constants/     # 定数とアプリケーション設定
  ├── exceptions/    # 例外クラス
  ├── network/       # ネットワーク関連（インターセプターなど）
  └── utils/         # ユーティリティ関数とエクステンション
```

**役割**:
- 共通の定数やユーティリティの提供
- 例外処理の標準化
- ネットワーク通信の共通処理

**実装例**:
```dart
// exceptions/app_exception.dart
abstract class AppException implements Exception {
  final String message;
  final String code;

  AppException(this.message, {this.code = 'unknown'});
}

class NetworkException extends AppException {
  NetworkException(String message, {String code = 'network_error'})
      : super(message, code: code);
}

// network/dio_interceptor.dart
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.type == DioErrorType.connectTimeout) {
      return handler.reject(
        DioError(
          requestOptions: err.requestOptions,
          error: NetworkException("ネットワーク接続がタイムアウトしました"),
        ),
      );
    }
    return handler.next(err);
  }
}

// utils/date_util.dart
class DateUtil {
  static String formatDate(DateTime date) {
    return "${date.year}/${date.month}/${date.day}";
  }

  static DateTime parseServerDate(String dateStr) {
    return DateTime.parse(dateStr);
  }
}
```

## 依存関係のルール 📏

クリーンアーキテクチャでは、依存関係の方向は外側から内側に向かうべきという原則があります。このプロジェクトでは以下のルールを適用しています：

- **Presentation層** → **Domain層** → **Data層**
- **全ての層** → **Core層**

具体的には：

1. **Presentation層**はDomain層に依存できますが、Data層に直接依存することはできません
2. **Domain層**はData層に依存することはできません
3. **Data層**はDomain層に依存します（インターフェースの実装のため）
4. **Core層**は他のどの層にも依存しません

依存性の注入（Dependency Injection）を使用して、これらの依存関係を管理します：

```dart
// di/providers.dart
@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final apiClient = ref.watch(userApiClientProvider);
  final localStorage = ref.watch(localStorageProvider);
  return UserRepositoryImpl(apiClient, localStorage);
}

@riverpod
UserApiClient userApiClient(UserApiClientRef ref) {
  final dio = ref.watch(dioProvider);
  return UserApiClient(dio);
}
```

## データの流れ 🔄

一般的なデータフローは以下のようになります：

1. **ユーザーインタラクション**: ユーザーがアプリで操作を行う
2. **ViewModel**: アクションを処理し、適切なUseCaseを呼び出す
3. **UseCase**: ビジネスロジックを実行し、Repositoryからデータを取得
4. **Repository**: DataSourceからデータを取得し、ドメインエンティティに変換
5. **DataSource**: 外部ソース（API、データベースなど）と通信
6. **ViewModel**: 結果を受け取り、状態を更新
7. **View**: 更新された状態に基づいてUIを再描画

## 実装の具体例 📝

ユーザープロフィールを表示するシンプルな機能を例に、全レイヤーを通じた実装を見てみましょう：

### 1. データモデル (Data層)

```dart
// data/models/user_model.dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    String? profileImageUrl,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

### 2. ドメインエンティティ (Domain層)

```dart
// domain/entities/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
  });
}
```

### 3. リポジトリインターフェース (Domain層)

```dart
// domain/repositories/user_repository.dart
abstract class UserRepository {
  Future<User> getUser(String id);
}
```

### 4. ユースケース (Domain層)

```dart
// domain/use_cases/get_user_use_case.dart
class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  Future<User> execute(String userId) {
    return repository.getUser(userId);
  }
}
```

### 5. データソース (Data層)

```dart
// data/datasources/user_api_client.dart
@RestApi(baseUrl: "https://api.example.com")
abstract class UserApiClient {
  factory UserApiClient(Dio dio) = _UserApiClient;

  @GET("/users/{id}")
  Future<UserModel> getUser(@Path("id") String id);
}
```

### 6. リポジトリ実装 (Data層)

```dart
// data/repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  final UserApiClient apiClient;

  UserRepositoryImpl(this.apiClient);

  @override
  Future<User> getUser(String id) async {
    try {
      final userModel = await apiClient.getUser(id);
      return User(
        id: userModel.id,
        name: userModel.name,
        email: userModel.email,
        profileImageUrl: userModel.profileImageUrl,
      );
    } catch (e) {
      throw UserException("ユーザー情報の取得に失敗しました");
    }
  }
}
```

### 7. 依存性の注入 (DI)

```dart
// di/providers.dart
@riverpod
UserApiClient userApiClient(UserApiClientRef ref) {
  final dio = ref.watch(dioProvider);
  return UserApiClient(dio);
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final apiClient = ref.watch(userApiClientProvider);
  return UserRepositoryImpl(apiClient);
}

@riverpod
GetUserUseCase getUserUseCase(GetUserUseCaseRef ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUserUseCase(repository);
}
```

### 8. ViewModel (Presentation層)

```dart
// presentation/view_models/user_profile_view_model.dart
@riverpod
class UserProfileViewModel extends _$UserProfileViewModel {
  @override
  FutureOr<User> build(String userId) {
    return _fetchUser(userId);
  }

  Future<User> _fetchUser(String userId) async {
    final useCase = ref.read(getUserUseCaseProvider);
    return await useCase.execute(userId);
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

### 9. View (Presentation層)

```dart
// presentation/views/user_profile_screen.dart
class UserProfileScreen extends ConsumerWidget {
  final String userId;

  const UserProfileScreen({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProfileViewModelProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('プロフィール')),
      body: userState.when(
        data: (user) => UserProfileContent(user: user),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('エラー: ${error.toString()}'),
        ),
      ),
    );
  }
}
```

## テスタビリティ 🧪

クリーンアーキテクチャの大きな利点の一つはテスタビリティです。各層が独立しているため、モックを使用して単体テストを容易に書くことができます。

例として、UserRepositoryのモックを使ったUseCaseのテスト：

```dart
// test/domain/use_cases/get_user_use_case_test.dart
void main() {
  late MockUserRepository mockRepository;
  late GetUserUseCase useCase;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = GetUserUseCase(mockRepository);
  });

  test('should get user from repository', () async {
    // Arrange
    const userId = '123';
    final user = User(id: userId, name: 'Test User', email: 'test@example.com');
    when(mockRepository.getUser(userId))
        .thenAnswer((_) async => user);

    // Act
    final result = await useCase.execute(userId);

    // Assert
    expect(result, user);
    verify(mockRepository.getUser(userId));
    verifyNoMoreInteractions(mockRepository);
  });
}
```

## 利点と注意点 ⚖️

### 利点

- **関心の分離**: 各層が明確に分離され、単一責任の原則に従っています
- **テスタビリティ**: ビジネスロジックを独立させることで、テストが容易になります
- **保守性**: コードの各部分が独立しているため、影響範囲を限定した変更が可能です
- **スケーラビリティ**: チーム開発において、各層で並行して作業を進めることができます

### 注意点

- **ボイラープレートコード**: 多くのクラスと層を作成する必要があり、小規模なアプリでは過剰に感じることがあります
- **学習曲線**: 初めて取り組む開発者には理解に時間がかかる場合があります
- **適切なバランス**: プロジェクトの規模や要件に応じて、厳密さのレベルを調整する必要があります

適切に実装されたクリーンアーキテクチャは、拡張性、保守性、テスタビリティに優れたアプリケーションを構築するための強力な手法です。