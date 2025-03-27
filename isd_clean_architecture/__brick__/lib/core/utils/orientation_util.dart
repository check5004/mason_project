import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

import 'talker_util.dart';

class OrientationUtil {
  /// 縦画面かどうかを判定
  /// contextが渡された場合MediaQueryを使用し判定
  static bool isPortrait({BuildContext? context}) {
    final bool isPortrait;
    if (context != null) {
      isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    } else {
      // ignore: deprecated_member_use
      isPortrait = WidgetsBinding.instance.window.physicalSize.aspectRatio < 1.0;
    }
    return isPortrait;
  }

  /// 現在の画面の向きを取得して固定する
  static Future<void> lockCurrentOrientation() async {
    try {
      final nativeOrientation = await NativeDeviceOrientationCommunicator().orientation();

      switch (nativeOrientation) {
        case NativeDeviceOrientation.portraitUp:
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp, // 縦画面
          ]);
        case NativeDeviceOrientation.portraitDown:
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitDown, // 縦画面
          ]);
        case NativeDeviceOrientation.landscapeLeft:
          if (Platform.isIOS) {
            await SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeRight, // iOS: 横画面（逆転）
            ]);
          } else {
            await SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft, // Android: 横画面（同じ向き）
            ]);
          }
        case NativeDeviceOrientation.landscapeRight:
          if (Platform.isIOS) {
            await SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft, // iOS: 横画面（逆転）
            ]);
          } else {
            await SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeRight, // Android: 横画面（同じ向き）
            ]);
          }
        default:
          // unknown や errorTimeoutの場合は現在の向きを維持
          talker.warning('画面の向き固定に失敗: 画面の向きの取得に失敗。[$nativeOrientation]');
          break;
      }
    } catch (e) {
      talker.error('画面の向き固定に失敗: $e');
    }
  }

  /// 画面の向きの固定を解除する
  static Future<void> unlockOrientation() async {
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } catch (e) {
      talker.error('画面の向き固定解除に失敗: $e');
    }
  }
}
