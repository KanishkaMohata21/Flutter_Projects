import 'package:expense_tracker/chart.dart';
import 'package:expense_tracker/expenseList.dart';
import 'package:expense_tracker/form.dart';
import 'package:expense_tracker/model.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 500,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Grocery',
      amount: 5000,
      date: DateTime.now(),
      category: Category.food,
    ),
  ];

  void _openForm() {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (ctx) {
        return ExpenseForm(onSave: _addExpense);
      },
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final int index = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(index, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final Widget mainContent = _registeredExpenses.isEmpty
        ? const Center(child: Text("No expense found"))
        : ExpenseList(
            expenses: _registeredExpenses,
            onRemoveExpense: _removeExpense,
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openForm,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body:width < 600 ? Column(
        children: [
          const SizedBox(height: 16.0),
          Chart(expenses: _registeredExpenses),
          const SizedBox(height: 16.0),
          Expanded(child: mainContent),
        ],
      ):Row(
        children: [
          const SizedBox(height: 16.0),
          Expanded(child: Chart(expenses: _registeredExpenses)) ,
          const SizedBox(height: 16.0),
          Expanded(child: mainContent),
        ],
      )
    );
  }
}
