import '../../../domain/repositories/feature/kokyaku_repository.dart';
import '../../datasources/feature/customer/kokyaku_remote_data_source.dart';
import '../../models/feature/customer/get_kokyaku_detail_request.dart';
import '../../models/feature/customer/get_kokyaku_detail_response.dart';
import '../../models/feature/customer/get_kokyaku_list_request.dart';
import '../../models/feature/customer/get_kokyaku_list_response.dart';
import '../../models/feature/customer/set_kokyaku_edit_request.dart';
import '../../models/set_edit_response.dart';

/// -----------------------------------------------
/// [概要]   :顧客リポジトリの実装クラス
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/25
/// -----------------------------------------------
/// 顧客情報の取得に関する機能を提供するリポジトリの実装クラスです。
/// 以下の主要な機能を提供します:
/// * 顧客一覧の取得
/// * 顧客詳細情報の取得
/// * 顧客履歴情報の取得
class KokyakuRepositoryImpl implements KokyakuRepository {
  /// リモートデータソース
  final KokyakuRemoteDataSource _remoteDataSource;

  /// -----------------------------------------------
  /// コンストラクタ
  /// -----------------------------------------------
  /// 顧客リポジトリの実装クラスを初期化します。
  ///
  /// 引数:
  /// * [_remoteDataSource] - 顧客情報を取得するためのリモートデータソース
  KokyakuRepositoryImpl(this._remoteDataSource);

  /// -----------------------------------------------
  /// 顧客一覧取得処理
  /// -----------------------------------------------
  /// 指定された条件に基づいて顧客一覧を取得します。
  ///
  /// 引数:
  /// * [request] - 顧客一覧取得リクエスト
  ///
  /// 戻り値:
  /// * 顧客一覧のレスポンス
  @override
  Future<GetKokyakuListResponse> getKokyakuList(GetKokyakuListRequest request) {
    return _remoteDataSource.getKokyakuList(request);
  }

  /// -----------------------------------------------
  /// 顧客詳細情報取得処理
  /// -----------------------------------------------
  /// 指定された顧客の詳細情報を取得します。
  ///
  /// 引数:
  /// * [request] - 顧客詳細情報取得リクエスト
  ///
  /// 戻り値:
  /// * 顧客詳細情報のレスポンス
  @override
  Future<GetKokyakuDetailResponse> getKokyakuDetail(GetKokyakuDetailRequest request) {
    return _remoteDataSource.getKokyakuDetail(request);
  }

  /// -----------------------------------------------
  /// 顧客情報登録・更新処理
  /// -----------------------------------------------
  /// 顧客情報を登録・更新します。
  ///
  /// 引数:
  /// * [request] - 顧客情報登録・更新リクエスト
  ///
  /// 戻り値:
  /// * 顧客情報登録・更新のレスポンス
  @override
  Future<SetEditResponse> setKokyakuEdit(SetKokyakuEditRequest request) {
    return _remoteDataSource.setKokyakuEdit(request);
  }
}
