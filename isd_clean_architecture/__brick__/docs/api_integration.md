# APIインテグレーションガイド 🌐

[![retrofit](https://img.shields.io/pub/v/retrofit?label=retrofit&style=flat-square)](https://pub.dartlang.org/packages/retrofit)
[![retrofit_generator](https://img.shields.io/pub/v/retrofit_generator?label=retrofit_generator&style=flat-square)](https://pub.dartlang.org/packages/retrofit_generator)

## 目次

- [概要](#概要)
- [APIクライアントの設定](#apiクライアントの設定)
  - [Dioのセットアップとインターセプターの設定](#dioのセットアップとインターセプターの設定)
  - [RetrofitのAPIクライアント定義](#retrofitのapiクライアント定義)
- [データモデルの定義](#データモデルの定義)
- [リポジトリの実装](#リポジトリの実装)
- [ユースケースの作成](#ユースケースの作成)
- [ViewModelでのAPI呼び出し](#viewmodelでのapi呼び出し)
- [エラーハンドリング](#エラーハンドリング)
- [キャッシュと状態の永続化](#キャッシュと状態の永続化)
- [サンプル実装](#サンプル実装)

## 概要 📋

このプロジェクトでは、APIの連携に以下のライブラリを使用しています：

- **Dio**: HTTPクライアント
- **Retrofit**: 型安全なAPIクライアント生成
- **Freezed**: データモデルの生成
- **Riverpod**: 状態管理とDI

APIの統合は以下のレイヤーを通じて行われます：

1. **Data層**: APIクライアント、データモデル、リポジトリ実装
2. **Domain層**: リポジトリインターフェース、ユースケース
3. **Presentation層**: ViewModel、UI

## APIクライアントの設定 ⚙️

### Dioのセットアップとインターセプターの設定

まずはDioのインスタンスと必要なインターセプターを設定します。

```dart
// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../constants/api_constants.dart';
import 'dio_interceptor.dart';

part 'dio_client.g.dart';

@riverpod
Dio dio(DioRef ref) {
  final options = BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  final dio = Dio(options);

  // インターセプターの追加
  dio.interceptors.add(ErrorInterceptor(ref));
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));

  return dio;
}
```

エラーインターセプターの実装:

```dart
// lib/core/network/dio_interceptor.dart
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../exceptions/network_exception.dart';
import '../utils/talker_util.dart';

class ErrorInterceptor extends Interceptor {
  final Ref ref;

  ErrorInterceptor(this.ref);

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    talker.error('DioError: ${err.message}', err, err.stackTrace);

    switch (err.type) {
      case DioErrorType.connectionTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        return handler.reject(
          DioError(
            requestOptions: err.requestOptions,
            error: NetworkException('ネットワーク接続がタイムアウトしました'),
          ),
        );

      case DioErrorType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          // 認証エラー処理
          return handler.reject(
            DioError(
              requestOptions: err.requestOptions,
              error: AuthException('認証に失敗しました'),
            ),
          );
        } else if (statusCode == 404) {
          return handler.reject(
            DioError(
              requestOptions: err.requestOptions,
              error: NotFoundException('リソースが見つかりません'),
            ),
          );
        }
        return handler.next(err);

      default:
        return handler.next(err);
    }
  }
}
```

### RetrofitのAPIクライアント定義

Retrofitを使用してAPIクライアントのインターフェースを定義します：

```dart
// lib/data/datasources/user_api_client.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/user_model.dart';

part 'user_api_client.g.dart';

@RestApi()
abstract class UserApiClient {
  factory UserApiClient(Dio dio) = _UserApiClient;

  @GET('/users/{id}')
  Future<UserModel> getUser(@Path('id') String id);

  @GET('/users')
  Future<List<UserModel>> getUsers();

  @POST('/users')
  Future<UserModel> createUser(@Body() Map<String, dynamic> data);

  @PUT('/users/{id}')
  Future<UserModel> updateUser(
    @Path('id') String id,
    @Body() Map<String, dynamic> data,
  );

  @DELETE('/users/{id}')
  Future<void> deleteUser(@Path('id') String id);
}
```

APIクライアントのプロバイダー：

```dart
// lib/di/providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/network/dio_client.dart';
import '../data/datasources/user_api_client.dart';

part 'providers.g.dart';

@riverpod
UserApiClient userApiClient(UserApiClientRef ref) {
  final dio = ref.watch(dioProvider);
  return UserApiClient(dio);
}
```

## データモデルの定義 📝

APIレスポンスのデータモデルをFreezedを使って定義します：

```dart
// lib/data/models/user_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    String? profileImageUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

ドメインエンティティの定義：

```dart
// lib/domain/entities/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.createdAt,
  });
}
```

モデルとエンティティの変換拡張機能：

```dart
// lib/data/models/extensions/user_model_extensions.dart
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

extension UserModelExtensions on UserModel {
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      profileImageUrl: profileImageUrl,
      createdAt: createdAt,
    );
  }
}

extension UserModelListExtensions on List<UserModel> {
  List<User> toEntityList() {
    return map((model) => model.toEntity()).toList();
  }
}
```

## リポジトリの実装 🏗️

ドメイン層でリポジトリインターフェースを定義：

```dart
// lib/domain/repositories/user_repository.dart
import '../entities/user.dart';

abstract class UserRepository {
  Future<User> getUser(String id);
  Future<List<User>> getUsers();
  Future<User> createUser(UserCreateParams params);
  Future<User> updateUser(String id, UserUpdateParams params);
  Future<void> deleteUser(String id);
}

class UserCreateParams {
  final String name;
  final String email;

  UserCreateParams({required this.name, required this.email});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}

class UserUpdateParams {
  final String? name;
  final String? email;

  UserUpdateParams({this.name, this.email});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    return data;
  }
}
```

データ層でリポジトリ実装：

```dart
// lib/data/repositories/user_repository_impl.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_api_client.dart';
import '../models/extensions/user_model_extensions.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApiClient _apiClient;

  UserRepositoryImpl(this._apiClient);

  @override
  Future<User> getUser(String id) async {
    final userModel = await _apiClient.getUser(id);
    return userModel.toEntity();
  }

  @override
  Future<List<User>> getUsers() async {
    final userModels = await _apiClient.getUsers();
    return userModels.toEntityList();
  }

  @override
  Future<User> createUser(UserCreateParams params) async {
    final userModel = await _apiClient.createUser(params.toJson());
    return userModel.toEntity();
  }

  @override
  Future<User> updateUser(String id, UserUpdateParams params) async {
    final userModel = await _apiClient.updateUser(id, params.toJson());
    return userModel.toEntity();
  }

  @override
  Future<void> deleteUser(String id) async {
    await _apiClient.deleteUser(id);
  }
}
```

リポジトリのプロバイダー：

```dart
// lib/di/providers.dart
@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final apiClient = ref.watch(userApiClientProvider);
  return UserRepositoryImpl(apiClient);
}
```

## ユースケースの作成 📋

ドメイン層でユースケースを定義：

```dart
// lib/domain/use_cases/get_user_use_case.dart
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  Future<User> execute(String id) async {
    return await repository.getUser(id);
  }
}
```

```dart
// lib/domain/use_cases/get_users_use_case.dart
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  Future<List<User>> execute() async {
    return await repository.getUsers();
  }
}
```

ユースケースのプロバイダー：

```dart
// lib/di/providers.dart
@riverpod
GetUserUseCase getUserUseCase(GetUserUseCaseRef ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUserUseCase(repository);
}

@riverpod
GetUsersUseCase getUsersUseCase(GetUsersUseCaseRef ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUsersUseCase(repository);
}
```

## ViewModelでのAPI呼び出し 🔄

プレゼンテーション層でViewModelを実装：

```dart
// lib/presentation/view_models/user_list_view_model.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/user.dart';
import '../../domain/use_cases/get_users_use_case.dart';

part 'user_list_view_model.g.dart';

@riverpod
class UserListViewModel extends _$UserListViewModel {
  @override
  Future<List<User>> build() async {
    return _fetchUsers();
  }

  Future<List<User>> _fetchUsers() async {
    final useCase = ref.read(getUsersUseCaseProvider);
    return await useCase.execute();
  }

  Future<void> refreshUsers() async {
    state = const AsyncValue.loading();
    try {
      final users = await _fetchUsers();
      state = AsyncValue.data(users);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
```

```dart
// lib/presentation/view_models/user_detail_view_model.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/user.dart';
import '../../domain/use_cases/get_user_use_case.dart';

part 'user_detail_view_model.g.dart';

@riverpod
class UserDetailViewModel extends _$UserDetailViewModel {
  @override
  Future<User> build(String userId) async {
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

## エラーハンドリング ⚠️

アプリケーション全体で一貫したエラーハンドリングを実装するため、例外クラスを定義します：

```dart
// lib/core/exceptions/app_exception.dart
abstract class AppException implements Exception {
  final String message;
  final String code;

  AppException(this.message, {this.code = 'unknown'});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

class NetworkException extends AppException {
  NetworkException(String message, {String code = 'network_error'})
      : super(message, code: code);
}

class NotFoundException extends AppException {
  NotFoundException(String message, {String code = 'not_found'})
      : super(message, code: code);
}

class AuthException extends AppException {
  AuthException(String message, {String code = 'auth_error'})
      : super(message, code: code);
}

class ValidationException extends AppException {
  ValidationException(String message, {String code = 'validation_error'})
      : super(message, code: code);
}

class ServerException extends AppException {
  ServerException(String message, {String code = 'server_error'})
      : super(message, code: code);
}
```

ViewModelでのエラーハンドリング：

```dart
// lib/presentation/view_models/user_operation_view_model.dart
@riverpod
class UserOperationViewModel extends _$UserOperationViewModel {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createUser(UserCreateParams params) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(userRepositoryProvider);
      await repository.createUser(params);
      state = const AsyncValue.data(null);
    } on NetworkException catch (e, stack) {
      state = AsyncValue.error('ネットワークエラー: ${e.message}', stack);
    } on ValidationException catch (e, stack) {
      state = AsyncValue.error('入力エラー: ${e.message}', stack);
    } catch (e, stack) {
      state = AsyncValue.error('予期せぬエラーが発生しました', stack);
    }
  }

  // 他のメソッドも同様に実装...
}
```

## キャッシュと状態の永続化 💾

オフラインサポートのためのキャッシュ戦略を実装します：

```dart
// lib/data/local/user_local_data_source.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSource(this.sharedPreferences);

  static const String _userPrefix = 'user_';
  static const String _usersKey = 'all_users';

  Future<bool> cacheUser(UserModel user) async {
    return await sharedPreferences.setString(
      _userPrefix + user.id,
      json.encode(user.toJson()),
    );
  }

  Future<bool> cacheUsers(List<UserModel> users) async {
    final userJsonList = users.map((user) => user.toJson()).toList();
    return await sharedPreferences.setString(
      _usersKey,
      json.encode(userJsonList),
    );
  }

  UserModel? getUser(String id) {
    final jsonString = sharedPreferences.getString(_userPrefix + id);
    if (jsonString == null) return null;

    try {
      return UserModel.fromJson(json.decode(jsonString));
    } catch (e) {
      return null;
    }
  }

  List<UserModel> getUsers() {
    final jsonString = sharedPreferences.getString(_usersKey);
    if (jsonString == null) return [];

    try {
      final jsonList = json.decode(jsonString) as List;
      return jsonList
          .map((item) => UserModel.fromJson(item))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> removeUser(String id) async {
    return await sharedPreferences.remove(_userPrefix + id);
  }

  Future<bool> clearAllUsers() async {
    final keys = sharedPreferences.getKeys();
    for (final key in keys) {
      if (key.startsWith(_userPrefix)) {
        await sharedPreferences.remove(key);
      }
    }
    return await sharedPreferences.remove(_usersKey);
  }
}
```

キャッシュ機能を組み込んだリポジトリ実装：

```dart
// lib/data/repositories/cached_user_repository_impl.dart
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_api_client.dart';
import '../local/user_local_data_source.dart';
import '../models/extensions/user_model_extensions.dart';
import '../models/user_model.dart';

class CachedUserRepositoryImpl implements UserRepository {
  final UserApiClient apiClient;
  final UserLocalDataSource localDataSource;

  CachedUserRepositoryImpl(this.apiClient, this.localDataSource);

  @override
  Future<User> getUser(String id) async {
    try {
      // オンラインなら新しいデータを取得
      final userModel = await apiClient.getUser(id);
      // 成功したらキャッシュを更新
      await localDataSource.cacheUser(userModel);
      return userModel.toEntity();
    } catch (e) {
      // エラー発生時はキャッシュを確認
      final cachedUser = localDataSource.getUser(id);
      if (cachedUser != null) {
        return cachedUser.toEntity();
      }
      // キャッシュもなければエラーを再スロー
      rethrow;
    }
  }

  @override
  Future<List<User>> getUsers() async {
    try {
      // オンラインなら新しいデータを取得
      final userModels = await apiClient.getUsers();
      // 成功したらキャッシュを更新
      await localDataSource.cacheUsers(userModels);
      return userModels.toEntityList();
    } catch (e) {
      // エラー発生時はキャッシュを確認
      final cachedUsers = localDataSource.getUsers();
      if (cachedUsers.isNotEmpty) {
        return cachedUsers.toEntityList();
      }
      // キャッシュもなければエラーを再スロー
      rethrow;
    }
  }

  // 他のメソッドも同様にキャッシュロジックを実装...
}
```

## サンプル実装 📱

ここからは、実際のシナリオに沿った具体的な実装例を示します。

### 新規ユーザー登録フロー

以下は新規ユーザー登録機能の実装例です：

1. **APIクライアント定義**:

```dart
// lib/data/datasources/auth_api_client.dart
@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST('/auth/register')
  Future<AuthResponse> register(@Body() Map<String, dynamic> data);
}
```

2. **リポジトリインターフェース**:

```dart
// lib/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<User> register(RegisterParams params);
}

class RegisterParams {
  final String name;
  final String email;
  final String password;

  RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
```

3. **ユースケース**:

```dart
// lib/domain/use_cases/register_use_case.dart
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<User> execute(RegisterParams params) async {
    return await repository.register(params);
  }
}
```

4. **ViewModel**:

```dart
// lib/presentation/view_models/register_view_model.dart
@riverpod
class RegisterViewModel extends _$RegisterViewModel {
  @override
  RegisterState build() {
    return const RegisterState(
      name: '',
      email: '',
      password: '',
      isLoading: false,
    );
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  Future<void> register() async {
    if (!_validateInputs()) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final useCase = ref.read(registerUseCaseProvider);
      final params = RegisterParams(
        name: state.name,
        email: state.email,
        password: state.password,
      );

      final user = await useCase.execute(params);

      // 登録成功後、ユーザーデータを認証状態に反映
      ref.read(authViewModelProvider.notifier).setUser(user);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  bool _validateInputs() {
    if (state.name.isEmpty || state.email.isEmpty || state.password.isEmpty) {
      state = state.copyWith(error: '全ての項目を入力してください');
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(state.email)) {
      state = state.copyWith(error: 'メールアドレスの形式が正しくありません');
      return false;
    }

    if (state.password.length < 8) {
      state = state.copyWith(error: 'パスワードは8文字以上で入力してください');
      return false;
    }

    return true;
  }
}

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState({
    required String name,
    required String email,
    required String password,
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? error,
  }) = _RegisterState;
}
```

5. **UI**:

```dart
// lib/presentation/views/register_screen.dart
class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerViewModelProvider);
    final viewModel = ref.read(registerViewModelProvider.notifier);

    ref.listen<RegisterState>(
      registerViewModelProvider,
      (_, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }

        if (state.isSuccess) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('アカウント登録')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: '名前'),
              onChanged: viewModel.updateName,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'メールアドレス'),
              keyboardType: TextInputType.emailAddress,
              onChanged: viewModel.updateEmail,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'パスワード'),
              obscureText: true,
              onChanged: viewModel.updatePassword,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: state.isLoading ? null : viewModel.register,
              child: state.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('登録'),
            ),
          ],
        ),
      ),
    );
  }
}
```

このガイドを参考に、アーキテクチャに沿ったAPI連携機能を実装してください。各レイヤーの責任と関係を理解し、型安全で保守性の高いコードを作成することが重要です。
