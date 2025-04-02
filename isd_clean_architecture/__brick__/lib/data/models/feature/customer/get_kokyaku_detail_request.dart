import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../user_info.dart';

part 'get_kokyaku_detail_request.freezed.dart';
part 'get_kokyaku_detail_request.g.dart';

/// -----------------------------------------------
/// [概要]   :顧客詳細情報取得リクエストモデル
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/25
/// -----------------------------------------------
@freezed
abstract class GetKokyakuDetailRequest with _$GetKokyakuDetailRequest {
  /// 顧客詳細情報取得リクエストを作成します
  ///
  /// 引数:
  /// * [kokyakuDetailInput] - 顧客詳細情報取得の入力パラメータ
  /// * [userInfo] - ユーザー情報
  const factory GetKokyakuDetailRequest({
    @JsonKey(name: "kokyaku_detail_input") KokyakuDetailInput? kokyakuDetailInput,
    @JsonKey(name: "user_info") UserInfo? userInfo,
  }) = _GetKokyakuDetailRequest;

  /// JSONからGetKokyakuDetailRequestオブジェクトを生成します
  ///
  /// 引数:
  /// * [json] - パースするJSONマップ
  factory GetKokyakuDetailRequest.fromJson(Map<String, dynamic> json) => _$GetKokyakuDetailRequestFromJson(json);
}

/// -----------------------------------------------
/// [概要]   :顧客詳細情報取得の入力パラメータモデル
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/25
/// -----------------------------------------------
@freezed
abstract class KokyakuDetailInput with _$KokyakuDetailInput {
  /// 顧客詳細情報取得の入力パラメータを作成します
  ///
  /// 引数:
  /// * [kokyakuId] - 取得対象の顧客ID
  const factory KokyakuDetailInput({@JsonKey(name: "kokyaku_id") Decimal? kokyakuId}) = _KokyakuDetailInput;

  /// JSONからKokyakuDetailInputオブジェクトを生成します
  ///
  /// 引数:
  /// * [json] - パースするJSONマップ
  factory KokyakuDetailInput.fromJson(Map<String, dynamic> json) => _$KokyakuDetailInputFromJson(json);
}
