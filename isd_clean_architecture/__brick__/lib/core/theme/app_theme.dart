import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade the package to version 8.2.0.
///
/// Use it in a [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
///
/// playground:
///   [LINK](https://rydmike.com/flexcolorscheme/themesplayground-latest/?config=H4sIABgU4mcA_8VYW0_jOBR-n19R8bxCJQWW5a2lsFstXdC07DxWbnLSWDh2ZDu97Gj--xw7cYjTpHSkwvKE8n32uV_c7196-HeWMbJbSZHzaBERTc5ue2fzBFJQvecK6RmkB9tMSA1RL7g67w_Og35w1bu4uA2uboObs9_2bluDVFRwc-HNeXDedxTC6IpDNJYii8TG4Frm4MAsGxE50zsGYyJfEfxuAQtGROqF3mVg7gSep4uYwXaBZ5ZELpQ5VAqx9DVhuaUuSfhaKHVm0R_7wh7pKtEfK23JgEfGqCd-J5iQyrfcwo-wBlYafrkHOCUvPMR8rF0ZE6a8O594_daLfgtWXVyBQmuR_kPWdEU0BhHdNM01vHAFDELMgYmGtCEsFGlGQj0VEfiWhYLHVKbPElJiMe9UrlDSHKSmRO7eiXlojGx1-sPD71fjy_tr3-URJUysRkJGIL-SiObGQUHfQ-8ZrK2NCA0cIskG5IRHNCRayFloCsJ6-L0UUZa66FY0kzRFQ309weoA0ShHt_NTihP8uRB4J7gmlIM8KBkwVihl9wEWdymwzSQoRddgcthR_ByJmcAI8dUwtLloVR2yDdmpOyrDnJFjDrwomCUka-ZfgqkP0kiWROkHuoWowaA8y_UYPSNNLoyq6h6yLCGuVgfHkF2Z_dFO9tP05gBpXgTg_WZlDy-W9lABtyZJrhm63Q-ML3eixoDF7xd2k_JAGXvHfdgEYrqdYJoZz314YXUJ_2TBNXHHTLUTizxqtp1C5guPBfZziP4iqkjUZr5okMTW5H0c4xxpjMBXgMz4515K0Sxph5XtrAOtGlgH7uZMV6cxvC7pb5IbKu912D3GIbWcSgegLm1TjBxO5voEu_Chqpv0a9_r_Mva94p8XX7k9fn_1stOWTwqlzEJoWM4eArU1e63Eap5_YR7CNW7mjvaeR_eBfgvLVAee-Z4J-5W1UJwQFMn-5EsgX2ik74Syo4Kokf8ZAV_IYyG_r_FsS78cwIp-BRrWOGiNfrmZk7dMeiAotq7KZnI8mxqepe_DF038bYepkISx4LZN9ZEzbEFjxg2rYYIx7LiJ-pbQnVzJyzMxwSDLSJX7isQGSZ1wYGHoFF_MrEkzK2ZtSGgYIUd9kM2_NZQqERsZqUVOKHb3puKprg5Y_0Ms8yZ2m9id_imExw1V47iilExigH612gxN3O9ufaVjd28Bo9-yJdnFql5QrbZapb1tzn0aGwsgtmw_k328e_6Ewv3c7zu9w3JHmFFwl0RlQmfDpq-Q0pZ3UMct255sJe1hnJDdZjMkzxd2gfMjP7XTGltcqF8mh_0hSV2O4FZgzyDtQ3_mCqyxO3fvqQEa2iohUmCKehEFD9l1H9sKMCZZ3THMqVFRkObivfoGGrNGexhM41mlWjgukNe9ey5WK0YTJR15V7i4v7atgHi5wdME3umqCxfM8T_hl3rrzAITYPiJy26NlVThtw_PR1YsZ034CtdUsJaDgouXGMtS615tsZo67pIqW-o_vWzfFn8HriH1DbXBlCL9r6oqDIxqH00zp1jq5mBzjOTHe79u6YqJ8y8Pott4GD2FuRFVLLbMjgUaSykNsn6jD0O_0_LfP7y4yfMU7sqExUAAA==)
abstract final class AppTheme {
  // The FlexColorScheme defined light mode ThemeData.
  static ThemeData light = FlexThemeData.light(
    // Using FlexColorScheme built-in FlexScheme enum based colors
    scheme: FlexScheme.blue,
    // Input color modifiers.
    usedColors: 2,
    swapColors: true,
    // Surface color adjustments.
    surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
    blendLevel: 1,
    // Convenience direct styling properties.
    appBarStyle: FlexAppBarStyle.background,
    // Component theme configurations for light mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnLevel: 10,
      useM2StyleDividerInM3: true,
      elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
      elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
      segmentedButtonSchemeColor: SchemeColor.primary,
      inputDecoratorSchemeColor: SchemeColor.primary,
      inputDecoratorIsDense: true,
      inputDecoratorBackgroundAlpha: 9,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorRadius: 8.0,
      inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
      popupMenuRadius: 6.0,
      popupMenuElevation: 4.0,
      alignedDropdown: true,
      dialogElevation: 3.0,
      dialogRadius: 20.0,
      drawerIndicatorSchemeColor: SchemeColor.primary,
      bottomNavigationBarMutedUnselectedLabel: false,
      bottomNavigationBarMutedUnselectedIcon: false,
      menuRadius: 6.0,
      menuElevation: 4.0,
      menuBarRadius: 0.0,
      menuBarElevation: 1.0,
      searchBarElevation: 2.0,
      searchViewElevation: 2.0,
      searchUseGlobalShape: true,
      navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
      navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
      navigationBarIndicatorSchemeColor: SchemeColor.primary,
      navigationBarBackgroundSchemeColor: SchemeColor.surfaceContainer,
      navigationBarElevation: 0.0,
      navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
      navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
      navigationRailUseIndicator: true,
      navigationRailIndicatorSchemeColor: SchemeColor.primary,
      navigationRailIndicatorOpacity: 1.00,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = FlexThemeData.dark(
    // Using FlexColorScheme built-in FlexScheme enum based colors.
    scheme: FlexScheme.blue,
    // Input color modifiers.
    usedColors: 2,
    // Surface color adjustments.
    surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
    blendLevel: 4,
    // Convenience direct styling properties.
    appBarStyle: FlexAppBarStyle.background,
    // Component theme configurations for dark mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnLevel: 10,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
      elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
      segmentedButtonSchemeColor: SchemeColor.primary,
      inputDecoratorSchemeColor: SchemeColor.primary,
      inputDecoratorIsDense: true,
      inputDecoratorBackgroundAlpha: 43,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorRadius: 8.0,
      inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
      popupMenuRadius: 6.0,
      popupMenuElevation: 4.0,
      alignedDropdown: true,
      dialogElevation: 3.0,
      dialogRadius: 20.0,
      drawerIndicatorSchemeColor: SchemeColor.primary,
      bottomNavigationBarMutedUnselectedLabel: false,
      bottomNavigationBarMutedUnselectedIcon: false,
      menuRadius: 6.0,
      menuElevation: 4.0,
      menuBarRadius: 0.0,
      menuBarElevation: 1.0,
      searchBarElevation: 2.0,
      searchViewElevation: 2.0,
      searchUseGlobalShape: true,
      navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
      navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
      navigationBarIndicatorSchemeColor: SchemeColor.primary,
      navigationBarBackgroundSchemeColor: SchemeColor.surfaceContainer,
      navigationBarElevation: 0.0,
      navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
      navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
      navigationRailUseIndicator: true,
      navigationRailIndicatorSchemeColor: SchemeColor.primary,
      navigationRailIndicatorOpacity: 1.00,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
