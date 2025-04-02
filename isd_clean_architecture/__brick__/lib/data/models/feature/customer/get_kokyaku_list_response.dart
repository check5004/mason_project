import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_kokyaku_list_response.freezed.dart';
part 'get_kokyaku_list_response.g.dart';

/// -----------------------------------------------
/// [概要]   :顧客一覧取得APIのレスポンスモデル ※supabaseデモAPI用
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/25
/// -----------------------------------------------
@freezed
abstract class GetKokyakuListResponse with _$GetKokyakuListResponse {
  /// 顧客一覧取得APIのレスポンスを表すクラスのファクトリコンストラクタ
  ///
  /// パラメータ:
  /// * [code] - レスポンスコード
  /// * [msg] - レスポンスメッセージ
  /// * [cnt] - 取得した顧客データの件数
  /// * [kokyakuListResults] - 顧客情報の一覧
  const factory GetKokyakuListResponse({
    @JsonKey(name: "code") int? code,
    @JsonKey(name: "msg") String? msg,
    @JsonKey(name: "cnt") int? cnt,
    @JsonKey(name: "kokyaku_list_results") List<KokyakuListResult>? kokyakuListResults,
  }) = _GetKokyakuListResponse;

  /// JSONからGetKokyakuListResponseオブジェクトを生成するファクトリメソッド
  ///
  /// パラメータ:
  /// * [json] - パースするJSONマップ
  factory GetKokyakuListResponse.fromJson(Map<String, dynamic> json) => _$GetKokyakuListResponseFromJson(json);
}

/// -----------------------------------------------
/// [概要]   :顧客一覧の各顧客情報を表すモデル ※supabaseデモAPI用
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/25
/// -----------------------------------------------
@freezed
abstract class KokyakuListResult with _$KokyakuListResult {
  /// 顧客情報を表すクラスのファクトリコンストラクタ
  ///
  /// パラメータ:
  /// * [kokyakuId] - 顧客ID
  /// * [kokyakuSei] - 顧客姓
  /// * [kokyakuMei] - 顧客名
  /// * [kokyakuKanaSei] - 顧客姓（カナ）
  /// * [kokyakuKanaMei] - 顧客名（カナ）
  /// * [seibetsu] - 性別（1: 男性、2: 女性、9: その他）
  /// * [postCd1] - 郵便番号1
  /// * [postCd2] - 郵便番号2
  /// * [address1] - 住所1
  /// * [address2] - 住所2
  /// * [birthday] - 生年月日（YYYY-MM-DD形式）
  /// * [tel] - 電話番号
  /// * [mobile] - 携帯電話
  /// * [mail] - メールアドレス
  /// * [kanriTenpo] - 管理店舗
  /// * [kanriTantosha] - 管理担当者
  /// * [biko] - 備考
  /// * [updDatetime] - 更新日時（ISO 8601形式）
  /// * [insDatetime] - 登録日時（ISO 8601形式）
  const factory KokyakuListResult({
    @JsonKey(name: "kokyaku_id") int? kokyakuId,
    @JsonKey(name: "kokyaku_sei") String? kokyakuSei,
    @JsonKey(name: "kokyaku_mei") String? kokyakuMei,
    @JsonKey(name: "kokyaku_kana_sei") String? kokyakuKanaSei,
    @JsonKey(name: "kokyaku_kana_mei") String? kokyakuKanaMei,
    @JsonKey(name: "seibetsu") int? seibetsu,
    @JsonKey(name: "post_cd1") String? postCd1,
    @JsonKey(name: "post_cd2") String? postCd2,
    @JsonKey(name: "address1") String? address1,
    @JsonKey(name: "address2") String? address2,
    @JsonKey(name: "birthday") String? birthday,
    @JsonKey(name: "tel") String? tel,
    @JsonKey(name: "mobile") String? mobile,
    @JsonKey(name: "mail") String? mail,
    @JsonKey(name: "kanri_tenpo") String? kanriTenpo,
    @JsonKey(name: "kanri_tantosha") String? kanriTantosha,
    @JsonKey(name: "biko") String? biko,
    @JsonKey(name: "upd_datetime") String? updDatetime,
    @JsonKey(name: "ins_datetime") String? insDatetime,
  }) = _KokyakuListResult;

  /// JSONからKokyakuListResultオブジェクトを生成するファクトリメソッド
  ///
  /// パラメータ:
  /// * [json] - パースするJSONマップ
  factory KokyakuListResult.fromJson(Map<String, dynamic> json) => _$KokyakuListResultFromJson(json);
}
