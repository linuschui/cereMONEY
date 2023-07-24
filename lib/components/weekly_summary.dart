import 'package:flutter/material.dart';
import 'package:ceremoney/graph_weekly/bar_graph.dart';
import 'package:ceremoney/data/expense_data.dart';
import 'package:ceremoney/datetime/datetime_helper.dart';
import 'package:provider/provider.dart';

class WeeklySummary extends StatelessWidget {
  final DateTime startOfWeek;
  const WeeklySummary({super.key, required this.startOfWeek});

  // calculate max
  double calculateMax(
      ExpenseData value,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday) {
    double? max = 100;
    List<double> expenseValues = [
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0
    ];
    List<double> savingsValues = [
      value.calculateDailySavingsSummary()[sunday] ?? 0,
      value.calculateDailySavingsSummary()[monday] ?? 0,
      value.calculateDailySavingsSummary()[tuesday] ?? 0,
      value.calculateDailySavingsSummary()[wednesday] ?? 0,
      value.calculateDailySavingsSummary()[thursday] ?? 0,
      value.calculateDailySavingsSummary()[friday] ?? 0,
      value.calculateDailySavingsSummary()[saturday] ?? 0
    ];
    List<double> combinedValues = [];
    for (int i = 0; i < 7; i++) {
      combinedValues.add(expenseValues[i] + savingsValues[i]);
    }
    combinedValues.sort();
    max = combinedValues.last * 1.1;
    return max == 0 ? 100 : max;
  }

  // calculate weekly total
  String calculateWeekTotal(
      ExpenseData value,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday) {
    List<double> values = [
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0
    ];
    double total = 0;
    for (int i = 0; i < values.length; i++) {
      total += values[i];
    }
    return total.toStringAsFixed(2);
  }

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
        builder: (context, value, child) => Column(children: [
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(children: [
                    const Text('THIS WEEK ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 247, 0, 255))),
                    Text(
                        '\$${calculateWeekTotal(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday)}',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 247, 0, 255))),
                  ])),
              SizedBox(
                height: 200,
                child: MyBarGraph(
                    maxY: calculateMax(value, sunday, monday, tuesday,
                        wednesday, thursday, friday, saturday),
                    sundayAmount:
                        value.calculateDailyExpenseSummary()[sunday] ?? 0,
                    mondayAmount:
                        value.calculateDailyExpenseSummary()[monday] ?? 0,
                    tuesdayAmount:
                        value.calculateDailyExpenseSummary()[tuesday] ?? 0,
                    wednesdayAmount:
                        value.calculateDailyExpenseSummary()[wednesday] ?? 0,
                    thursdayAmount:
                        value.calculateDailyExpenseSummary()[thursday] ?? 0,
                    fridayAmount:
                        value.calculateDailyExpenseSummary()[friday] ?? 0,
                    saturdayAmount:
                        value.calculateDailyExpenseSummary()[saturday] ?? 0,
                    sundaySavings:
                        value.calculateDailySavingsSummary()[sunday] ?? 0,
                    mondaySavings:
                        value.calculateDailySavingsSummary()[monday] ?? 0,
                    tuesdaySavings:
                        value.calculateDailySavingsSummary()[tuesday] ?? 0,
                    wednesdaySavings: value.calculateDailySavingsSummary()[wednesday] ?? 0,
                    thursdaySavings: value.calculateDailySavingsSummary()[thursday] ?? 0,
                    fridaySavings: value.calculateDailySavingsSummary()[friday] ?? 0,
                    saturdaySavings: value.calculateDailySavingsSummary()[saturday] ?? 0),
              ),
            ]));
  }
}
