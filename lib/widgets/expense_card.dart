import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.label_important, color: colorScheme.primary, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.description,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${expense.category} — ${expense.date.split("T")[0]}',
                    style: TextStyle(color: Colors.grey[700], fontSize: 11),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${expense.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: Icon(Icons.edit, color: colorScheme.secondary),
                      tooltip: 'Editar',
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete, color: colorScheme.error),
                      tooltip: 'Eliminar',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
