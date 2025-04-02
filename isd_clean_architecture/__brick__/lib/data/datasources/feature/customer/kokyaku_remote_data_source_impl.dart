import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/network_util.dart';
import '../../../../data/local/auth_token_storage.dart';
import '../../../../presentation/view_models/widget/progress_viewmodel.dart';
import '../../../models/feature/customer/get_kokyaku_detail_request.dart';
import '../../../models/feature/customer/get_kokyaku_detail_response.dart';
import '../../../models/feature/customer/get_kokyaku_list_request.dart';
import '../../../models/feature/customer/get_kokyaku_list_response.dart';
import '../../../models/feature/customer/set_kokyaku_edit_request.dart';
import '../../../models/set_edit_response.dart';
import 'kokyaku_api_client.dart';
import 'kokyaku_remote_data_source.dart';

/// -----------------------------------------------
/// [概要]   :顧客データのリモートデータソース実装クラス
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/25
/// -----------------------------------------------
/// 顧客情報に関するリモートデータソースの実装を提供するクラスです。
/// 以下の主要な機能を提供します:
/// * 顧客一覧の取得
/// * 顧客詳細情報の取得
/// * プログレス表示付きのAPI通信処理
class KokyakuRemoteDataSourceImpl implements KokyakuRemoteDataSource {
  /// APIクライアントインスタンス
  final KokyakuApiClient _client;

  /// Riverpodのrefインスタンス
  final Ref _ref;

  /// -----------------------------------------------
  /// コンストラクタ
  /// -----------------------------------------------
  /// 顧客リモートデータソースの実装クラスを初期化します。
  ///
  /// 引数:
  /// * [_client] - 顧客情報のAPI通信を行うクライアントインスタンス
  /// * [_ref] - Riverpodの依存関係を管理するためのrefインスタンス
  KokyakuRemoteDataSourceImpl(this._client, this._ref);

  /// -----------------------------------------------
  /// 顧客一覧取得処理
  /// -----------------------------------------------
  @override
  Future<GetKokyakuListResponse> getKokyakuList(GetKokyakuListRequest request) {
    return NetworkUtil.withNetworkMonitoring(
      ref: _ref,
      apiCall:
          () => _ref
              .read(progressManagerProvider.notifier)
              .executeWithProgress(
                progressId: 'getKokyakuList',
                operation:
                    ({onSendProgress, onReceiveProgress}) => _client.getKokyakuList(
                      request,
                      token: _ref.read(authTokenProvider.notifier).currentToken,
                      onSendProgress: onSendProgress,
                      onReceiveProgress: onReceiveProgress,
                    ),
              ),
    );
  }

  /// -----------------------------------------------
  /// 顧客詳細情報取得処理
  /// -----------------------------------------------
  @override
  Future<GetKokyakuDetailResponse> getKokyakuDetail(GetKokyakuDetailRequest request) {
    return NetworkUtil.withNetworkMonitoring(
      ref: _ref,
      apiCall:
          () => _ref
              .read(progressManagerProvider.notifier)
              .executeWithProgress(
                progressId: 'getKokyakuDetail',
                operation:
                    ({onSendProgress, onReceiveProgress}) => _client.getKokyakuDetail(
                      request,
                      token: _ref.read(authTokenProvider.notifier).currentToken,
                      onSendProgress: onSendProgress,
                      onReceiveProgress: onReceiveProgress,
                    ),
              ),
    );
  }

  /// -----------------------------------------------
  /// 顧客情報登録・更新処理
  /// -----------------------------------------------
  @override
  Future<SetEditResponse> setKokyakuEdit(SetKokyakuEditRequest request) {
    return NetworkUtil.withNetworkMonitoring(
      ref: _ref,
      enableRetry: false, // リトライを無効にする
      apiCall:
          () => _ref
              .read(progressManagerProvider.notifier)
              .executeWithProgress(
                progressId: 'setKokyakuEdit',
                operation:
                    ({onSendProgress, onReceiveProgress}) => _client.setKokyakuEdit(
                      request,
                      token: _ref.read(authTokenProvider.notifier).currentToken,
                      onSendProgress: onSendProgress,
                      onReceiveProgress: onReceiveProgress,
                    ),
              ),
    );
  }
}
