// import 'dart:convert';
// import 'dart:io';

// import 'package:intl/intl.dart';
// import 'package:mason_test_19/core/constants/config.dart';
// import 'package:mason_test_19/core/network/network_util.dart';
// import 'package:mason_test_19/core/utils/com_util.dart';
// import 'package:mason_test_19/core/utils/talker_util.dart';
// import 'package:mason_test_19/data/models/error_send_request.dart';
// import 'package:mason_test_19/data/models/user_info.dart';
// import 'package:mason_test_19/di/mail_di.dart';
// import 'package:mason_test_19/main.dart';
// import 'package:mason_test_19/presentation/view_models/common/auth_viewmodel.dart';
// import 'package:mason_test_19/presentation/view_models/feature/setting/settings_viewmodel.dart';
// import 'package:talker_flutter/talker_flutter.dart';

// class MailUtil {
//   /// -----------------------------------------------
//   /// 現在日付を取得
//   /// -----------------------------------------------
//   /// 戻り値:
//   /// * `yyyy/MM/dd`
//   /// -----------------------------------------------
//   static Future<void> sendError(String errorMessage) async {
//     try {
//       // ネットワーク接続がない場合、接続が復活するまで待機
//       final isConnected = await NetworkUtil.checkAndWaitForConnectivity();
//       if (!isConnected) return;

//       final repository = appContainer.read(mailRepositoryProvider);
//       final auth = appContainer.read(authViewModelProvider);
//       if (!auth.isLoggedIn) return;
//       final userInfo = await UserInfo.fromDefaults(userId: int.tryParse(auth.userData?['user_id'] ?? ''));
//       final state = appContainer.read(settingsViewModelProvider);
//       String appMode = 'カスタム';
//       if (!state.isCustomApiUrl) {
//         switch (state.apiUrl) {
//           case Config.productionApiUrl:
//             appMode = '本番';
//           case Config.productionTestApiUrl:
//             appMode = '本番テスト';
//           case Config.developmentApiUrl:
//             appMode = '開発';
//         }
//       }
//       String body = 'アプリ内でエラーが発生しました。\n';
//       body += '\n';
//       body += '【エラー日時】\n';
//       body += '  ${DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now().toLocal())}\n';
//       body += '\n';
//       body += '【環境】\n';
//       body += '  $appMode\n';
//       body += '\n';
//       body += '【バージョン】\n';
//       body += '  ${state.versionWithBuild}\n';
//       body += '\n';
//       body += '【ログインユーザー情報】\n';
//       body += '  店舗名： ${auth.userData?['store_nm']}（店舗ID： ${auth.userData?['store_id']}）\n';
//       body += '  ユーザー名： ${auth.userData?['user_nm']}（ユーザーID： ${auth.userData?['user_id']}）\n';
//       body += '  メールアドレス： ${auth.userData?['mail']}\n';
//       body += '\n';
//       body += '【OS情報】\n';
//       body += '  OS： ${Platform.operatingSystem}\n';
//       body += '  OSバージョン： ${Platform.operatingSystemVersion}\n';
//       body += '\n';
//       body += '【エラー内容】\n';
//       body += ComUtil.strToIndent('$errorMessage\n', 1);
//       body += '\n';
//       body += '【直近のtalkerログを20件表示】\n';
//       int maxHistoryLog = talker.history.length < 20 ? talker.history.length : 20;
//       for (var i = 0; i < maxHistoryLog; i++) {
//         final originalMessage = talker.history[talker.history.length - i - 1].generateTextMessage(
//           timeFormat: TimeFormat.yearMonthDayAndTime,
//         );
//         // 改行ごとに分割
//         final lines = originalMessage.split('\n');
//         final processedLines = lines
//             .map((line) {
//               // 1行が150バイトを超える場合は省略
//               if (utf8.encode(line).length > 150) {
//                 // 150バイトに収まる部分を切り取る
//                 int byteCount = 0;
//                 StringBuffer truncatedLine = StringBuffer();
//                 for (int j = 0; j < line.length; j++) {
//                   final char = line[j];
//                   final charBytes = utf8.encode(char).length;
//                   if (byteCount + charBytes > 138) break;
//                   truncatedLine.write(char);
//                   byteCount += charBytes;
//                 }
//                 return '${truncatedLine.toString()}...(省略)';
//               } else {
//                 return line;
//               }
//             })
//             .join('\n  │ '); // 各行の先頭に '  │ ' を付加
//         body +=
//             '  ┌───────────────────────────────────ログ(${(i + 1).toString().padLeft(2, '0')})───────────────────────────────────\n';
//         body += '  │ $processedLines\n';
//         body += '  └──────────────────────────────────────────────────────────────────────────\n';
//       }

//       final request = ErrorSendRequest(error: ErrorInput(body: body), userInfo: userInfo);
//       final response = await repository.errorSend(request);
//       if (response.code != '0') {
//         throw Exception('メール送信に失敗しました。');
//       }
//     } on Exception catch (e, stackTrace) {
//       talker.error(e, stackTrace);
//     }
//   }
// }
