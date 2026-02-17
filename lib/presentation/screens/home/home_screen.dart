import "dart:async";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../core/di.dart";
import "../../../core/localization/app_localizations.dart";
import "../../../core/ui_constants.dart";
import "../../../core/mock_mode_indicator.dart";
import "../../../domain/entities/product.dart";
import "../../blocs/category/category_bloc.dart";
import "../../blocs/product/product_bloc.dart";
import "../../blocs/recommendation/recommendation_bloc.dart";
import "../../widgets/animated_list_item.dart";
import "../../widgets/empty_state.dart";
import "../../widgets/product_card.dart";
import "../../widgets/section_header.dart";
import "../../widgets/skeleton_box.dart";
import "../../widgets/category_icon.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ProductBloc _productBloc;
  late final CategoryBloc _categoryBloc;
  late final RecommendationBloc _recommendationBloc;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _searchDebounce;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _productBloc = sl<ProductBloc>();
    _categoryBloc = sl<CategoryBloc>();
    _recommendationBloc = sl<RecommendationBloc>();
    _productBloc.add(const LoadProducts());
    _categoryBloc.add(const LoadCategories());
    _recommendationBloc.add(const LoadRecommendations());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchDebounce?.cancel();
    _productBloc.close();
    _categoryBloc.close();
    _recommendationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _productBloc),
        BlocProvider.value(value: _categoryBloc),
        BlocProvider.value(value: _recommendationBloc),
      ],
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppGradients.hero),
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppSpacing.lg),
                physics: const BouncingScrollPhysics(),
                cacheExtent: 1000,
                children: [
                  AnimatedListItem(
                    index: 0,
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/branding/logo.png",
                          height: 44,
                          width: 44,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Afruza Collection",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                t("brand_tagline"),
                                style: Theme.of(context).textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const MockModeIndicator(),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, "/profile"),
                          icon: const Icon(Icons.person_outline),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AnimatedListItem(
                    index: 1,
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onChanged: (_) => _onSearchChanged(),
                      onSubmitted: (_) => _applyFilters(),
                      decoration: InputDecoration(
                        hintText: t("search_hint"),
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AnimatedListItem(
                    index: 2,
                    child: SectionHeader(title: t("categories")),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AnimatedListItem(
                    index: 3,
                    child: BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state.status == CategoryStatus.loading) {
                          return const SizedBox(
                            height: 40,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (state.status == CategoryStatus.failure) {
                          return SizedBox(
                            height: 40,
                            child: Center(
                              child: Text(
                                state.message ?? t("failed_to_load"),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          );
                        }

                        final categories = state.categories;
                        return SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              FilterChip(
                                avatar: const Icon(Icons.apps, size: 18),
                                label: Text(t("all")),
                                selected: _selectedCategoryId == null,
                                onSelected: (_) {
                                  setState(() => _selectedCategoryId = null);
                                  _applyFilters();
                                },
                              ),
                              const SizedBox(width: 8),
                              ...categories.map(
                                (category) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: FilterChip(
                                      avatar: CategoryIconWidget(
                                        icon: category.icon,
                                        size: 18,
                                        fallbackName: category.name,
                                      ),
                                      label: Text(category.name),
                                      selected:
                                          _selectedCategoryId == category.id,
                                      onSelected: (_) {
                                        setState(() =>
                                            _selectedCategoryId = category.id);
                                        _applyFilters();
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AnimatedListItem(
                    index: 4,
                    child: SectionHeader(
                      title: t("newest_drops"),
                      actionLabel: t("see_all"),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state.status == ProductStatus.loading) {
                        return _buildSkeletonGrid();
                      }
                      if (state.status == ProductStatus.failure) {
                        return EmptyState(
                          title: t("failed_to_load"),
                          subtitle: state.message ?? t("please_try_again"),
                          onAction: () => context
                              .read<ProductBloc>()
                              .add(const LoadProducts()),
                          actionLabel: t("retry"),
                        );
                      }
                      if (state.status == ProductStatus.empty ||
                          state.products.isEmpty) {
                        return EmptyState(
                          title: t("no_products"),
                          subtitle: t("no_products_subtitle"),
                          onAction: () => context
                              .read<ProductBloc>()
                              .add(const LoadProducts()),
                          actionLabel: t("refresh"),
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
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, index) {
                          final product = state.products[index];
                          final heroTag = "grid-product-${product.id}";
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
                  const SizedBox(height: AppSpacing.lg),
                  AnimatedListItem(
                    index: 5,
                    child: SectionHeader(title: t("most_viewed")),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  BlocBuilder<RecommendationBloc, RecommendationState>(
                    builder: (context, state) {
                      if (state.status == RecommendationStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state.status == RecommendationStatus.failure) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            state.message ?? t("failed_to_load"),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      }
                      if (state.mostViewed.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return SizedBox(
                        height: 260,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.mostViewed.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final product = state.mostViewed[index];
                            final heroTag = "viewed-product-${product.id}";
                            return SizedBox(
                              width: 220,
                              child: ProductCard(
                                product: product,
                                heroTag: heroTag,
                                onTap: () =>
                                    _openProduct(context, product, heroTag),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AnimatedListItem(
                    index: 6,
                    child: SectionHeader(title: t("most_sold")),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  BlocBuilder<RecommendationBloc, RecommendationState>(
                    builder: (context, state) {
                      if (state.status == RecommendationStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state.status == RecommendationStatus.failure) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            state.message ?? t("failed_to_load"),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      }
                      if (state.mostSold.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return SizedBox(
                        height: 260,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.mostSold.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final product = state.mostSold[index];
                            final heroTag = "sold-product-${product.id}";
                            return SizedBox(
                              width: 220,
                              child: ProductCard(
                                product: product,
                                heroTag: heroTag,
                                onTap: () =>
                                    _openProduct(context, product, heroTag),
                              ),
                            );
                          },
                        ),
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

  void _openProduct(BuildContext context, Product product, String heroTag) {
    Navigator.pushNamed(
      context,
      "/product",
      arguments: {"product": product, "heroTag": heroTag},
    );
  }

  void _applyFilters() {
    final query = _searchController.text.trim();
    _productBloc.add(
      LoadProducts(
        query: query.isEmpty ? null : query,
        categoryId: _selectedCategoryId,
      ),
    );
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), _applyFilters);
  }

  Future<void> _refresh() async {
    _applyFilters();
    _categoryBloc.add(const LoadCategories());
    _recommendationBloc.add(const LoadRecommendations());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _productBloc.add(const LoadMoreProducts());
    }
  }

  Widget _buildSkeletonGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: SkeletonBox(radius: 16)),
              const SizedBox(height: 6),
              const SkeletonBox(height: 14, width: 120),
              const SizedBox(height: 6),
              const SkeletonBox(height: 10, width: 80),
              const SizedBox(height: 6),
              const SkeletonBox(height: 12, width: 90),
            ],
          ),
        );
      },
    );
  }
}
