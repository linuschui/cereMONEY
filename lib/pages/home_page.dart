import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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
                    decoration: const InputDecoration(
                      hintText: "Expense Name",
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[a-zA-Z0-9 ]+$'))
                    ],
                  ),
                  Row(children: [
                    Expanded(
                      child: TextField(
                        controller: newExpenseDollarsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: "Dollars"),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(5)
                        ],
                      ),
                    ),
                    Expanded(
                        child: TextField(
                      controller: newExpenseCentsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: "Cents"),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2)
                      ],
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
    if (newExpenseNameController.text.isNotEmpty &&
        newExpenseDollarsController.text.isNotEmpty &&
        newExpenseCentsController.text.isNotEmpty) {
      String amount =
          '${newExpenseDollarsController.text}.${newExpenseCentsController.text}';
      double amountPrecision = double.parse(amount);
      String finalAmount = amountPrecision.toStringAsFixed(2);
      ExpenseItem newExpense = ExpenseItem(
          name: newExpenseNameController.text,
          amount: finalAmount,
          dateTime: DateTime.now());
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
      Navigator.pop(context);
      clear();
    }
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

  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          toolbarHeight: 30,
          title: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('cereMONEY'),
              IconButton(
                icon: Icon(Icons.monetization_on), // Add your desired icon here
                onPressed: () {
                  // Add the onPressed action here, e.g., open a drawer
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        body: Column(
          // Wrap the ExpenseSummary and ListView.builder in a Column
          children: [
            // expense summary
            ExpenseSummary(startOfWeek: value.startOfWeekDate()),
            // expense list
            const SizedBox(height: 20),
            Expanded(
              // Use Expanded to make the ListView.builder scrollable independently
              child: ListView.builder(
                shrinkWrap: true,
                physics:
                    const AlwaysScrollableScrollPhysics(), // Use AlwaysScrollableScrollPhysics for the ListView.builder
                itemCount: value.getAllExpenseList().length,
                itemBuilder: (context, index) => ExpenseTile(
                  name: value.getAllExpenseList()[index].name,
                  amount: value.getAllExpenseList()[index].amount,
                  dateTime: value.getAllExpenseList()[index].dateTime,
                  deleteTapped: (p0) =>
                      deleteExpense(value.getAllExpenseList()[index]),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.black,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: GNav(
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
              gap: 8,
              padding: const EdgeInsets.all(16),
              tabs: [
                const GButton(icon: Icons.home, text: ' Home'),
                const GButton(icon: Icons.history_outlined, text: ' History'),
                GButton(
                  icon: Icons.add,
                  text: ' Expense',
                  onPressed: addNewExpense,
                ),
                const GButton(icon: Icons.settings, text: ' Settings')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
