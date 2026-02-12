import "package:flutter/material.dart";

import "../../core/di.dart";
import "../../data/local/favorites_service.dart";
import "../../domain/entities/product.dart";

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.product, this.size = 22});

  final Product product;
  final double size;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final service = sl<FavoritesService>();
    final value = await service.isFavorite(widget.product.id);
    if (!mounted) return;
    setState(() => _isFavorite = value);
  }

  Future<void> _toggle() async {
    final service = sl<FavoritesService>();
    await service.toggleFavorite(widget.product);
    if (!mounted) return;
    setState(() => _isFavorite = !_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _toggle,
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        size: widget.size,
      ),
    );
  }
}
