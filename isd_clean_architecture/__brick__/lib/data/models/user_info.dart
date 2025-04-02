import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'user_info.freezed.dart';
part 'user_info.g.dart';

/// -----------------------------------------------
/// [概要]   :ユーザー情報モデル
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/05
/// -----------------------------------------------
///
/// ユーザーの基本情報を保持するデータモデルクラスです。
/// Freezedを使用して、イミュータブルなデータクラスを生成します。
///
/// 保持する情報:
/// * ユーザーID
/// * OS情報
/// * アプリケーション情報
@freezed
abstract class UserInfo with _$UserInfo {
  /// -----------------------------------------------
  /// UserInfoを構築するファクトリコンストラクタ
  ///
  /// 引数:
  /// * [userId] - ユーザーの一意識別子
  /// * [os] - ユーザーの使用しているOS
  /// * [application] - 使用しているアプリケーション名
  /// -----------------------------------------------
  const factory UserInfo({
    @JsonKey(name: "user_id") int? userId,
    @JsonKey(name: "os") String? os,
    @JsonKey(name: "application") String? application,
  }) = _UserInfo;

  /// -----------------------------------------------
  /// JSONからUserInfoインスタンスを生成するファクトリメソッド
  ///
  /// 引数:
  /// * [json] - パースするJSONマップ
  ///
  /// 戻り値:
  /// * UserInfo - 生成されたUserInfoインスタンス
  /// -----------------------------------------------
  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  /// -----------------------------------------------
  /// デフォルト値を含めてUserInfoを生成する静的メソッド
  ///
  /// 非同期でPackageInfoなどを取得してインスタンスを構築します。
  ///
  /// 戻り値:
  /// * Future<UserInfo> - 生成されたUserInfoインスタンス
  /// -----------------------------------------------
  static Future<UserInfo> fromDefaults({int? userId}) async {
    // PackageInfoからアプリケーション情報を取得
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return UserInfo(
      userId: userId,
      os: Platform.operatingSystem, // 同期的にOSを取得
      application: '${packageInfo.version}+${packageInfo.buildNumber}', // アプリ情報をセット
    );
  }
}
