import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../db/database_helper.dart';

class AddEditExpenseScreen extends StatefulWidget {
  final Expense? expense;
  const AddEditExpenseScreen({super.key, this.expense});

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  String _category = '';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _descController.text = widget.expense!.description;
      _amountController.text = widget.expense!.amount.toString();
      _category = widget.expense!.category;
      _selectedDate = DateTime.parse(widget.expense!.date);
    }
  }

  void _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      final expense = Expense(
        id: widget.expense?.id,
        description: _descController.text,
        category: _category,
        amount: double.parse(_amountController.text),
        date: _selectedDate.toIso8601String(),
      );

      if (widget.expense == null) {
        await DatabaseHelper.instance.addExpense(expense);
      } else {
        await DatabaseHelper.instance.updateExpense(expense);
      }
      Navigator.pop(context, true);
    }
  }

  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense == null ? 'Agregar Gasto' : 'Editar Gasto'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.text_snippet),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Campo obligatorio'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Monto',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || double.tryParse(value) == null
                    ? 'Ingrese un número válido'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category.isNotEmpty ? _category : null,
                items: ['Comida', 'Transporte', 'Servicios', 'Otro']
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _category = val ?? ''),
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  prefixIcon: Icon(Icons.category),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Seleccione una categoría' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                tileColor: colorScheme.surfaceContainerHighest,
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  'Fecha: ${_selectedDate.toLocal().toString().split(" ")[0]}',
                  style: const TextStyle(fontSize: 16),
                ),
                onTap: _pickDate,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _saveExpense,
                label: Text(widget.expense == null ? 'Guardar' : 'Actualizar'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: colorScheme.primary,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
