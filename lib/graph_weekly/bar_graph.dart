import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'bar_data.dart';

class MyBarGraph extends StatelessWidget {
  final double? maxY;
  final double sundayAmount;
  final double mondayAmount;
  final double tuesdayAmount;
  final double wednesdayAmount;
  final double thursdayAmount;
  final double fridayAmount;
  final double saturdayAmount;
  final double mondaySavings;
  final double tuesdaySavings;
  final double wednesdaySavings;
  final double thursdaySavings;
  final double fridaySavings;
  final double saturdaySavings;
  final double sundaySavings;

  const MyBarGraph(
      {super.key,
      required this.maxY,
      required this.sundayAmount,
      required this.mondayAmount,
      required this.tuesdayAmount,
      required this.wednesdayAmount,
      required this.thursdayAmount,
      required this.fridayAmount,
      required this.saturdayAmount,
      required this.mondaySavings,
      required this.tuesdaySavings,
      required this.wednesdaySavings,
      required this.thursdaySavings,
      required this.fridaySavings,
      required this.saturdaySavings,
      required this.sundaySavings});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
        sundayAmount: sundayAmount,
        mondayAmount: mondayAmount,
        tuesdayAmount: tuesdayAmount,
        wednesdayAmount: wednesdayAmount,
        thursdayAmount: thursdayAmount,
        fridayAmount: fridayAmount,
        saturdayAmount: saturdayAmount,
        sundaySavings: sundaySavings,
        mondaySavings: mondaySavings,
        tuesdaySavings: tuesdaySavings,
        wednesdaySavings: wednesdaySavings,
        thursdaySavings: thursdaySavings,
        fridaySavings: fridaySavings,
        saturdaySavings: saturdaySavings);

    myBarData.initialiseBarData();

    List<double> expensesList = [
      sundayAmount,
      mondayAmount,
      tuesdayAmount,
      wednesdayAmount,
      thursdayAmount,
      fridayAmount,
      saturdayAmount
    ];

    List<double> savingsList = [
      mondaySavings,
      tuesdaySavings,
      wednesdaySavings,
      thursdaySavings,
      fridaySavings,
      saturdaySavings,
      sundaySavings,
    ];

    bool isTouched = false;

    return BarChart(BarChartData(
      barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.black,
        tooltipBorder: const BorderSide(
            color: Color.fromARGB(255, 247, 0, 255), width: 2.0),
        tooltipRoundedRadius: 10,
        tooltipMargin: 8.0,
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          String weekday = '';
          switch (group.x.toInt()) {
            case 0:
              weekday = 'SUNDAY';
              break;
            case 1:
              weekday = 'MONDAY';
              break;
            case 2:
              weekday = 'TUESDAY';
              break;
            case 3:
              weekday = 'WEDNESDAY';
              break;
            case 4:
              weekday = 'THURSDAY';
              break;
            case 5:
              weekday = 'FRIDAY';
              break;
            case 6:
              weekday = 'SATURDAY';
              break;
            default:
              weekday = '';
              break;
          }
          return BarTooltipItem(
              // tooltip title
              weekday,
              const TextStyle(
                  color: Color.fromARGB(255, 247, 0, 255),
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
              children: <TextSpan>[
                TextSpan(
                    // tooltip body
                    text:
                        '\nSAVED : \$${(savingsList[groupIndex]).toStringAsFixed(2)}\nSPENT : \$${(rod.toY - savingsList[groupIndex]).toStringAsFixed(2)}\nTOTAL : \$${rod.toY.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12))
              ]);
        },
      )),
      maxY: maxY,
      // barTouchData: BarTouchData(enabled: false),
      minY: 0,
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true, getTitlesWidget: getBottomTitles))),
      barGroups: myBarData.barData
          .map(
            (data) => BarChartGroupData(
              x: data.x,
              barRods: [
                BarChartRodData(
                    toY: data.y,
                    rodStackItems: [
                      BarChartRodStackItem(0, data.y - savingsList[data.x],
                          const Color.fromARGB(255, 247, 130, 241)),
                      BarChartRodStackItem(data.y - savingsList[data.x], data.y,
                          const Color.fromARGB(255, 182, 247, 182))
                    ],
                    width: 25,
                    borderRadius: BorderRadius.circular(25.0),
                    backDrawRodData: BackgroundBarChartRodData(
                        show: true, toY: maxY, color: Colors.black),
                    // TODO
                    borderSide: isTouched
                        ? const BorderSide(color: Colors.white)
                        : const BorderSide(color: Colors.black, width: 4)),
              ],
            ),
          )
          .toList(),
    ));
  }
}

// x-axis labels
Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Color.fromARGB(255, 247, 0, 255),
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('S', style: style);
      break;
    case 1:
      text = const Text('M', style: style);
      break;
    case 2:
      text = const Text('T', style: style);
      break;
    case 3:
      text = const Text('W', style: style);
      break;
    case 4:
      text = const Text('T', style: style);
      break;
    case 5:
      text = const Text('F', style: style);
      break;
    case 6:
      text = const Text('S', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }
  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
