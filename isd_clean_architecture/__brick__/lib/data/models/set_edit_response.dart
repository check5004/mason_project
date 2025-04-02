import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_edit_response.freezed.dart';
part 'set_edit_response.g.dart';

/// -----------------------------------------------
/// [概要]   :編集レスポンスデータを表現するモデルクラス
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/20
/// -----------------------------------------------
@freezed
abstract class SetEditResponse with _$SetEditResponse {
  /// コンストラクタ
  ///
  /// パラメータ:
  /// * [code] - 処理結果を示す文字列コード
  /// * [msg] - 処理結果のメッセージ
  /// * [cnt] - カウンター値
  /// * [id] - 更新データのID
  const factory SetEditResponse({
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "msg") String? msg,
    @JsonKey(name: "cnt") int? cnt,
    @JsonKey(name: "id") String? id,
  }) = _SetEditResponse;

  /// JSONマップからSetEditResponseインスタンスを生成するファクトリコンストラクタ
  ///
  /// パラメータ:
  /// * [json] - JSONデータを含むマップ
  ///
  /// 戻り値: 変換されたSetEditResponseインスタンス
  factory SetEditResponse.fromJson(Map<String, dynamic> json) => _$SetEditResponseFromJson(json);
}
