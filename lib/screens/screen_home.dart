import 'package:economiza/screens/add_eddit_expens_screen.dart';
import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/expense.dart';
import '../widgets/expense_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  void _loadExpenses() async {
    final expenses = await DatabaseHelper.instance.getExpenses();
    setState(() => _expenses = expenses);
  }

  double get totalAmount => _expenses.fold(0, (sum, item) => sum + item.amount);

  void _deleteExpense(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Gasto'),
        content: const Text('¿Estás seguro que deseas eliminar este gasto?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar')),
        ],
      ),
    );

    if (confirm ?? false) {
      await DatabaseHelper.instance.deleteExpense(id);
      _loadExpenses();
    }
  }

  void _navigateToAddEdit({Expense? expense}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditExpenseScreen(expense: expense),
      ),
    );
    if (result == true) {
      _loadExpenses();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Economiza',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              surfaceTintColor: Colors.transparent,
              color: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.account_balance_wallet_rounded,
                            size: 30, color: colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(
                          'Total Gastado',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '\$${totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _expenses.isEmpty
                  ? const Center(child: Text('No hay gastos registrados.'))
                  : ListView.separated(
                      itemCount: _expenses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final expense = _expenses[index];
                        return ExpenseCard(
                          expense: expense,
                          onEdit: () => _navigateToAddEdit(expense: expense),
                          onDelete: () => _deleteExpense(expense.id!),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddEdit(),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
    );
  }
}
