import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/ui_constants.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/category.dart';
import '../../blocs/product/product_bloc.dart';
import '../../blocs/category/category_bloc.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/product_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/skeleton_box.dart';
import '../../widgets/category_icon.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final ProductBloc _productBloc;
  late final CategoryBloc _categoryBloc;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _searchDebounce;

  int? _selectedCategoryId;
  double? _minPrice;
  double? _maxPrice;
  int _activeFiltersCount = 0;

  @override
  void initState() {
    super.initState();
    _productBloc = sl<ProductBloc>();
    _categoryBloc = sl<CategoryBloc>();
    _productBloc.add(const LoadProducts());
    _categoryBloc.add(const LoadCategories());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchDebounce?.cancel();
    _productBloc.close();
    _categoryBloc.close();
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
    _productBloc.add(
      LoadProducts(
        query: query.isEmpty ? null : query,
        categoryId: _selectedCategoryId,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
      ),
    );
    _updateFiltersCount();
  }

  void _updateFiltersCount() {
    int count = 0;
    if (_selectedCategoryId != null) count++;
    if (_minPrice != null) count++;
    if (_maxPrice != null) count++;
    setState(() {
      _activeFiltersCount = count;
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedCategoryId = null;
      _minPrice = null;
      _maxPrice = null;
      _activeFiltersCount = 0;
    });
    _submitSearch();
  }

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _FilterBottomSheet(
        selectedCategoryId: _selectedCategoryId,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        categories: _categoryBloc.state.categories,
        onApply: (categoryId, minPrice, maxPrice) {
          setState(() {
            _selectedCategoryId = categoryId;
            _minPrice = minPrice;
            _maxPrice = maxPrice;
          });
          _submitSearch();
        },
      ),
    );
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
      '/product',
      arguments: {'product': product, 'heroTag': heroTag},
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>.value(value: _productBloc),
        BlocProvider<CategoryBloc>.value(value: _categoryBloc),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t('search'),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Row(
                        children: [
                          if (_activeFiltersCount > 0)
                            TextButton.icon(
                              onPressed: _clearFilters,
                              icon: const Icon(Icons.clear, size: 18),
                              label: Text('Tozalash ($_activeFiltersCount)'),
                            ),
                          IconButton(
                            onPressed: _showFilterSheet,
                            icon: Badge(
                              isLabelVisible: _activeFiltersCount > 0,
                              label: Text('$_activeFiltersCount'),
                              child: const Icon(Icons.tune),
                            ),
                          ),
                        ],
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
                      hintText: t('search_hint'),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SectionHeader(title: t('results')),
                  const SizedBox(height: AppSpacing.md),
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state.status == ProductStatus.loading) {
                        return _buildSkeletonGrid();
                      }
                      if (state.status == ProductStatus.failure) {
                        return EmptyState(
                          title: t('search_failed'),
                          subtitle: state.message ?? t('please_try_again'),
                          onAction: () => _submitSearch(),
                          actionLabel: t('retry'),
                        );
                      }
                      if (state.products.isEmpty) {
                        return EmptyState(
                          title: t('no_results'),
                          subtitle: t('try_different'),
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
                          final heroTag = 'search-product-${product.id}';
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
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

class _FilterBottomSheet extends StatefulWidget {
  const _FilterBottomSheet({
    required this.selectedCategoryId,
    required this.minPrice,
    required this.maxPrice,
    required this.categories,
    required this.onApply,
  });

  final int? selectedCategoryId;
  final double? minPrice;
  final double? maxPrice;
  final List<Category> categories;
  final void Function(int?, double?, double?) onApply;

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late int? _selectedCategoryId;
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.selectedCategoryId;
    _minPriceController.text = widget.minPrice?.toStringAsFixed(0) ?? '';
    _maxPriceController.text = widget.maxPrice?.toStringAsFixed(0) ?? '';
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filterlar',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Kategoriya',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  avatar: const Icon(Icons.apps, size: 18),
                  label: const Text('Barchasi'),
                  selected: _selectedCategoryId == null,
                  onSelected: (_) {
                    setState(() {
                      _selectedCategoryId = null;
                    });
                  },
                ),
                ...widget.categories.map((category) {
                  return FilterChip(
                    avatar: CategoryIconWidget(
                      icon: category.icon,
                      size: 18,
                      fallbackName: category.name,
                    ),
                    label: Text(category.name),
                    selected: _selectedCategoryId == category.id,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategoryId = category.id;
                      });
                    },
                  );
                }),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              "Narx oralig'i (UZS)",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Dan',
                      prefixText: 'UZS ',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Gacha',
                      prefixText: 'UZS ',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final minPrice = _minPriceController.text.isEmpty
                      ? null
                      : double.tryParse(_minPriceController.text);
                  final maxPrice = _maxPriceController.text.isEmpty
                      ? null
                      : double.tryParse(_maxPriceController.text);
                  widget.onApply(_selectedCategoryId, minPrice, maxPrice);
                  Navigator.pop(context);
                },
                child: const Text("Qo'llash"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
