import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/feature/customer/get_kokyaku_detail_request.dart';
import '../../../models/feature/customer/get_kokyaku_detail_response.dart';
import '../../../models/feature/customer/get_kokyaku_list_request.dart';
import '../../../models/feature/customer/get_kokyaku_list_response.dart';
import '../../../models/feature/customer/set_kokyaku_edit_request.dart';
import '../../../models/set_edit_response.dart';

part 'kokyaku_api_client.g.dart';

/// -----------------------------------------------
/// [概要]   :顧客情報に関するAPIクライアント
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/25
/// -----------------------------------------------
@RestApi()
abstract class KokyakuApiClient {
  factory KokyakuApiClient(Dio dio, {String baseUrl}) = _KokyakuApiClient;

  /// -----------------------------------------------
  /// 顧客一覧を取得する
  ///
  /// 引数:
  /// * [request] - 顧客一覧取得リクエストパラメータ
  /// * [token] - 認証トークン
  ///
  /// 戻り値:
  /// * Future\<GetKokyakuListResponse> - 顧客一覧レスポンス
  /// -----------------------------------------------
  @POST('/get-kokyaku-list')
  Future<GetKokyakuListResponse> getKokyakuList(
    @Body() GetKokyakuListRequest request, {
    @Header('Authorization') String? token,
    @SendProgress() void Function(int, int)? onSendProgress,
    @ReceiveProgress() void Function(int, int)? onReceiveProgress,
  });

  /// -----------------------------------------------
  /// 顧客詳細情報を取得する
  ///
  /// 引数:
  /// * [request] - 顧客詳細情報取得リクエストパラメータ
  /// * [token] - 認証トークン
  ///
  /// 戻り値:
  /// * Future\<GetKokyakuDetailResponse> - 顧客詳細情報レスポンス
  /// -----------------------------------------------
  @POST('/get-kokyaku-detail')
  Future<GetKokyakuDetailResponse> getKokyakuDetail(
    @Body() GetKokyakuDetailRequest request, {
    @Header('Authorization') String? token,
    @SendProgress() void Function(int, int)? onSendProgress,
    @ReceiveProgress() void Function(int, int)? onReceiveProgress,
  });

  /// -----------------------------------------------
  /// 顧客情報を登録・更新する
  ///
  /// 引数:
  /// * [request] - 顧客情報登録・更新リクエストパラメータ
  /// * [token] - 認証トークン
  ///
  /// 戻り値:
  /// * Future\<SetEditResponse> - 顧客情報登録・更新レスポンス
  /// -----------------------------------------------
  @POST('/set-kokyaku-edit')
  Future<SetEditResponse> setKokyakuEdit(
    @Body() SetKokyakuEditRequest request, {
    @Header('Authorization') String? token,
    @SendProgress() void Function(int, int)? onSendProgress,
    @ReceiveProgress() void Function(int, int)? onReceiveProgress,
  });
}
