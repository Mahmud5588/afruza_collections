import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../core/di.dart";
import "../../../core/ui_constants.dart";
import "../../blocs/auth/admin/admin_category_bloc.dart";
import "../../widgets/empty_state.dart";
import "../../widgets/skeleton_box.dart";
import "../../widgets/category_icon.dart";

class AdminCategoryScreen extends StatefulWidget {
  const AdminCategoryScreen({super.key});

  @override
  State<AdminCategoryScreen> createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends State<AdminCategoryScreen> {
  late final AdminCategoryBloc _bloc;
  final _nameController = TextEditingController();
  final _iconUrlController = TextEditingController();
  final _scrollController = ScrollController();
  String? _selectedIconEmoji;

  // Default kiyim iconlari
  static const Map<String, String> _clothingIcons = {
    '👕': 'T-shirt / Ko\'ylak',
    '👗': 'Ko\'ylak / Libos',
    '👔': 'Galstuk / Rasmiy',
    '👚': 'Ayollar ko\'ylagi',
    '👖': 'Shim / Jinsi',
    '🧥': 'Kurtka / Palto',
    '👘': 'Kimono / Milliy',
    '🥻': 'Sari / Milliy libos',
    '🩱': 'Suzish kiyimi',
    '👙': 'Bikini',
    '🩲': 'Ichki kiyim',
    '🩳': 'Shorts',
    '👟': 'Poyabzal / Krossovka',
    '👞': "Tuflya",
    '👠': 'Poshnali poyabzal',
    '🥾': 'Bot / Etik',
    '👢': 'Ayollar botinkasi',
    '🧦': 'Paypoq',
    '🧤': 'Qo\'lqop',
    '🧣': 'Sharf',
    '🎩': 'Shapka / Qalpoq',
    '👒': 'Ayollar shlyapasi',
    '🎓': 'Akademik shapka',
    '👑': 'Toj / Premium',
    '💍': 'Uzuk / Aksessuarlar',
    '👜': 'Sumka',
    '🎒': 'Ryukzak',
    '🕶️': 'Ko\'zoynak',
    '⌚': 'Soat',
    '💄': 'Kosmetika',
  };

  @override
  void initState() {
    super.initState();
    _bloc = sl<AdminCategoryBloc>();
    _bloc.add(const LoadAdminCategories());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _iconUrlController.dispose();
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= maxScroll - 200) {
      _bloc.add(const LoadMoreAdminCategories());
    }
  }

  Future<void> _refresh() async {
    _bloc.add(const LoadAdminCategories());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<AdminCategoryBloc, AdminCategoryState>(
        listener: (context, state) {
          if (state.status == AdminCategoryStatus.failure &&
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
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new),
                        ),
                        Text("Manage categories",
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildCreateForm(context),
                    const SizedBox(height: AppSpacing.lg),
                    BlocBuilder<AdminCategoryBloc, AdminCategoryState>(
                      builder: (context, state) {
                        if (state.status == AdminCategoryStatus.loading) {
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
                        if (state.status == AdminCategoryStatus.failure) {
                          return EmptyState(
                            title: "Failed to load",
                            subtitle: state.message ?? "Please try again.",
                            onAction: () =>
                                _bloc.add(const LoadAdminCategories()),
                            actionLabel: "Retry",
                          );
                        }
                        if (state.categories.isEmpty) {
                          return const EmptyState(
                            title: "No categories",
                            subtitle: "Add your first category above.",
                          );
                        }

                        return Column(
                          children: [
                            ...state.categories
                                .map(
                                  (category) => ListTile(
                                    leading: CategoryIconWidget(
                                      icon: category.icon,
                                      size: 32,
                                      fallbackName: category.name,
                                    ),
                                    title: Text(category.name),
                                    subtitle: category.icon != null
                                        ? Text(category.icon!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis)
                                        : null,
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined),
                                          onPressed: () => _showEditDialog(
                                              context,
                                              category.id,
                                              category.name),
                                        ),
                                        IconButton(
                                          icon:
                                              const Icon(Icons.delete_outline),
                                          onPressed: () =>
                                              _showDeleteConfirmation(
                                                  context, category),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                            BlocBuilder<AdminCategoryBloc, AdminCategoryState>(
                              builder: (context, state) {
                                if (!state.isLoadingMore) {
                                  return const SizedBox.shrink();
                                }
                                return const Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
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
          Text("Add category", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: "Category name"),
          ),
          const SizedBox(height: 12),

          // Icon tanlash qismi
          Row(
            children: [
              Text(
                "Icon tanlang:",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: 8),
              if (_selectedIconEmoji != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _selectedIconEmoji!,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: _showIconPicker,
                icon: const Icon(Icons.category_outlined),
                label: const Text("Icon tanlash"),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _iconUrlController,
            decoration: const InputDecoration(
              hintText: "yoki Icon URL (ixtiyoriy)",
              helperText: "Icon tanlamasangiz URL kiritishingiz mumkin",
              helperMaxLines: 2,
            ),
            maxLines: 2,
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

  Future<void> _showIconPicker() async {
    final selectedEmoji = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Icon tanlang"),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: _clothingIcons.length,
            itemBuilder: (context, index) {
              final emoji = _clothingIcons.keys.elementAt(index);
              final label = _clothingIcons[emoji]!;
              return InkWell(
                onTap: () => Navigator.pop(context, emoji),
                borderRadius: BorderRadius.circular(8),
                child: Tooltip(
                  message: label,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Bekor qilish"),
          ),
        ],
      ),
    );

    if (selectedEmoji != null && mounted) {
      setState(() {
        _selectedIconEmoji = selectedEmoji;
        // Emoji'ni URL o'rniga qo'yamiz (backend string kutadi)
        _iconUrlController.text = selectedEmoji;
      });
    }
  }

  void _submit(BuildContext context) {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Category name required")),
      );
      return;
    }

    // Icon tanlangan bo'lsa yoki URL kiritilgan bo'lsa ishlatamiz
    final iconUrl = _iconUrlController.text.trim();

    _bloc.add(CreateAdminCategory(
      name: name,
      iconUrl: iconUrl.isEmpty ? null : iconUrl,
    ));

    _nameController.clear();
    _iconUrlController.clear();
    setState(() {
      _selectedIconEmoji = null;
    });
  }

  Future<void> _showEditDialog(
    BuildContext context,
    int categoryId,
    String name,
  ) async {
    final controller = TextEditingController(text: name);
    final iconController = TextEditingController();
    final result = await showDialog<Map<String, String?>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update category"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "Category name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: iconController,
              decoration:
                  const InputDecoration(hintText: "Icon URL (optional)"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          FilledButton(
            onPressed: () => Navigator.pop(context, {
              'name': controller.text.trim(),
              'iconUrl': iconController.text.trim(),
            }),
            child: const Text("Save"),
          ),
        ],
      ),
    );
    if (result == null || result['name'] == null || result['name']!.isEmpty)
      return;
    if (!context.mounted) return;
    _bloc.add(
      UpdateAdminCategory(
        categoryId: categoryId,
        name: result['name']!,
        iconUrl: result['iconUrl']!.isEmpty ? null : result['iconUrl'],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, dynamic category) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Kategoriyani o'chirish"),
        content: Text(
          "'${category.name}' kategoriyasini o'chirmoqchimisiz?\n\n"
          "Diqqat: Agar bu kategoriyada mahsulotlar bo'lsa, "
          "ular \"Uncategorized\" kategoriyasiga o'tadi.",
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
      _bloc.add(DeleteAdminCategory(categoryId: category.id));
    }
  }
}
