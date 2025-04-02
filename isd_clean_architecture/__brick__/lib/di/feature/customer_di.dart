import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/feature/customer/kokyaku_api_client.dart';
import '../../data/datasources/feature/customer/kokyaku_remote_data_source.dart';
import '../../data/datasources/feature/customer/kokyaku_remote_data_source_impl.dart';
import '../../data/repositories/feature/kokyaku_repository_impl.dart';
import '../../domain/repositories/feature/kokyaku_repository.dart';
import '../common/network_module.dart';

part 'customer_di.g.dart';

/// -----------------------------------------------
/// [概要]   :顧客関連の依存性注入を管理するプロバイダー群
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/25
/// -----------------------------------------------

/// -----------------------------------------------
/// 顧客APIクライアントのプロバイダー
///
/// 引数:
/// * [ref] - Riverpodのプロバイダー参照オブジェクト
///
/// 戻り値:
/// * KokyakuApiClient - 顧客APIクライアントのインスタンス
/// -----------------------------------------------
@Riverpod(keepAlive: true)
KokyakuApiClient kokyakuApiClient(Ref ref) {
  return KokyakuApiClient(ref.watch(dioProvider));
}

/// -----------------------------------------------
/// 顧客リモートデータソースのプロバイダー
///
/// 引数:
/// * [ref] - Riverpodのプロバイダー参照オブジェクト
///
/// 戻り値:
/// * KokyakuRemoteDataSource - 顧客リモートデータソースのインスタンス
/// -----------------------------------------------
@Riverpod(keepAlive: true)
KokyakuRemoteDataSource kokyakuRemoteDataSource(Ref ref) {
  return KokyakuRemoteDataSourceImpl(ref.watch(kokyakuApiClientProvider), ref);
}

/// -----------------------------------------------
/// 顧客リポジトリのプロバイダー
///
/// 引数:
/// * [ref] - Riverpodのプロバイダー参照オブジェクト
///
/// 戻り値:
/// * KokyakuRepository - 顧客リポジトリのインスタンス
/// -----------------------------------------------
@Riverpod(keepAlive: true)
KokyakuRepository kokyakuRepository(Ref ref) {
  return KokyakuRepositoryImpl(ref.watch(kokyakuRemoteDataSourceProvider));
}
