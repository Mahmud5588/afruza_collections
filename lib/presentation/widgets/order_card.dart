import "package:flutter/material.dart";
import "package:intl/intl.dart";

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.title,
    required this.status,
    required this.date,
    required this.total,
  });

  final String title;
  final String status;
  final DateTime date;
  final double total;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: "UZS ", decimalDigits: 0);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Chip(
                  label: Text(
                    status,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(DateFormat("MMM dd, yyyy").format(date)),
          const SizedBox(height: 8),
          Text(formatter.format(total), style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
