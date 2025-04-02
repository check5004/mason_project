import '../../../models/feature/customer/get_kokyaku_detail_request.dart';
import '../../../models/feature/customer/get_kokyaku_detail_response.dart';
import '../../../models/feature/customer/get_kokyaku_list_request.dart';
import '../../../models/feature/customer/get_kokyaku_list_response.dart';
import '../../../models/feature/customer/set_kokyaku_edit_request.dart';
import '../../../models/set_edit_response.dart';

/// -----------------------------------------------
/// [概要]   :顧客データのリモートデータソースインターフェース
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/25
/// -----------------------------------------------
abstract class KokyakuRemoteDataSource {
  /// 顧客一覧を取得します
  ///
  /// 引数:
  /// * [request] - 顧客一覧取得リクエストパラメータ
  ///
  /// 戻り値:
  /// * Future\<GetKokyakuListResponse> - 顧客一覧のレスポンス
  Future<GetKokyakuListResponse> getKokyakuList(GetKokyakuListRequest request);

  /// 顧客詳細情報を取得します
  ///
  /// 引数:
  /// * [request] - 顧客詳細情報取得リクエストパラメータ
  ///
  /// 戻り値:
  /// * Future\<GetKokyakuDetailResponse> - 顧客詳細情報のレスポンス
  Future<GetKokyakuDetailResponse> getKokyakuDetail(GetKokyakuDetailRequest request);

  /// 顧客情報を登録・更新します
  ///
  /// 引数:
  /// * [request] - 顧客情報登録・更新リクエストパラメータ
  ///
  /// 戻り値:
  /// * Future\<SetEditResponse> - 顧客情報登録・更新レスポンス
  Future<SetEditResponse> setKokyakuEdit(SetKokyakuEditRequest request);
}
