import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../core/di.dart";
import "../../../core/localization/app_localizations.dart";
import "../../../core/ui_constants.dart";
import "../../../domain/entities/product.dart";
import "../../blocs/product/product_bloc.dart";
import "../../widgets/empty_state.dart";
import "../../widgets/product_card.dart";
import "../../widgets/section_header.dart";
import "../../widgets/skeleton_box.dart";

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final ProductBloc _productBloc;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _productBloc = sl<ProductBloc>();
    _productBloc.add(const LoadProducts());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchDebounce?.cancel();
    _productBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= maxScroll - 200) {
      _productBloc.add(const LoadMoreProducts());
    }
  }

  void _submitSearch() {
    final query = _searchController.text.trim();
    _productBloc.add(LoadProducts(query: query.isEmpty ? null : query));
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), _submitSearch);
  }

  Future<void> _refresh() async {
    _submitSearch();
  }

  void _openProduct(BuildContext context, Product product, String heroTag) {
    Navigator.pushNamed(
      context,
      "/product",
      arguments: {"product": product, "heroTag": heroTag},
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return BlocProvider.value(
      value: _productBloc,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppGradients.hero),
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t("search"),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        onPressed: _submitSearch,
                        icon: const Icon(Icons.tune),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onChanged: (_) => _onSearchChanged(),
                    onSubmitted: (_) => _submitSearch(),
                    decoration: InputDecoration(
                      hintText: t("search_hint"),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SectionHeader(title: t("results")),
                  const SizedBox(height: AppSpacing.md),
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state.status == ProductStatus.loading) {
                        return _buildSkeletonGrid();
                      }
                      if (state.status == ProductStatus.failure) {
                        return EmptyState(
                          title: t("search_failed"),
                          subtitle: state.message ?? t("please_try_again"),
                          onAction: () => _submitSearch(),
                          actionLabel: t("retry"),
                        );
                      }
                      if (state.products.isEmpty) {
                        return EmptyState(
                          title: t("no_results"),
                          subtitle: t("try_different"),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.72,
                        ),
                        itemBuilder: (context, index) {
                          final product = state.products[index];
                          final heroTag = "search-product-${product.id}";
                          return ProductCard(
                            product: product,
                            heroTag: heroTag,
                            onTap: () =>
                                _openProduct(context, product, heroTag),
                          );
                        },
                      );
                    },
                  ),
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (!state.isLoadingMore) {
                        return const SizedBox.shrink();
                      }
                      return const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(child: SkeletonBox()),
            SizedBox(height: 12),
            SkeletonBox(height: 14, width: 120),
            SizedBox(height: 8),
            SkeletonBox(height: 12, width: 80),
          ],
        );
      },
    );
  }
}
