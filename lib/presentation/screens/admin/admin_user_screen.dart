import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../core/di.dart";
import "../../../core/ui_constants.dart";
import "../../blocs/auth/admin/admin_user_bloc.dart";
import "../../widgets/empty_state.dart";
import "../../widgets/skeleton_box.dart";

class AdminUserScreen extends StatefulWidget {
  const AdminUserScreen({super.key});

  @override
  State<AdminUserScreen> createState() => _AdminUserScreenState();
}

class _AdminUserScreenState extends State<AdminUserScreen> {
  late final AdminUserBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<AdminUserBloc>();
    _bloc.add(const LoadAdminUsers());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
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
                    Text("User management",
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                BlocBuilder<AdminUserBloc, AdminUserState>(
                  builder: (context, state) {
                    if (state.status == AdminUserStatus.loading) {
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
                    if (state.status == AdminUserStatus.failure) {
                      return EmptyState(
                        title: "Failed to load",
                        subtitle: state.message ?? "Please try again.",
                        onAction: () => context
                            .read<AdminUserBloc>()
                            .add(const LoadAdminUsers()),
                        actionLabel: "Retry",
                      );
                    }
                    if (state.users.isEmpty) {
                      return const EmptyState(
                        title: "No users",
                        subtitle: "No registered users found.",
                      );
                    }

                    return Column(
                      children: state.users
                          .map(
                            (user) => Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.email,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SwitchListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: const Text("Admin"),
                                            value: user.isAdmin,
                                            onChanged: (value) => context
                                                .read<AdminUserBloc>()
                                                .add(ToggleAdminRole(
                                                    userId: user.id,
                                                    isAdmin: value)),
                                          ),
                                        ),
                                        Expanded(
                                          child: SwitchListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: const Text("Active"),
                                            value: user.isActive,
                                            onChanged: (value) => context
                                                .read<AdminUserBloc>()
                                                .add(ToggleUserActive(
                                                    userId: user.id,
                                                    isActive: value)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton.icon(
                                        onPressed: () => context
                                            .read<AdminUserBloc>()
                                            .add(DeleteAdminUser(
                                                userId: user.id)),
                                        icon: const Icon(Icons.delete_outline),
                                        label: const Text("Delete"),
                                      ),
                                    ),
                                  ],
                                ),
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
    );
  }
}
