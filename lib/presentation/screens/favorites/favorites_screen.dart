import "package:flutter/material.dart";

import "../../../core/di.dart";
import "../../../core/localization/app_localizations.dart";
import "../../../core/ui_constants.dart";
import "../../../data/local/favorites_service.dart";
import "../../../domain/entities/product.dart";
import "../../widgets/empty_state.dart";
import "../../widgets/product_card.dart";

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Product>> _future;

  @override
  void initState() {
    super.initState();
    _future = sl<FavoritesService>().readFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.hero),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                    Text(t("favorites"),
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: FutureBuilder<List<Product>>(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final items = snapshot.data ?? [];
                      if (items.isEmpty) {
                        return EmptyState(
                          title: t("favorites_empty"),
                          subtitle: t("favorites_empty_subtitle"),
                        );
                      }
                      return GridView.builder(
                        itemCount: items.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.72,
                        ),
                        itemBuilder: (context, index) {
                          final product = items[index];
                          final heroTag = "favorite-product-${product.id}";
                          return ProductCard(
                            product: product,
                            heroTag: heroTag,
                            onTap: () => Navigator.pushNamed(
                              context,
                              "/product",
                              arguments: {
                                "product": product,
                                "heroTag": heroTag
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
