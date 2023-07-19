import 'package:flutter/material.dart';
import 'package:money_manager/bar_graph/bar_graph.dart';
import 'package:money_manager/data/expense_data.dart';
import 'package:money_manager/datetime/datetime_helper.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({super.key, required this.startOfWeek});

  @override
  Widget build(BuildContext context) {
    // get yyyymmdd for each day of the week
    String monday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String tuesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String wednesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String thursday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String friday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String saturday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String sunday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));

    return Consumer<ExpenseData>(
      builder: (context, value, child) => SizedBox(
        height: 200,
        child: MyBarGraph(
          maxY: 100,
          sundayAmount: value.calculateDailyExpenseSummary()[sunday] ?? 0,
          mondayAmount: value.calculateDailyExpenseSummary()[monday] ?? 0,
          tuesdayAmount: value.calculateDailyExpenseSummary()[tuesday] ?? 0,
          wednesdayAmount: value.calculateDailyExpenseSummary()[wednesday] ?? 0,
          thursdayAmount: value.calculateDailyExpenseSummary()[thursday] ?? 0,
          fridayAmount: value.calculateDailyExpenseSummary()[friday] ?? 0,
          saturdayAmount: value.calculateDailyExpenseSummary()[saturday] ?? 0,
        ),
      ),
    );
  }
}
