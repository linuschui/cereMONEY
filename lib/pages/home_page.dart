import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:money_manager/components/expense_summary.dart';
import 'package:money_manager/data/expense_data.dart';
import 'package:money_manager/pages/analytics.dart';
import 'package:money_manager/pages/history.dart';
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
    setState(() {
      _selectedIndex = 0;
    });
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

  int _selectedIndex = 0;

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Do nothing, already on the Home page.
    } else if (index == 1) {
      // Navigate to the HistoryPage with a smooth slide transition
      Navigator.push(
        context,
        pageTransitionBuilder(HistoryPage()),
      );
    } else if (index == 3) {
      // Add new expense : do nothing, already handled by navbar
    } else if (index == 2) {
      // Navigate to the Analytics with a smooth slide transition
      Navigator.push(
        context,
        pageTransitionBuilder(AnalyticsPage()),
      );
    }
  }

  PageRouteBuilder pageTransitionBuilder(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          toolbarHeight: 60,
          title: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('CEREMONEY'),
              IconButton(
                icon: const Icon(
                  Icons.monetization_on,
                ),
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
              // tabBackgroundColor: Colors.grey,
              color: Colors.white,
              activeColor: Colors.white,
              gap: 8,
              padding: const EdgeInsets.all(16),
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: ' Home',
                  backgroundColor: _selectedIndex == 0
                      ? Colors.grey.shade800 // Use grey when selected
                      : Colors.transparent,
                ),
                GButton(
                  icon: Icons.history_sharp,
                  text: ' History',
                  backgroundColor: _selectedIndex == 1
                      ? Colors.grey.shade800 // Use grey when selected
                      : Colors.transparent,
                ),
                GButton(
                  icon: Icons.analytics,
                  text: ' Analytics',
                  backgroundColor: _selectedIndex == 2
                      ? Colors.grey.shade800 // Use grey when selected
                      : Colors.transparent,
                ),
                GButton(
                  icon: Icons.add,
                  text: ' Expense',
                  onPressed: addNewExpense,
                  backgroundColor: _selectedIndex == 3
                      ? Colors.grey.shade800 // Use grey when selected
                      : Colors.transparent,
                )
              ],
              selectedIndex: _selectedIndex,
              onTabChange: _onTabChange,
            ),
          ),
        ),
      ),
    );
  }
}
