import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../core/di.dart";
import "../../../core/ui_constants.dart";
import "../../../domain/entities/category.dart";
import "../../../domain/entities/product.dart";
import "../../blocs/auth/admin/admin_product_bloc.dart";
import "../../blocs/category/category_bloc.dart";
import "../../widgets/empty_state.dart";
import "../../widgets/skeleton_box.dart";
import "../../widgets/image_picker_field.dart";

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({super.key});

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  late final AdminProductBloc _productBloc;
  late final CategoryBloc _categoryBloc;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _ratingController = TextEditingController(text: "0");
  final _variantsController = TextEditingController();
  final List<String> _selectedImages = [];
  Category? _selectedCategory;
  int _formResetKey = 0; // Key to force ImagePickerField reset

  @override
  void initState() {
    super.initState();
    _productBloc = sl<AdminProductBloc>();
    _categoryBloc = sl<CategoryBloc>();
    _productBloc.add(const LoadAdminProducts());
    _categoryBloc.add(const LoadCategories());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _ratingController.dispose();
    _variantsController.dispose();
    _productBloc.close();
    _categoryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _productBloc),
        BlocProvider.value(value: _categoryBloc),
      ],
      child: BlocListener<AdminProductBloc, AdminProductState>(
        listener: (context, state) {
          if (state.status == AdminProductStatus.failure &&
              state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(gradient: AppGradients.hero),
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),
                      Text("Manage products",
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildCreateForm(context),
                  const SizedBox(height: AppSpacing.lg),
                  BlocBuilder<AdminProductBloc, AdminProductState>(
                    builder: (context, state) {
                      if (state.status == AdminProductStatus.loading) {
                        return Column(
                          children: const [
                            SkeletonBox(height: 20),
                            SizedBox(height: 12),
                            SkeletonBox(height: 20),
                            SizedBox(height: 12),
                            SkeletonBox(height: 20),
                          ],
                        );
                      }
                      if (state.status == AdminProductStatus.failure) {
                        return EmptyState(
                          title: "Failed to load",
                          subtitle: state.message ?? "Please try again.",
                          onAction: () =>
                              _productBloc.add(const LoadAdminProducts()),
                          actionLabel: "Retry",
                        );
                      }
                      if (state.products.isEmpty) {
                        return const EmptyState(
                          title: "No products",
                          subtitle: "Add your first product above.",
                        );
                      }

                      return Column(
                        children: state.products
                            .map(
                              (product) => ListTile(
                                title: Text(product.name),
                                subtitle: Text(product.categoryName),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined),
                                      onPressed: () =>
                                          _showEditSheet(context, product),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () => _showDeleteConfirmation(
                                          context, product),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
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

  Widget _buildCreateForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Add product", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: "Product name"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(hintText: "Description"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Price"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ratingController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Rating (0-5)"),
          ),
          const SizedBox(height: 12),
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              final items = state.categories;
              return DropdownButtonFormField<Category>(
                value: _selectedCategory,
                items: items
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                decoration: const InputDecoration(hintText: "Category"),
              );
            },
          ),
          const SizedBox(height: 12),
          ImagePickerField(
            key: ValueKey(_formResetKey),
            initialImages: const [],
            onImagesSelected: (images) {
              _selectedImages.clear();
              _selectedImages.addAll(images);
            },
            maxImages: 5,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _variantsController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Variantlar (ixtiyoriy)",
              hintText:
                  "Kichik:50000, O'rta:75000, Katta:100000\nQizil:85000, Ko'k:85000\nM:60000, L:70000, XL:80000",
              helperText: "Format: nom:narx, vergul bilan ajratilgan",
              helperMaxLines: 2,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: () => _submit(context),
              child: const Text("Create"),
            ),
          ),
        ],
      ),
    );
  }

  void _submit(BuildContext context) {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    final rating = double.tryParse(_ratingController.text.trim()) ?? 0;
    final category = _selectedCategory;

    if (name.isEmpty ||
        description.isEmpty ||
        price == null ||
        category == null ||
        _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Fill all required fields including images")),
      );
      return;
    }

    final variants = _parseVariants(_variantsController.text);

    _productBloc.add(
      CreateAdminProduct(
        name: name,
        description: description,
        price: price,
        rating: rating,
        categoryId: category.id,
        images: _selectedImages,
        variants: variants,
      ),
    );

    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _ratingController.text = "0";
    _variantsController.clear();
    _selectedImages.clear();
    _selectedCategory = null;
    _formResetKey++; // Increment to force ImagePickerField reset
    setState(() {});
  }

  Future<void> _showEditSheet(BuildContext context, Product product) async {
    final nameController = TextEditingController(text: product.name);
    final descriptionController =
        TextEditingController(text: product.description);
    final priceController =
        TextEditingController(text: product.price.toString());
    final ratingController =
        TextEditingController(text: product.rating.toString());
    final variantsController =
        TextEditingController(text: _formatVariants(product.variants));
    final List<String> editImages = List.from(product.imageUrls);

    // Categorylarni oldindan olamiz (BlocBuilder dialog ichida ishlamaydi)
    final categories = _categoryBloc.state.categories;
    Category? selectedCategory;

    if (categories.isNotEmpty) {
      selectedCategory = categories.firstWhere(
        (category) => category.name == product.categoryName,
        orElse: () => categories.first,
      );
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return ListView(
                shrinkWrap: true,
                children: [
                  Text("Edit product",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: "Product name"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(hintText: "Description"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "Price"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: ratingController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "Rating (0-5)"),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Category>(
                    value: selectedCategory,
                    items: categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setModalState(() => selectedCategory = value),
                    decoration: const InputDecoration(hintText: "Category"),
                  ),
                  const SizedBox(height: 12),
                  ImagePickerField(
                    initialImages: editImages,
                    onImagesSelected: (images) {
                      setModalState(() {
                        editImages.clear();
                        editImages.addAll(images);
                      });
                    },
                    maxImages: 5,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: variantsController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Variantlar (ixtiyoriy)",
                      hintText:
                          "Kichik:50000, O'rta:75000, Katta:100000\nQizil:85000, Ko'k:85000",
                      helperText: "Format: nom:narx, vergul bilan ajratilgan",
                      helperMaxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () => _submitEdit(
                          context,
                          product.id,
                          nameController.text.trim(),
                          descriptionController.text.trim(),
                          priceController.text.trim(),
                          ratingController.text.trim(),
                          selectedCategory,
                          editImages,
                          variantsController.text,
                        ),
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _submitEdit(
    BuildContext context,
    int productId,
    String name,
    String description,
    String priceText,
    String ratingText,
    Category? category,
    List<String> images,
    String variantsText,
  ) {
    final price = double.tryParse(priceText);
    final rating = double.tryParse(ratingText) ?? 0;
    if (name.isEmpty ||
        description.isEmpty ||
        price == null ||
        category == null ||
        images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Fill all required fields including images")),
      );
      return;
    }

    final variants = _parseVariants(variantsText);

    _productBloc.add(
      UpdateAdminProduct(
        productId: productId,
        name: name,
        description: description,
        price: price,
        rating: rating,
        categoryId: category.id,
        images: images,
        variants: variants,
      ),
    );

    Navigator.pop(context);
  }

  List<Map<String, dynamic>> _parseVariants(String raw) {
    final entries = raw.split(",");
    final variants = <Map<String, dynamic>>[];
    for (final entry in entries) {
      final trimmed = entry.trim();
      if (trimmed.isEmpty) continue;
      final parts =
          trimmed.contains(":") ? trimmed.split(":") : trimmed.split("=");
      if (parts.length < 2) continue;
      final name = parts[0].trim();
      final price = double.tryParse(parts[1].trim());
      if (name.isEmpty || price == null) continue;
      variants.add({"name": name, "price": price});
    }
    return variants;
  }

  String _formatVariants(List<ProductVariant> variants) {
    if (variants.isEmpty) return "";
    return variants
        .map((variant) => "${variant.name}:${variant.price}")
        .join(", ");
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, Product product) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Mahsulotni o'chirish"),
        content: Text(
          "'${product.name}' mahsulotini o'chirmoqchimisiz?\n\n"
          "Diqqat: Agar bu mahsulot buyurtmalarda ishlatilgan bo'lsa, "
          "o'chirish mumkin bo'lmasligi mumkin.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Bekor qilish"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("O'chirish"),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      _productBloc.add(DeleteAdminProduct(productId: product.id));
    }
  }
}
