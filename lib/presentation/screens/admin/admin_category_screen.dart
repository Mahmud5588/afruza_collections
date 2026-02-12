import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../core/di.dart";
import "../../../core/ui_constants.dart";
import "../../blocs/auth/admin/admin_category_bloc.dart";
import "../../widgets/empty_state.dart";
import "../../widgets/skeleton_box.dart";

class AdminCategoryScreen extends StatefulWidget {
  const AdminCategoryScreen({super.key});

  @override
  State<AdminCategoryScreen> createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends State<AdminCategoryScreen> {
  late final AdminCategoryBloc _bloc;
  final _nameController = TextEditingController();
  final _scrollController = ScrollController();

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
                            context.read<AdminCategoryBloc>().add(const LoadAdminCategories()),
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
                                title: Text(category.name),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined),
                                      onPressed: () => _showEditDialog(context, category.id, category.name),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () => context
                                          .read<AdminCategoryBloc>()
                                          .add(DeleteAdminCategory(categoryId: category.id)),
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
                              child: Center(child: CircularProgressIndicator()),
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
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Category name required")),
      );
      return;
    }
    context.read<AdminCategoryBloc>().add(CreateAdminCategory(name: name));
    _nameController.clear();
  }

  Future<void> _showEditDialog(
    BuildContext context,
    int categoryId,
    String name,
  ) async {
    final controller = TextEditingController(text: name);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update category"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Category name"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text("Save"),
          ),
        ],
      ),
    );
    if (result == null || result.isEmpty) return;
    if (!context.mounted) return;
    context.read<AdminCategoryBloc>().add(
          UpdateAdminCategory(categoryId: categoryId, name: result),
        );
  }
}
