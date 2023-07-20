import 'package:flutter/material.dart';
import 'package:money_manager/components/expense_summary.dart';
import 'package:money_manager/data/expense_data.dart';
import 'package:provider/provider.dart';

import '../components/expense_tile.dart';
import '../models/expense_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseDollarsController = TextEditingController();
  final newExpenseCentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  void addNewExpense() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add new expense'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: newExpenseNameController,
                    decoration: const InputDecoration(hintText: "Expense Name"),
                  ),
                  Row(children: [
                    Expanded(
                      child: TextField(
                        controller: newExpenseDollarsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: "Dollars"),
                      ),
                    ),
                    Expanded(
                        child: TextField(
                      controller: newExpenseCentsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: "Cents"),
                    )),
                  ])
                ],
              ),
              actions: [
                MaterialButton(onPressed: save, child: const Text('Save')),
                MaterialButton(onPressed: cancel, child: const Text('Cancel')),
              ],
            ));
  }

  void save() {
    String amount =
        '${newExpenseDollarsController.text}.${newExpenseCentsController.text}';
    ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now());
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseNameController.clear();
    newExpenseDollarsController.clear();
    newExpenseCentsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          child: const Icon(Icons.add),
        ),
        body: ListView(children: [
          // expense summary
          ExpenseSummary(startOfWeek: value.startOfWeekDate()),
          // expense list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: value.getAllExpenseList().length,
            itemBuilder: (context, index) => ExpenseTile(
              name: value.getAllExpenseList()[index].name,
              amount: value.getAllExpenseList()[index].amount,
              dateTime: value.getAllExpenseList()[index].dateTime,
            ),
          ),
        ]),
      ),
    );
  }
}
