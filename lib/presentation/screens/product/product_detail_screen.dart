import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../../../core/di.dart";
import "../../../core/localization/app_localizations.dart";
import "../../../core/ui_constants.dart";
import "../../../data/remote/api_exception.dart";
import "../../../data/local/storage_service.dart";
import "../../../domain/entities/product.dart";
import "../../../domain/usecases/create_order.dart";
import "../../widgets/favorite_button.dart";

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  bool _isSubmitting = false;
  ProductVariant? _selectedVariant;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    final args = ModalRoute.of(context)?.settings.arguments;
    final product =
        args is Product ? args : (args as Map?)?["product"] as Product?;
    final heroTag = args is Map ? args["heroTag"] as String? : null;
    final formatter = NumberFormat.currency(symbol: "UZS ", decimalDigits: 0);

    if (product == null) {
      return Scaffold(body: Center(child: Text(t("no_product_selected"))));
    }

    if (_selectedVariant == null && product.variants.isNotEmpty) {
      _selectedVariant = product.variants.first;
    }

    final selectedPrice = _selectedVariant?.price ?? product.price;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.hero),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                    const Spacer(),
                    FavoriteButton(product: product),
                  ],
                ),
              ),
              Hero(
                tag: heroTag ?? "product-${product.id}",
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.surface,
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrls.isNotEmpty
                          ? product.imageUrls.first
                          : "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab",
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.broken_image_outlined, size: 32),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(28, 28, 28, 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDFBF7),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 6),
                      Text(
                        product.categoryName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(product.description,
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 16),
                      if (product.variants.isNotEmpty)
                        _VariantSelector(
                          variants: product.variants,
                          selected: _selectedVariant,
                          onChanged: (value) =>
                              setState(() => _selectedVariant = value),
                        ),
                      if (product.variants.isNotEmpty)
                        const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatter.format(selectedPrice),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                          _QuantitySelector(
                            quantity: quantity,
                            onChanged: (value) =>
                                setState(() => quantity = value),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _isSubmitting
                              ? null
                              : () => _placeOrder(context, product),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(t("order_now")),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _placeOrder(BuildContext context, Product product) async {
    final storage = sl<StorageService>();
    final isLoggedIn = await storage.isTokenValid(const Duration(days: 30));
    if (!isLoggedIn) {
      if (!mounted) return;
      Navigator.pushNamed(context, "/login");
      return;
    }
    final shouldContinue = await _confirmDelivery(context);
    if (!shouldContinue) {
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await sl<CreateOrder>()(
        productId: product.id,
        variantId: _selectedVariant?.id,
        quantity: quantity,
      );
      if (!mounted) return;
      await _showOrderSuccess(context);
    } catch (error) {
      if (!mounted) return;
      final t = AppLocalizations.of(context).t;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is ApiException ? error.message : t("order_failed"),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _showOrderSuccess(BuildContext context) async {
    final t = AppLocalizations.of(context).t;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t("order_placed")),
        content: Text(t("order_success")),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text(t("close"))),
        ],
      ),
    );
  }

  Future<bool> _confirmDelivery(BuildContext context) async {
    final t = AppLocalizations.of(context).t;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t("order_confirm_title")),
        content: Text(t("delivery_notice_15_days")),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t("cancel")),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t("confirm_order")),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({
    required this.quantity,
    required this.onChanged,
  });

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
            icon: const Icon(Icons.remove),
          ),
          Text("$quantity", style: Theme.of(context).textTheme.titleMedium),
          IconButton(
            onPressed: () => onChanged(quantity + 1),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class _VariantSelector extends StatelessWidget {
  const _VariantSelector({
    required this.variants,
    required this.selected,
    required this.onChanged,
  });

  final List<ProductVariant> variants;
  final ProductVariant? selected;
  final ValueChanged<ProductVariant?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ProductVariant>(
      value: selected ?? variants.first,
      items: variants
          .map(
            (variant) => DropdownMenuItem(
              value: variant,
              child:
                  Text("${variant.name} - ${variant.price.toStringAsFixed(0)}"),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(hintText: "Select variant"),
    );
  }
}
