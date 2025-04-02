import 'package:freezed_annotation/freezed_annotation.dart';

import '../../user_info.dart';

part 'set_kokyaku_edit_request.freezed.dart';
part 'set_kokyaku_edit_request.g.dart';

/// -----------------------------------------------
/// [概要]   :顧客情報の編集リクエストモデル
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/25
/// -----------------------------------------------
@freezed
abstract class SetKokyakuEditRequest with _$SetKokyakuEditRequest {
  /// 顧客情報の編集リクエストを作成します
  ///
  /// 引数:
  /// * [kokyakuInsertUpdateInput] - 顧客情報の登録・更新入力データ
  /// * [userInfo] - ユーザー情報
  const factory SetKokyakuEditRequest({
    @JsonKey(name: "kokyaku_insert_update_input") KokyakuInsertUpdateInput? kokyakuInsertUpdateInput,
    @JsonKey(name: "user_info") UserInfo? userInfo,
  }) = _SetKokyakuEditRequest;

  /// JSONからSetKokyakuEditRequestオブジェクトを生成します
  ///
  /// 引数:
  /// * [json] - パースするJSONマップ
  factory SetKokyakuEditRequest.fromJson(Map<String, dynamic> json) => _$SetKokyakuEditRequestFromJson(json);
}

/// -----------------------------------------------
/// [概要]   :顧客情報の登録・更新入力データモデル
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/25
/// -----------------------------------------------
@freezed
abstract class KokyakuInsertUpdateInput with _$KokyakuInsertUpdateInput {
  /// 顧客情報の登録・更新入力データを作成します
  ///
  /// 引数:
  /// * [mode] - 処理モード（1:新規登録、2:更新）
  /// * [kokyakuId] - 顧客ID
  /// * [kokyakuNo] - 顧客番号
  /// * [kokyakuSei] - 顧客姓
  /// * [kokyakuSeiKana] - 顧客姓カナ
  /// * [seibetsu] - 性別（1:男性、2:女性）
  /// * [postCd1] - 郵便番号1
  /// * [postCd2] - 郵便番号2
  /// * [address1] - 住所1
  /// * [address2] - 住所2
  /// * [birthday] - 生年月日
  /// * [tel] - 電話番号
  /// * [mobile] - 携帯電話番号
  /// * [mail] - メールアドレス
  /// * [kanriTenpo] - 管理店舗
  /// * [kanriTantosha] - 管理担当者
  /// * [dmSend] - DM送付フラグ（1:送付する、0:送付しない）
  /// * [dmUnsend] - DM不送フラグ（1:不送、0:送付可）
  /// * [bunrui] - 顧客分類
  /// * [biko] - 備考
  /// * [lastUpdate] - 最終更新日時
  const factory KokyakuInsertUpdateInput({
    @JsonKey(name: "mode") int? mode,
    @JsonKey(name: "kokyaku_id") int? kokyakuId,
    @JsonKey(name: "kokyaku_no") String? kokyakuNo,
    @JsonKey(name: "kokyaku_sei") String? kokyakuSei,
    @JsonKey(name: "kokyaku_sei_kana") String? kokyakuSeiKana,
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
    @JsonKey(name: "kanri_tenpo_nm") String? kanriTenpoNm,
    @JsonKey(name: "kanri_tantosha") String? kanriTantosha,
    @JsonKey(name: "kanri_tantosha_nm") String? kanriTantoshaNm,
    @JsonKey(name: "dm_send") int? dmSend,
    @JsonKey(name: "dm_unsend") int? dmUnsend,
    @JsonKey(name: "bunrui") String? bunrui,
    @JsonKey(name: "biko") String? biko,
    @JsonKey(name: "last_update") String? lastUpdate,
  }) = _KokyakuInsertUpdateInput;

  /// JSONからKokyakuInsertUpdateInputオブジェクトを生成します
  ///
  /// 引数:
  /// * [json] - パースするJSONマップ
  factory KokyakuInsertUpdateInput.fromJson(Map<String, dynamic> json) => _$KokyakuInsertUpdateInputFromJson(json);
}
