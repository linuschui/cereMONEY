import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/components/weekly_summary.dart';
import 'package:money_manager/data/expense_data.dart';
import 'package:money_manager/pages/expense.dart';
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

  void deleteExpense(ExpenseItem expense) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Center(
            child: Text('DELETING',
                style: TextStyle(
                    color: Color.fromARGB(255, 247, 0, 255),
                    fontWeight: FontWeight.bold)),
          ),
          backgroundColor: Colors.black),
    );
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Center(
            child: Text('SUCCESSFULLY DELETED',
                style: TextStyle(
                    color: Color.fromARGB(255, 247, 0, 255),
                    fontWeight: FontWeight.bold)),
          ),
          backgroundColor: Colors.black),
    );
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
        pageTransitionBuilder(const HistoryPage()),
      );
    } else if (index == 2) {
      // Add new expense : do nothing, already handled by navbar
      Navigator.push(
        context,
        pageTransitionBuilder(const AnalyticsPage()),
      );
    } else if (index == 3) {
      // Navigate to the Analytics with a smooth slide transition
      Navigator.push(
        context,
        pageTransitionBuilder(const ExpensePage()),
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
            WeeklySummary(startOfWeek: value.startOfWeekDate()),
            // expense list
            // const SizedBox(height: 20),
            const Padding(
                padding: EdgeInsets.all(15.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('EXPENSES',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 247, 0, 255))),
                ])),
            Expanded(
              // Use Expanded to make the ListView.builder scrollable independently
              child: ListView.builder(
                shrinkWrap: true,
                physics:
                    const AlwaysScrollableScrollPhysics(), // Use AlwaysScrollableScrollPhysics for the ListView.builder
                itemCount: value.getAllExpenseList().length,
                itemBuilder: (context, index) => ExpenseTile(
                  type: value.getAllExpenseList()[index].type,
                  name: value.getAllExpenseList()[index].name,
                  amount: value.getAllExpenseList()[index].amount,
                  dateTime: value.getAllExpenseList()[index].dateTime,
                  deleteTapped: (p0) =>
                      deleteExpense(value.getAllExpenseList()[index]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEEE, d MMMM yyyy')
                        .format(DateTime.now())
                        .toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color.fromARGB(255, 247, 0, 255),
                    ),
                  ),
                ],
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
                  text: ' HOME',
                  backgroundColor:
                      Colors.grey.shade800, // Use grey when selected
                ),
                GButton(
                  icon: Icons.history_sharp,
                  text: ' HISTORY',
                  backgroundColor: _selectedIndex == 1
                      ? Colors.grey.shade800 // Use grey when selected
                      : Colors.transparent,
                ),
                GButton(
                  icon: Icons.analytics,
                  text: ' ANALYTICS',
                  backgroundColor: _selectedIndex == 2
                      ? Colors.grey.shade800 // Use grey when selected
                      : Colors.transparent,
                ),
                GButton(
                  icon: Icons.add,
                  text: ' ADD',
                  // onPressed: addNewExpense,
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
