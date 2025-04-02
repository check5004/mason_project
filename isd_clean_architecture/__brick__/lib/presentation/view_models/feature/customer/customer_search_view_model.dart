import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/talker_util.dart';
import '../../../../data/models/feature/customer/get_kokyaku_list_request.dart' as request_model;
import '../../../../data/models/feature/customer/get_kokyaku_list_response.dart' as response_model;
import '../../../../data/models/user_info.dart';
import '../../../../di/feature/customer_di.dart';
import '../../../../domain/entities/feature/customer/customer_entities.dart';

part 'customer_search_view_model.g.dart';

/// -----
/// [概要]   : 顧客検索画面の状態
/// [作成者] : TCC S.Tate
/// [作成日] : 2025/03/25
/// -----
/// 顧客検索画面で表示する情報（検索結果リスト、総件数など）を保持します。
class CustomerSearchState {
  /// 検索結果の顧客リスト
  final List<response_model.KokyakuListResult>? kokyakuListResults;

  /// 検索結果の総件数
  final int? cnt;

  const CustomerSearchState({this.kokyakuListResults, this.cnt});

  CustomerSearchState copyWith({List<response_model.KokyakuListResult>? kokyakuListResults, int? cnt}) {
    return CustomerSearchState(kokyakuListResults: kokyakuListResults ?? this.kokyakuListResults, cnt: cnt ?? this.cnt);
  }
}

/// -----
/// [概要]   : 顧客検索画面の検索条件の状態
/// [作成者] : TCC S.Tate
/// [作成日] : 2025/03/25
/// -----
/// 顧客検索画面でユーザーが入力した検索条件を保持します。
class CustomerSearchConditionState {
  /// 検索条件の入力データ
  final CustomerSearchCondition? kokyakuListInput;

  const CustomerSearchConditionState({this.kokyakuListInput});

  CustomerSearchConditionState copyWith({CustomerSearchCondition? kokyakuListInput}) {
    return CustomerSearchConditionState(kokyakuListInput: kokyakuListInput ?? this.kokyakuListInput);
  }
}

/// -----
/// [概要]   : 顧客検索画面の ViewModel
/// [作成者] : TCC S.Tate
/// [作成日] : 2025/03/25
/// -----
/// 顧客検索画面の状態管理とビジネスロジックを担当します。
/// `@riverpod` アノテーションにより、Provider が自動生成されます。
@riverpod
class CustomerSearchViewModel extends _$CustomerSearchViewModel {
  // 検索条件を保持するためのフィールド
  CustomerSearchConditionState _searchCondition = const CustomerSearchConditionState(
    kokyakuListInput: CustomerSearchCondition(),
  );

  /// -----
  /// ViewModel の初期状態を構築します。
  /// -----
  /// このメソッドは Provider が初めて読み込まれたとき、または状態が破棄されて再構築されるときに呼び出されます。
  ///
  /// 戻り値:
  /// * `FutureOr<CustomerSearchState>` - ViewModel の初期状態。
  @override
  FutureOr<CustomerSearchState> build() {
    // 初期状態として空の CustomerSearchState を返します。
    // 必要に応じて、ここで初期データのロードなどを行います。
    return const CustomerSearchState();
  }

  /// -----
  /// 現在の検索条件を取得します。
  /// -----
  ///
  /// 戻り値:
  /// * `CustomerSearchConditionState` - 現在設定されている検索条件。
  CustomerSearchConditionState get searchCondition {
    // 保持している検索条件を返す
    return _searchCondition;
  }

  /// -----
  /// 検索条件を更新します。
  /// -----
  ///
  /// 引数:
  /// * [update] - 現在の検索条件を受け取り、更新後の検索条件を返す関数。
  void updateSearchCondition(CustomerSearchConditionState Function(CustomerSearchConditionState) update) {
    final currentCondition = searchCondition;
    final updatedCondition = update(currentCondition);

    // 検索条件を更新
    _searchCondition = updatedCondition;
  }

  /// -----
  /// 検索結果をクリアします。
  /// -----
  /// 検索結果リストと件数を初期状態に戻します。
  void clearResult() {
    // 検索結果をクリア
    state = AsyncData(state.value!.copyWith(kokyakuListResults: null, cnt: null));
  }

  /// -----
  /// 検索結果の最初のページを表示します（ページネーション用）。
  /// -----
  /// 1ページ目のデータを取得・表示する想定のメソッドです。
  /// 検索ボタンが押された時などに呼び出されることを想定しています。
  Future<void> goToFirstPage() async {
    try {
      // 1. 検索条件 (searchCondition) を取得
      final currentCondition = searchCondition.kokyakuListInput;

      // 2. ローディング状態を開始
      final loadingNotifier = ref.read(searchLoadingProvider.notifier);
      await loadingNotifier.startLoading();

      // 3. API リクエスト用のパラメータを構築
      final request = request_model.GetKokyakuListRequest(
        kokyakuListInput: request_model.KokyakuListInput(
          kokyakuSei: currentCondition?.kokyakuNm,
          tel: currentCondition?.tel,
          mobile: currentCondition?.tel,
          address1: currentCondition?.address,
          address2: currentCondition?.address,
          kanriTenpo: currentCondition?.kanriTenpo,
          kanriTantosha: currentCondition?.tantosha,
          skipCnt: 0, // 最初のページのため、スキップは0
          limitCnt: 50, // 一度に取得する最大件数
          // sortNm: "kokyaku_kana_sei asc", // デフォルトのソート順
        ),
        userInfo: UserInfo(userId: 1), // デモ用ユーザー情報（IDを数値で指定）
      );

      // 4. リポジトリを使って顧客データを検索
      final kokyakuRepository = ref.read(kokyakuRepositoryProvider);
      final response = await kokyakuRepository.getKokyakuList(request);

      // 5. 取得したデータでstateを更新
      state = AsyncData(CustomerSearchState(kokyakuListResults: response.kokyakuListResults, cnt: response.cnt));
    } catch (e, stackTrace) {
      // 6. エラーハンドリング
      talker.error('顧客検索エラー: $e', stackTrace);
      state = AsyncError(e, stackTrace);
    } finally {
      // 7. ローディング状態を終了
      final loadingNotifier = ref.read(searchLoadingProvider.notifier);
      await loadingNotifier.stopLoading();
    }
  }
}

/// -----
/// [概要]   : 検索処理中のローディング状態
/// [作成者] : TCC S.Tate
/// [作成日] : 2025/03/25
/// -----
/// 顧客検索 API の呼び出し中に表示するローディングインジケーターの状態を管理します。
/// `@riverpod` アノテーションにより、Provider が自動生成されます。
@riverpod
class SearchLoading extends _$SearchLoading {
  /// -----
  /// Provider の初期状態を構築します。
  /// -----
  ///
  /// 戻り値:
  /// * `bool` - ローディング状態の初期値 (false: 非表示)。
  @override
  bool build() => false; // 初期状態はローディング非表示

  /// -----
  /// ローディング状態を開始します。
  /// -----
  /// UI にローディングインジケーターを表示させたい時に呼び出します。
  Future<void> startLoading() async {
    // 状態を true に更新してローディング表示
    state = true;
  }

  /// -----
  /// ローディング状態を終了します。
  /// -----
  /// API 呼び出し完了後やエラー発生時に呼び出し、ローディング表示を解除します。
  Future<void> stopLoading() async {
    // 状態を false に更新してローディング非表示
    state = false;
  }
}
