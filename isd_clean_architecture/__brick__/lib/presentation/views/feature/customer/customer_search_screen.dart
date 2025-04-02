import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../core/utils/com_util.dart';
import '../../../../core/utils/message_util.dart';
import '../../../../domain/entities/feature/customer/customer_entities.dart';
import '../../../../presentation/widgets/feature/customer/customer_result_section.dart';
import '../../../../presentation/widgets/feature/customer/tantosha_field_widget.dart';
import '../../../../presentation/widgets/feature/customer/tenpo_field_widget.dart';
import '../../../view_models/feature/customer/customer_search_view_model.dart';
import '../../../widgets/common/custom_scrollbar_widget.dart';
import '../../../widgets/common/input_widget.dart';
import '../../../widgets/common/number_text_field_widget.dart';
import '../../../widgets/parameter/custom_input_decoration.dart';

/// -----------------------------------------------
/// [概要]   :顧客検索画面を表示するウィジェット
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/25
/// -----------------------------------------------
class CustomerSearchScreen extends HookConsumerWidget {
  /// -----------------------------------------------
  /// 顧客検索画面を構築するコンストラクタ
  ///
  /// 引数:
  /// * [key] - Widgetの識別キー
  /// -----------------------------------------------
  const CustomerSearchScreen({super.key});

  /// -----------------------------------------------
  /// 画面ビルド処理
  /// -----------------------------------------------
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final scrollController = useScrollController();
    final rebuildTrigger = useState(0);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        title: const Text('顧客一覧'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        actions: [
          FilledButton.icon(
            onPressed: () => context.goNamed('newCustomer'),
            icon: const Icon(Icons.add),
            label: const Text('新規登録'),
          ),
        ],
      ),
      // drawer: ref.watch(navigationShellProvider) != null
      //     ? SafeArea(child: HomeDrawer(navigationShell: ref.read(navigationShellProvider)!))
      //     : null,
      body: CustomScrollbarWidget(
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                ResponsiveGridList(
                  desiredItemWidth: 450,
                  minSpacing: 8,
                  scroll: false,
                  children: [
                    _SearchSection1(key: ValueKey(rebuildTrigger.value)),
                    _SearchSection2(rebuildTrigger: rebuildTrigger.value),
                  ],
                ),
                _searchButton(ref, rebuildTrigger: rebuildTrigger, formKey: formKey),
                _resultTable(ref),
                // const BottomLogoImageWidget(),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: ScrollToTopButtonWidget(scrollController: scrollController),
    );
  }
}

/// -----------------------------------------------
/// [概要]   :顧客検索画面の検索条件セクション1を表示するウィジェット
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/25
/// -----------------------------------------------
///
/// 以下の検索条件入力フィールドを提供します:
/// * 最終更新日
/// * 顧客名
/// * 電話番号
/// * 住所
class _SearchSection1 extends HookConsumerWidget {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode()); // FocusNode をリストで管理

  /// -----------------------------------------------
  /// 検索条件セクション1を構築するコンストラクタ
  /// -----------------------------------------------
  _SearchSection1({super.key});

  /// -----------------------------------------------
  /// 画面ビルド処理
  /// -----------------------------------------------
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(customerSearchViewModelProvider.notifier);
    final searchCondition = viewModel.searchCondition.kokyakuListInput;

    // viewModelの値で初期化することで状態を維持
    final controllers = {
      'kokyakuNm': useTextEditingController(text: searchCondition?.kokyakuNm),
      'tel': useTextEditingController(text: searchCondition?.tel),
      'address': useTextEditingController(text: searchCondition?.address),
    };

    // ValueKeyのキー値変更時の処理
    useEffect(() {
      // ValueKeyが変更されたとき、ViewModelの状態から値を反映
      controllers['kokyakuNm']?.text = searchCondition?.kokyakuNm ?? '';
      controllers['tel']?.text = searchCondition?.tel ?? '';
      controllers['address']?.text = searchCondition?.address ?? '';
      return null;
    }, [key, searchCondition]);

    // テキストコントローラーの値がViewModelに反映されるようにリスナーを設定
    useEffect(() {
      void updateSearchCondition() {
        Future.microtask(() {
          viewModel.updateSearchCondition(
            (current) => current.copyWith(
              kokyakuListInput: current.kokyakuListInput?.copyWith(
                kokyakuNm: controllers['kokyakuNm']?.text,
                tel: controllers['tel']?.text,
                address: controllers['address']?.text,
              ),
            ),
          );
        });
      }

      final controllerList = controllers.values.toList();
      for (final controller in controllerList) {
        controller.addListener(updateSearchCondition);
      }

      return () {
        for (final controller in controllerList) {
          controller.removeListener(updateSearchCondition);
        }
      };
    }, [controllers['kokyakuNm']?.text, controllers['tel']?.text, controllers['address']?.text]);

    return HookConsumer(
      builder: (context, ref, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputWidget(
              title: '顧客名',
              citationColor: InputWidgetCitationColor.singleRequired,
              firstWidget: TextField(
                textInputAction: TextInputAction.next,
                focusNode: _focusNodes[0],
                onSubmitted: (_) => ComUtil.nextFocus(_focusNodes, context, 0),
                controller: controllers['kokyakuNm'],
                decoration: CustomInputDecoration(context),
              ),
              isFirstWidgetExpanded: true,
            ),
            InputWidget(
              title: '電話番号',
              citationColor: InputWidgetCitationColor.singleRequired,
              firstWidget: NumberTextField(
                textInputAction: TextInputAction.next,
                focusNode: _focusNodes[1],
                onFieldSubmitted: (_) => ComUtil.nextFocus(_focusNodes, context, 1),
                controller: controllers['tel'],
                textAlign: TextAlign.left,
              ),
              isFirstWidgetExpanded: true,
            ),
            InputWidget(
              title: '住所',
              firstWidget: TextField(
                textInputAction: TextInputAction.next,
                focusNode: _focusNodes[2],
                onSubmitted: (_) => ComUtil.nextFocus(_focusNodes, context, 2),
                controller: controllers['address'],
                decoration: CustomInputDecoration(context),
              ),
              isFirstWidgetExpanded: true,
            ),
          ],
        );
      },
    );
  }
}

/// -----------------------------------------------
/// [概要]   :顧客検索画面の検索条件セクション2を表示するウィジェット
/// [作成者] :TCC S.Tate
/// [作成日] :2024/11/25
/// -----------------------------------------------
///
/// 以下の検索条件入力フィールドを提供します:
/// * 管理店舗
/// * 担当者
class _SearchSection2 extends HookConsumerWidget {
  /// -----------------------------------------------
  /// 検索条件セクション2を構築するコンストラクタ
  /// -----------------------------------------------
  final int rebuildTrigger;

  const _SearchSection2({required this.rebuildTrigger});

  /// -----------------------------------------------
  /// 画面ビルド処理
  /// -----------------------------------------------
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(customerSearchViewModelProvider.notifier);
    final searchCondition = viewModel.searchCondition.kokyakuListInput;

    final controllers = {
      'kanriTenpo': useTextEditingController(text: searchCondition?.kanriTenpo),
      'tantosha': useTextEditingController(text: searchCondition?.tantosha),
    };

    // リビルドトリガーの変更時の処理を修正
    useEffect(() {
      // リビルドトリガーが変更された場合の処理
      // リビルドトリガーが0より大きい場合のみコントローラーをクリア
      if (rebuildTrigger > 0) {
        // ここではテキストコントローラーの値を直接クリアせず、
        // 検索条件から最新の値を設定する
        controllers['kanriTenpo']?.text = searchCondition?.kanriTenpo ?? '';
        controllers['tantosha']?.text = searchCondition?.tantosha ?? '';
      }
      return null;
    }, [rebuildTrigger, searchCondition]);

    useEffect(() {
      void updateSearchCondition() {
        Future.microtask(() {
          viewModel.updateSearchCondition(
            (current) => current.copyWith(
              kokyakuListInput: current.kokyakuListInput?.copyWith(
                kanriTenpo: controllers['kanriTenpo']?.text,
                tantosha: controllers['tantosha']?.text,
              ),
            ),
          );
        });
      }

      final controllerList = controllers.values.toList();
      for (final controller in controllerList) {
        controller.addListener(updateSearchCondition);
      }

      return () {
        for (final controller in controllerList) {
          controller.removeListener(updateSearchCondition);
        }
      };
    }, [controllers['kanriTenpo']?.text, controllers['tantosha']?.text]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputWidget(
          title: '管理店舗',
          citationColor: InputWidgetCitationColor.singleRequired,
          firstWidget: HookConsumer(
            builder: (context, ref, child) {
              return TenpoFieldWidget(id: 'customer_search_tenpo', controller: controllers['kanriTenpo']!);
            },
          ),
          isFirstWidgetExpanded: true,
        ),
        InputWidget(
          title: '担当者',
          citationColor: InputWidgetCitationColor.singleRequired,
          firstWidget: HookConsumer(
            builder: (context, ref, child) {
              return TantoshaFieldWidget(id: 'customer_search_tantosha', controller: controllers['tantosha']!);
            },
          ),
          isFirstWidgetExpanded: true,
        ),
      ],
    );
  }
}

/// -----------------------------------------------
/// 検索ボタンを生成する関数
///
/// 引数:
/// * [ref] - Riverpodの参照オブジェクト
///
/// 戻り値:
/// * [Widget] - 検索ボタンウィジェット
/// -----------------------------------------------
Widget _searchButton(
  WidgetRef ref, {
  required ValueNotifier<int> rebuildTrigger,
  required GlobalKey<FormState> formKey,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      const SizedBox(height: 30),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Tooltip(
            message: '検索条件をクリア',
            child: OutlinedButton.icon(
              icon: const Icon(Icons.clear),
              label: const Text('クリア'),
              onPressed: () {
                final viewModel = ref.read(customerSearchViewModelProvider.notifier);

                // 検索条件をクリア
                viewModel.updateSearchCondition(
                  (current) => const CustomerSearchConditionState(kokyakuListInput: CustomerSearchCondition()),
                );

                // 検索結果をクリア
                viewModel.clearResult();

                // UI上のテキストフィールドをクリアするためにリビルドトリガーを更新
                // このトリガーにより各セクションのuseEffect内で値が更新される
                rebuildTrigger.value++;
              },
            ),
          ),
          const SizedBox(width: 12),
          Consumer(
            builder: (context, ref, _) {
              final isLoading = ref.watch(searchLoadingProvider);
              final loadingNotifier = ref.read(searchLoadingProvider.notifier);
              return FilledButton.icon(
                onPressed:
                    isLoading
                        ? null
                        : () async {
                          // バリデーションチェック
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          // final searchCondition =
                          //     ref.read(customerSearchViewModelProvider.notifier).searchCondition.kokyakuListInput;
                          String errMsg = '';
                          // if ((searchCondition!.kokyakuNm == null || searchCondition.kokyakuNm!.isEmpty) &&
                          //     (searchCondition.tel == null || searchCondition.tel!.isEmpty) &&
                          //     (searchCondition.kanriTenpo == null || searchCondition.kanriTenpo!.isEmpty) &&
                          //     (searchCondition.tantosha == null || searchCondition.tantosha!.isEmpty)) {
                          //   errMsg = '顧客一覧検索時にはオレンジ項目のいずれか１項目以上が必須です。';
                          // }
                          if (errMsg.isNotEmpty && ref.context.mounted) {
                            await MessageUtil.showMsgDialog(
                              context: context,
                              title: '検索項目エラー',
                              msg: errMsg,
                              dialogType: DialogType.error,
                            );
                            return;
                          }
                          try {
                            await loadingNotifier.startLoading();
                            final viewModel = ref.read(customerSearchViewModelProvider.notifier);
                            await viewModel.goToFirstPage();
                          } catch (e) {
                            if (ref.context.mounted) {
                              await MessageUtil.showMsgDialog(
                                context: context,
                                title: 'エラー',
                                msg: '検索中にエラーが発生しました',
                                dialogType: DialogType.error,
                              );
                            }
                          } finally {
                            await loadingNotifier.stopLoading();
                          }
                        },
                icon:
                    isLoading
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.search),
                label: const Text('検索'),
              );
            },
          ),
        ],
      ),
      const SizedBox(height: 20),
    ],
  );
}

/// -----------------------------------------------
/// 検索結果テーブルを生成する関数
///
/// 引数:
/// * [ref] - Riverpodの参照オブジェクト
///
/// 戻り値:
/// * [Widget] - 検索結果テーブルウィジェット
/// -----------------------------------------------
Widget _resultTable(WidgetRef ref) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(customerSearchViewModelProvider);

        return state.when(
          loading: () => const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())),
          error:
              (error, stack) => SizedBox(
                height: 300,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('エラーが発生しました', style: Theme.of(context).textTheme.titleMedium),
                      if (error.toString().contains('Failed host lookup')) const Text('ネットワーク接続を確認してください'),
                    ],
                  ),
                ),
              ),
          data: (response) {
            // 検索結果が空の場合
            if (response.kokyakuListResults == null || response.kokyakuListResults!.isEmpty) {
              // 検索実行済みかどうかを判定
              return SizedBox(
                height: 300,
                child: Center(
                  child: response.cnt != null ? const Text('検索条件に一致する顧客はありません') : const Text('検索条件を入力し、検索ボタンを押してください'),
                ),
              );
            }

            // 検索結果がある場合
            return SizedBox(
              height: 500, // 画面の大きさに応じて調整
              child: CustomerResultSection(kokyakuList: response.kokyakuListResults!, count: response.cnt ?? 0),
            );
          },
        );
      },
    ),
  );
}
