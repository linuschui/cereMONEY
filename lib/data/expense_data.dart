import 'package:flutter/material.dart';
import 'package:money_manager/data/hive_database.dart';
import 'package:money_manager/datetime/datetime_helper.dart';
import 'package:money_manager/models/expense_item.dart';

class ExpenseData extends ChangeNotifier {
  // list of all expenses
  List<ExpenseItem> overallExpenseList = [];

  // get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  // prepare data
  final db = HiveDataBase();
  void prepareData() {
    // exists data
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  // add new expense
  void addNewExpense(ExpenseItem newExpenseItem) {
    overallExpenseList.add(newExpenseItem);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // get weekday
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  // get date for start of the week (Sunday)
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;
    DateTime today = DateTime.now().toLocal();
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sunday') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }

  // convert to expense summary
  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};
    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);
      // if date already exists
      if (dailyExpenseSummary.containsKey(date)) {
        // get expense
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
        // does not exist
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }
    return dailyExpenseSummary;
  }

  // get max of the week
  double getMaximumExpenditure(DateTime startOfWeek) {
    double currMax = 0;
    for (int i = 0; i < 7; i++) {
      String currDate =
          convertDateTimeToString(startOfWeek.add(Duration(days: i)));
      double currDateExpense = calculateDailyExpenseSummary()[currDate] ?? 0;
      if (currDateExpense > currMax) {
        currMax = currDateExpense;
      }
    }
    return currMax;
  }
}
