import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/components/monthly_summary.dart';
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
    overallExpenseList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
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

  bool isSavings(String type) {
    List<String> savingTypes = ['SALARY', 'DEPOSITS', 'OTHER INCOME'];
    return savingTypes.contains(type);
  }

  // convert to expense summary
  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};
    for (var expense in overallExpenseList) {
      String type = expense.type;
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);
      String amountPrecision = amount.toStringAsFixed(2);
      double finalAmount = double.parse(amountPrecision);
      if (!isSavings(type)) {
        // if date already exists
        if (dailyExpenseSummary.containsKey(date)) {
          // get expense
          double currentAmount = dailyExpenseSummary[date]!;
          currentAmount += finalAmount;
          dailyExpenseSummary[date] = currentAmount;
          // does not exist
        } else {
          dailyExpenseSummary.addAll({date: finalAmount});
        }
      }
    }
    return dailyExpenseSummary;
  }

  // convert to savings summary
  Map<String, double> calculateDailySavingsSummary() {
    Map<String, double> dailySavingsSummary = {};
    for (var expense in overallExpenseList) {
      String type = expense.type;
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);
      String amountPrecision = amount.toStringAsFixed(2);
      double finalAmount = double.parse(amountPrecision);
      if (isSavings(type)) {
        // if date already exists
        if (dailySavingsSummary.containsKey(date)) {
          // get expense
          double currentAmount = dailySavingsSummary[date]!;
          currentAmount += finalAmount;
          dailySavingsSummary[date] = currentAmount;
          // does not exist
        } else {
          dailySavingsSummary.addAll({date: finalAmount});
        }
      }
    }
    return dailySavingsSummary;
  }

  // convert to history summary
  // ['JULY 2023', '\$2000']
  Map<String, double> calculateHistoryExpenseSummary() {
    Map<String, double> monthlyExpenseSummary = {};
    for (var expense in overallExpenseList) {
      String monthYear = DateFormat('MMMM yyyy').format(expense.dateTime);
      double amount = double.parse(expense.amount);
      String amountPrecision = amount.toStringAsFixed(2);
      double finalAmount = double.parse(amountPrecision);
      if (!isSavings(expense.type)) {
        // if date already exists
        if (monthlyExpenseSummary.containsKey(monthYear)) {
          // get expense
          double currentAmount = monthlyExpenseSummary[monthYear]!;
          currentAmount += finalAmount;
          monthlyExpenseSummary[monthYear] = currentAmount;
          // does not exist
        } else {
          monthlyExpenseSummary.addAll({monthYear: finalAmount});
        }
      }
    }
    return monthlyExpenseSummary;
  }

  List<MonthlySummary> calculateHistoryExpenseSummaryByYear(int year) {
    List<MonthlySummary> monthlyExpenseSummaryByYear = [];
    // initialise all to 0
    for (int i = 0; i < 12; i++) {
      monthlyExpenseSummaryByYear.add(MonthlySummary(i, 0));
    }
    // add the rest
    for (var expense in overallExpenseList) {
      if (year == expense.dateTime.year && !isSavings(expense.type)) {
        int month = expense.dateTime.month - 1;
        double amount = double.parse(expense.amount);
        String amountPrecision = amount.toStringAsFixed(2);
        double newAmount = double.parse(amountPrecision);
        bool foundMonthYear = false;
        for (var summary in monthlyExpenseSummaryByYear) {
          // can find
          if (summary.month == month) {
            summary.amount += newAmount;
            foundMonthYear = true;
            break;
          }
        }
        // cannot find
        if (!foundMonthYear) {
          monthlyExpenseSummaryByYear.add(MonthlySummary(month, newAmount));
        }
      }
    }
    return monthlyExpenseSummaryByYear;
  }
}
