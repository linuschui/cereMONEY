import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthlyExpenditureGraph extends StatelessWidget {
  final String year;
  final Map<String, double> monthlyExpenditures;

  MonthlyExpenditureGraph(
      {required this.year, required this.monthlyExpenditures});

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = [];

    int groupCount = 0;
    monthlyExpenditures.forEach((month, amount) {
      barGroups.add(
        BarChartGroupData(
          x: groupCount,
          barRods: [
            BarChartRodData(
              toY: amount,
              color: Colors.blue,
            ),
          ],
        ),
      );

      groupCount++;
    });

    return AspectRatio(
      aspectRatio: 1.8,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          groupsSpace: 12,
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            // topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            // rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                // getTitles: (value) {
                //   if (value.toInt() >= 0 && value.toInt() < monthlyExpenditures.length) {
                //     return monthlyExpenditures.keys.elementAt(value.toInt());
                //   }
                //   return '';
                // },
              ),
            ),
          ),
          barGroups: barGroups,
        ),
      ),
    );
  }
}
