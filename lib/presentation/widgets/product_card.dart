import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../../domain/entities/product.dart";
import "../../core/ui_constants.dart";
import "favorite_button.dart";

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.heroTag,
    this.imageAspectRatio =
        1 / 1, // <- rasm kattaligi/shakli shu bilan boshqariladi
  });

  final Product product;
  final VoidCallback onTap;
  final String? heroTag;

  /// 1/1 = kvadrat, 4/5 = biroz balandroq, 3/4 = yana balandroq
  final double imageAspectRatio;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: "UZS ", decimalDigits: 0);
    final resolvedHeroTag = heroTag ?? "product-${product.id}";
    final outline = Theme.of(context).colorScheme.outline.withOpacity(0.18);

    final imageUrl = (product.imageUrls.isNotEmpty &&
            product.imageUrls.first.trim().isNotEmpty)
        ? product.imageUrls.first
        : "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80";

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: outline),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Hero(
                      tag: resolvedHeroTag,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: double.infinity,
                          color: Theme.of(context).colorScheme.surface,
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            memCacheHeight: 400,
                            memCacheWidth: 400,
                            maxHeightDiskCache: 600,
                            maxWidthDiskCache: 600,
                            placeholder: (context, url) => const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (context, url, error) => const Center(
                              child:
                                  Icon(Icons.broken_image_outlined, size: 32),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: FavoriteButton(product: product, size: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.categoryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatter.format(product.price),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
