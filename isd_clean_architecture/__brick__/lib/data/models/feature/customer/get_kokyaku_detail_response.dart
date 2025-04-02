import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_kokyaku_detail_response.freezed.dart';
part 'get_kokyaku_detail_response.g.dart';

/// -----------------------------------------------
/// [概要]   :顧客詳細情報取得レスポンスモデル
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/25
/// -----------------------------------------------
@freezed
abstract class GetKokyakuDetailResponse with _$GetKokyakuDetailResponse {
  /// 顧客詳細情報取得レスポンスを作成します
  ///
  /// 引数:
  /// * [code] - 処理結果コード
  /// * [msg] - 処理結果メッセージ
  /// * [cnt] - 取得件数
  /// * [kokyakuDetailResult] - 顧客詳細情報
  const factory GetKokyakuDetailResponse({
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "msg") String? msg,
    @JsonKey(name: "cnt") int? cnt,
    @JsonKey(name: "kokyaku_detail_result") KokyakuDetailResult? kokyakuDetailResult,
  }) = _GetKokyakuDetailResponse;

  /// JSONからGetKokyakuDetailResponseオブジェクトを生成します
  ///
  /// 引数:
  /// * [json] - パースするJSONマップ
  factory GetKokyakuDetailResponse.fromJson(Map<String, dynamic> json) => _$GetKokyakuDetailResponseFromJson(json);
}

/// -----------------------------------------------
/// [概要]   :顧客詳細情報モデル
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/25
/// -----------------------------------------------
@freezed
abstract class KokyakuDetailResult with _$KokyakuDetailResult {
  /// 顧客詳細情報を作成します
  ///
  /// 引数:
  /// * [kokyakuId] - 顧客ID
  /// * [kokyakuNo] - 顧客番号
  /// * [kokyakuSei] - 顧客姓
  /// * [kokyakuSeiKana] - 顧客姓カナ
  /// * [seibetsu] - 性別
  /// * [postCd1] - 郵便番号1
  /// * [postCd2] - 郵便番号2
  /// * [address1] - 住所1
  /// * [address2] - 住所2
  /// * [birthday] - 生年月日
  /// * [tel] - 電話番号
  /// * [mobile] - 携帯電話番号
  /// * [mail] - メールアドレス
  /// * [kanriTenpo] - 管理店舗ID
  /// * [kanriTenpoNm] - 管理店舗名
  /// * [kanriTantosha] - 管理担当者ID
  /// * [kanriTantoshaNm] - 管理担当者
  /// * [dmSend] - DM送付フラグ
  /// * [dmUnsend] - DM不送フラグ
  /// * [bunrui] - 顧客分類
  /// * [bunruiNm] - 顧客分類名称
  /// * [biko] - 備考
  /// * [lastUpdate] - 最終更新日時
  /// * [lastUser] - 最終更新者
  const factory KokyakuDetailResult({
    @JsonKey(name: "kokyaku_id") String? kokyakuId,
    @JsonKey(name: "kokyaku_no") String? kokyakuNo,
    @JsonKey(name: "kokyaku_sei") String? kokyakuSei,
    @JsonKey(name: "kokyaku_sei_kana") String? kokyakuSeiKana,
    @JsonKey(name: "seibetsu") String? seibetsu,
    @JsonKey(name: "post_cd1") String? postCd1,
    @JsonKey(name: "post_cd2") String? postCd2,
    @JsonKey(name: "address1") String? address1,
    @JsonKey(name: "address2") String? address2,
    @JsonKey(name: "birthday") String? birthday,
    @JsonKey(name: "tel") String? tel,
    @JsonKey(name: "mobile") String? mobile,
    @JsonKey(name: "mail") String? mail,
    @JsonKey(name: "kanri_tenpo") String? kanriTenpo,
    @JsonKey(name: "kanri_tenpo_nm") String? kanriTenpoNm,
    @JsonKey(name: "kanri_tantosha") String? kanriTantosha,
    @JsonKey(name: "kanri_tantosha_nm") String? kanriTantoshaNm,
    @JsonKey(name: "dm_send") String? dmSend,
    @JsonKey(name: "dm_unsend") String? dmUnsend,
    @JsonKey(name: "bunrui") String? bunrui,
    @JsonKey(name: "bunrui_nm") String? bunruiNm,
    @JsonKey(name: "biko") String? biko,
    @JsonKey(name: "last_update") String? lastUpdate,
    @JsonKey(name: "last_user") String? lastUser,
  }) = _KokyakuDetailResult;

  /// JSONからKokyakuDetailResultオブジェクトを生成します
  ///
  /// 引数:
  /// * [json] - パースするJSONマップ
  factory KokyakuDetailResult.fromJson(Map<String, dynamic> json) => _$KokyakuDetailResultFromJson(json);
}
