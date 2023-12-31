import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ceremoney/components/monthly_summary.dart';

class HistoryGraph extends StatefulWidget {
  const HistoryGraph({super.key, required this.year, required this.yearlyData});
  final String year;
  final List<MonthlySummary> yearlyData;

  @override
  State<HistoryGraph> createState() => _HistoryGraph();
}

class _HistoryGraph extends State<HistoryGraph> {
  // helper function to calculate maximum
  double getMaximum() {
    double currMax = 0.0;
    for (var item in widget.yearlyData) {
      if (item.amount > currMax) {
        currMax = item.amount;
      }
    }
    return currMax;
  }

  // helper function to calculate average
  double getAverage() {
    double currAverage = 0.0;
    for (var item in widget.yearlyData) {
      currAverage += item.amount;
    }
    return double.parse((currAverage / 12.0).toStringAsFixed(2));
  }

  // boolean to show average or overall
  bool showAvg = false;

  // initialise data for overall
  LineChartBarData getOverallData() {
    List<FlSpot> spots = [];
    for (var item in widget.yearlyData) {
      double x = item.month.toDouble();
      double y = item.amount;
      spots.add(FlSpot(x, y));
    }
    return LineChartBarData(
      color: Colors.white,
      spots: spots,
      isCurved: false,
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: const FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
  }

  // initialise data for average
  LineChartBarData getAverageData() {
    List<FlSpot> spots = [];
    for (int i = 0; i < 12; i++) {
      double x = i.toDouble();
      double y = getAverage();
      spots.add(FlSpot(x, y));
    }
    return LineChartBarData(
      color: Colors.white,
      spots: spots,
      isCurved: true,
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: const FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
  }

  // months helper
  String getMonthName(int month) {
    List<String> months = [
      "JANUARY",
      "FEBRUARY",
      "MARCH",
      "APRIL",
      "MAY",
      "JUNE",
      "JULY",
      "AUGUST",
      "SEPTEMBER",
      "OCTOBER",
      "NOVEMBER",
      "DECEMBER",
    ];
    return months[month];
  }

  // initialise line chart for overall
  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black,
          tooltipBorder: const BorderSide(
              color: Color.fromARGB(255, 247, 0, 255), width: 2.0),
          tooltipRoundedRadius: 10,
          tooltipMargin: 8.0,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipItems: (spots) {
            return spots.map(
              (touchedSpot) {
                MonthlySummary currMonth =
                    widget.yearlyData[touchedSpot.spotIndex];
                return LineTooltipItem(
                    '${getMonthName(touchedSpot.spotIndex)}\n\$${currMonth.amount.toStringAsFixed(2)}',
                    const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold));
              },
            ).toList();
          }, // TO DO
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: getMaximum() / 5 > 0 ? getMaximum() / 5 : 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        // leftTitles: AxisTitles(
        //   sideTitles: SideTitles(
        //     showTitles: true,
        //     interval: 1,
        //     getTitlesWidget: leftTitleWidgets,
        //     reservedSize: 42,
        //   ),
        // ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: Colors.white),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: getMaximum() > 0 ? getMaximum() * 1.1 : 6,
      lineBarsData: [getOverallData()],
    );
  }

  // initialise line chart for average
  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.black,
              tooltipBorder: const BorderSide(
                  color: Color.fromARGB(255, 247, 0, 255), width: 2.0),
              tooltipRoundedRadius: 10,
              tooltipMargin: 8.0,
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (spots) {
                return spots.map((touchedSpot) {
                  MonthlySummary currMonth =
                      widget.yearlyData[touchedSpot.spotIndex];
                  double currMonthAmount = currMonth.amount;
                  double average = getAverage();
                  double difference = currMonthAmount - average;
                  double postiiveDifference = difference - 2 * difference;
                  bool aboveAverage = difference > 0;
                  return LineTooltipItem(
                      aboveAverage
                          ? '${getMonthName(touchedSpot.spotIndex)}\n+\$${difference.toStringAsFixed(2)}'
                          : '${getMonthName(touchedSpot.spotIndex)}\n-\$${postiiveDifference.toStringAsFixed(2)}',
                      TextStyle(
                          color: aboveAverage ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold));
                }).toList();
              })),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: getMaximum() / 5 > 0 ? getMaximum() / 5 : 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        // leftTitles: AxisTitles(
        //   sideTitles: SideTitles(
        //     showTitles: true,
        //     getTitlesWidget: leftTitleWidgets,
        //     reservedSize: 42,
        //     interval: 1,
        //   ),
        // ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: Colors.white),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: getMaximum() > 0 ? getMaximum() * 1.1 : 6,
      lineBarsData: [getAverageData()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.5,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 25,
              left: 25,
              top: 10,
              bottom: 10,
            ),
            child: LineChart(
              showAvg ? avgData() : mainData(),
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 100,
              height: 40,
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      showAvg = !showAvg;
                    });
                  },
                  child: Text(
                    'AVERAGE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: showAvg
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  )),
            ),
            SizedBox(
              width: 60,
              height: 40,
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      showAvg = showAvg;
                    });
                  },
                  child: Text(
                    '${getAverage()}',
                    style: TextStyle(
                      fontSize: 12,
                      color: showAvg
                          ? const Color.fromARGB(255, 247, 0, 255)
                          : Colors.black,
                    ),
                  )),
            ),
          ],
        ),
      ],
    );
  }

  // x-axis labels : only shows March, June and September
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Color.fromARGB(255, 247, 0, 255));
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  // y axis labels (UNUSED)
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = (getMaximum() * 1.1 / 5).toStringAsFixed(2);
        break;
      case 3:
        text = (getMaximum() * 1.1 * 0.6).toStringAsFixed(2);
        break;
      case 5:
        text = (getMaximum() * 1.1).toStringAsFixed(2);
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }
}
