import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";

import "../../../core/di.dart";
import "../../../core/localization/app_localizations.dart";
import "../../../core/ui_constants.dart";
import "../../../data/local/storage_service.dart";
import "../../blocs/order/order_bloc.dart";
import "../../widgets/empty_state.dart";
import "../../widgets/order_card.dart";

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late final OrderBloc _orderBloc;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _orderBloc = sl<OrderBloc>();
    _orderBloc.add(const LoadOrders());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _orderBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= maxScroll - 200) {
      _orderBloc.add(const LoadMoreOrders());
    }
  }

  Future<void> _refresh() async {
    _orderBloc.add(const LoadOrders());
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return "Kutilmoqda";
      case "processing":
        return "Jarayonda";
      case "shipped":
        return "Yo'lda";
      case "delivered":
        return "Yetkazildi";
      case "completed":
        return "Bajarildi";
      case "cancelled":
        return "Bekor qilindi";
      default:
        return status;
    }
  }

  void _showOrderDetails(BuildContext context, dynamic order) {
    final formatter = NumberFormat.currency(symbol: "UZS ", decimalDigits: 0);
    final canCancel = order.status.toLowerCase() == "pending" ||
        order.status.toLowerCase() == "processing";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Buyurtma #${order.id}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _DetailRow(
                label: "Holat",
                value: _getStatusText(order.status),
              ),
              _DetailRow(
                label: "Sana",
                value: DateFormat("dd MMM yyyy, HH:mm").format(order.createdAt),
              ),
              _DetailRow(
                label: "Summa",
                value: formatter.format(order.total),
              ),
              const SizedBox(height: 16),
              Text(
                "Mahsulotlar",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${item.productName} x${item.quantity}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(formatter.format(item.unitPrice * item.quantity)),
                      ],
                    ),
                  )),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Yopish"),
                    ),
                  ),
                  if (canCancel) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showCancelWarning(context);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Bekor qilish"),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showCancelWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Buyurtmani bekor qilish"),
        content: const Text(
          "Agar buyurtmani bekor qilmoqchi bo'lsangiz, "
          "iltimos Admin bilan bog'lanib, chat orqali bekor qilishni so'rang.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tushunarli"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/chat");
            },
            child: const Text("Chat ga o'tish"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return BlocProvider.value(
      value: _orderBloc,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppGradients.hero),
          child: SafeArea(
            child: FutureBuilder<bool>(
              future:
                  sl<StorageService>().isTokenValid(const Duration(days: 30)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final isLoggedIn = snapshot.data ?? false;
                if (!isLoggedIn) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            t("login_required"),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            t("sign_in_to_view_orders"),
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          FilledButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, "/login"),
                            child: Text(t("sign_in")),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
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
                          Text(
                            t("order_history"),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      BlocBuilder<OrderBloc, OrderState>(
                        builder: (context, state) {
                          if (state.status == OrderStatus.loading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (state.status == OrderStatus.failure) {
                            return EmptyState(
                              title: t("failed_to_load"),
                              subtitle: state.message ?? t("please_try_again"),
                              onAction: () => context
                                  .read<OrderBloc>()
                                  .add(const LoadOrders()),
                              actionLabel: t("retry"),
                            );
                          }
                          if (state.orders.isEmpty) {
                            return EmptyState(
                              title: t("no_orders"),
                              subtitle: t("no_orders_subtitle"),
                            );
                          }

                          return Column(
                            children: state.orders
                                .map(
                                  (order) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: GestureDetector(
                                      onTap: () =>
                                          _showOrderDetails(context, order),
                                      child: OrderCard(
                                        title: "Order #${order.id}",
                                        status: _getStatusText(order.status),
                                        date: order.createdAt,
                                        total: order.total,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                      BlocBuilder<OrderBloc, OrderState>(
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
