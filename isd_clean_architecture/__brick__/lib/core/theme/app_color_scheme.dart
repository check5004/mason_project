import 'package:flutter/material.dart';

/// -----------------------------------------------
/// [概要]   :アプリケーションのカラースキームを定義するクラス
/// [作成者] :TCC S.Tate
/// [作成日] :2025/01/14
/// -----------------------------------------------
///
/// このクラスは入力フィールドの装飾に使用される色を管理します。
/// 必須項目、単一必須項目、通常項目の3種類の入力状態に対応する色を提供します。
///
/// ```dart
/// final appColorScheme = AppColorScheme(
///   inputRequired: Colors.red,
///   inputSingleRequired: Colors.orange,
///   inputNormal: Colors.blue,
/// );
/// ```
///
/// [copyWith]と[lerp]メソッドは、MaterialライブラリがThemeExtensionを
/// 正しく機能させるために必要とする実装です。
/// これらのメソッドはテーマの変更やアニメーションの際に内部的に使用されます。
@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  /// AppColorSchemeのコンストラクタ
  const AppColorScheme({
    required this.inputRequired,
    required this.inputSingleRequired,
    required this.inputNormal,
    required this.salesRowBlue,
    required this.sortDesc,
    required this.sortAsc,
  });

  /// 必須入力項目を示す色
  final Color inputRequired;

  /// 単一必須入力項目を示す色
  final Color inputSingleRequired;

  /// 通常の入力項目を示す色
  final Color inputNormal;

  /// 顧客履歴、売上行の背景色
  final Color salesRowBlue;

  /// ソート順：降順
  final Color sortDesc;

  /// ソート順：昇順
  final Color sortAsc;

  /// -----------------------------------------------
  /// カラースキームの複製処理
  /// -----------------------------------------------
  ///
  /// 現在のカラースキームの一部またはすべての色を新しい値で上書きした
  /// 新しいインスタンスを作成します。
  @override
  AppColorScheme copyWith({
    Color? inputRequired,
    Color? inputSingleRequired,
    Color? inputNormal,
    Color? salesRowBlue,
    Color? sortDesc,
    Color? sortAsc,
  }) {
    return AppColorScheme(
      inputRequired: inputRequired ?? this.inputRequired,
      inputSingleRequired: inputSingleRequired ?? this.inputSingleRequired,
      inputNormal: inputNormal ?? this.inputNormal,
      salesRowBlue: salesRowBlue ?? this.salesRowBlue,
      sortDesc: sortDesc ?? this.sortDesc,
      sortAsc: sortAsc ?? this.sortAsc,
    );
  }

  /// -----------------------------------------------
  /// カラースキームの補間処理
  /// -----------------------------------------------
  ///
  /// 2つのカラースキーム間で色を補間します。
  @override
  AppColorScheme lerp(ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) {
      return this;
    }
    return AppColorScheme(
      inputRequired: Color.lerp(inputRequired, other.inputRequired, t)!,
      inputSingleRequired: Color.lerp(inputSingleRequired, other.inputSingleRequired, t)!,
      inputNormal: Color.lerp(inputNormal, other.inputNormal, t)!,
      salesRowBlue: Color.lerp(salesRowBlue, other.salesRowBlue, t)!,
      sortDesc: Color.lerp(sortDesc, other.sortDesc, t)!,
      sortAsc: Color.lerp(sortAsc, other.sortAsc, t)!,
    );
  }
}
