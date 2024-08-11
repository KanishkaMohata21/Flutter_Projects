import 'package:flutter/material.dart';
import 'package:expense_tracker/model.dart';

class ExpenseForm extends StatefulWidget {
  final void Function(Expense expense) onSave; // Callback to handle saving

  const ExpenseForm({super.key, required this.onSave});

  @override
  State<ExpenseForm> createState() {
    return _ExpenseFormState();
  }
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitForm() {
    final enteredTitle = _titleController.text;
    final enteredAmount = int.tryParse(_amountController.text) ?? 0;
    
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return; // Handle validation or show an error
    }

    final newExpense = Expense(
      title: enteredTitle,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
    );

    widget.onSave(newExpense);
    Navigator.pop(context); // Close the form
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardspace = MediaQuery.of(context).viewInsets.bottom;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16,48,16,keyboardspace+16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              maxLength: 50,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixText: '\$ ',
                      labelText: 'Amount',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.toLocal()}'.split(' ')[0]
                            : 'No Date Chosen',
                      ),
                      IconButton(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<Category>(
                    value: _selectedCategory,
                    items: Category.values.map((Category category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Row(
                          children: [
                            Icon(categoryIcons[category]),
                            const SizedBox(width: 8),
                            Text(category.toString().split('.').last),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (Category? newCategory) {
                      setState(() {
                        _selectedCategory = newCategory!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
