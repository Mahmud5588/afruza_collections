import "dart:io";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:image_picker/image_picker.dart";

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
  final _iconUrlController = TextEditingController();
  final _scrollController = ScrollController();
  final _imagePicker = ImagePicker();

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
                                    title: Text(category.name),
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
                                          onPressed: () => _bloc.add(
                                              DeleteAdminCategory(
                                                  categoryId: category.id)),
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
          TextField(
            controller: _iconUrlController,
            decoration: const InputDecoration(
              hintText:
                  "Icon URL (optional) - masalan: https://example.com/icon.png",
              helperText:
                  "Backend'da /upload/image endpoint yaratilgandan so'ng rasm yuklash ishlaydi",
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

  void _submit(BuildContext context) {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Category name required")),
      );
      return;
    }
    final iconUrl = _iconUrlController.text.trim();
    _bloc.add(CreateAdminCategory(
      name: name,
      iconUrl: iconUrl.isEmpty ? null : iconUrl,
    ));
    _nameController.clear();
    _iconUrlController.clear();
  }

  Future<void> _pickIcon() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Show loading
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Rasm yuklanmoqda..."),
          duration: Duration(seconds: 30),
        ),
      );

      try {
        // Upload to backend
        final dio = sl<Dio>();
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
            pickedFile.path,
            filename: pickedFile.name,
          ),
        });

        final response = await dio.post('/upload/image', data: formData);

        if (response.statusCode == 200) {
          final imageUrl = response.data['url'] as String;
          setState(() {
            _iconUrlController.text = imageUrl;
          });

          if (!mounted) return;
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Rasm yuklandi: ${pickedFile.name}"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Xatolik: Backend'da /upload/image endpoint yo'q. Qo'lda URL kiriting."),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 5),
          ),
        );
        // Fallback - show local path so user knows what was selected
        setState(() {
          _iconUrlController.text = pickedFile.path;
        });
      }
    }
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
}
