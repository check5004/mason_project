import 'package:freezed_annotation/freezed_annotation.dart';

import '../../user_info.dart';

part 'get_kokyaku_list_request.freezed.dart';
part 'get_kokyaku_list_request.g.dart';

/// -----------------------------------------------
/// [概要]   :顧客一覧取得APIのリクエストモデル ※supabaseデモAPI用
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/25
/// -----------------------------------------------
@freezed
abstract class GetKokyakuListRequest with _$GetKokyakuListRequest {
  /// 顧客一覧取得APIのリクエストを表すクラスのファクトリコンストラクタ
  ///
  /// パラメータ:
  /// * [kokyakuListInput] - 顧客検索条件
  /// * [userInfo] - ユーザー情報
  const factory GetKokyakuListRequest({
    @JsonKey(name: "kokyaku_list_input") KokyakuListInput? kokyakuListInput,
    @JsonKey(name: "user_info") UserInfo? userInfo,
  }) = _GetKokyakuListRequest;

  factory GetKokyakuListRequest.fromJson(Map<String, dynamic> json) => _$GetKokyakuListRequestFromJson(json);
}

/// -----------------------------------------------
/// [概要]   :顧客検索条件を表すモデル ※supabaseデモAPI用
/// [作成者] :TCC S.Tate
/// [作成日] :2025/03/25
/// -----------------------------------------------
@freezed
abstract class KokyakuListInput with _$KokyakuListInput {
  /// 顧客検索条件を表すクラスのファクトリコンストラクタ
  ///
  /// パラメータ:
  /// * [kokyakuId] - 顧客ID（完全一致）
  /// * [kokyakuSei] - 顧客姓（部分一致）
  /// * [kokyakuMei] - 顧客名（部分一致）
  /// * [kokyakuKanaSei] - 顧客姓（カナ）（部分一致）
  /// * [kokyakuKanaMei] - 顧客名（カナ）（部分一致）
  /// * [seibetsu] - 性別（完全一致）
  /// * [postCd1] - 郵便番号1（部分一致）
  /// * [postCd2] - 郵便番号2（部分一致）
  /// * [address1] - 住所1（部分一致）
  /// * [address2] - 住所2（部分一致）
  /// * [birthdayFrom] - 生年月日（検索範囲開始）（YYYY-MM-DD形式）
  /// * [birthdayTo] - 生年月日（検索範囲終了）（YYYY-MM-DD形式）
  /// * [tel] - 電話番号（部分一致）
  /// * [mobile] - 携帯電話（部分一致）
  /// * [mail] - メールアドレス（部分一致）
  /// * [kanriTenpo] - 管理店舗（部分一致）
  /// * [kanriTantosha] - 管理担当者（部分一致）
  /// * [freeWord] - フリーワード検索（複数カラムから部分一致検索）
  /// * [skipCnt] - スキップ件数（ページング用）
  /// * [limitCnt] - 取得件数（ページング用、最大100）
  /// * [sortNm] - ソート順（カンマ区切りで複数指定可能、「カラム名 [asc/desc]」の形式）
  const factory KokyakuListInput({
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
    @JsonKey(name: "birthday_from") String? birthdayFrom,
    @JsonKey(name: "birthday_to") String? birthdayTo,
    @JsonKey(name: "tel") String? tel,
    @JsonKey(name: "mobile") String? mobile,
    @JsonKey(name: "mail") String? mail,
    @JsonKey(name: "kanri_tenpo") String? kanriTenpo,
    @JsonKey(name: "kanri_tantosha") String? kanriTantosha,
    @JsonKey(name: "free_word") String? freeWord,
    @JsonKey(name: "skip_cnt") int? skipCnt,
    @JsonKey(name: "limit_cnt") int? limitCnt,
    @JsonKey(name: "sort_nm") String? sortNm,
  }) = _KokyakuListInput;

  factory KokyakuListInput.fromJson(Map<String, dynamic> json) => _$KokyakuListInputFromJson(json);
}
