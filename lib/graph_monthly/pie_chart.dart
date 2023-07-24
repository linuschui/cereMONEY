import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ceremoney/components/category_summary.dart';
import 'package:ceremoney/graph_monthly/indicator.dart';

class AnalyticsGraph extends StatefulWidget {
  const AnalyticsGraph(
      {super.key, required this.yearMonth, required this.monthlyData});
  final String yearMonth;
  final List<CategorySummary> monthlyData;

  @override
  State<AnalyticsGraph> createState() => _AnalyticsGraph();
}

class _AnalyticsGraph extends State<AnalyticsGraph> {
  int touchedIndex = -1;

  List<Color> categoryColors = [
    Colors.red,
    Colors.orange,
    const Color.fromARGB(255, 255, 198, 123),
    Colors.yellow,
    Colors.green,
    Colors.cyan,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    const Color.fromARGB(183, 226, 0, 188),
    Colors.pink
  ];

  double getTotalExpenditure() {
    double currTotal = 0.0;
    for (var category in widget.monthlyData) {
      currTotal += category.amount;
    }
    return currTotal;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 60,
                  sections: generateSections(widget.monthlyData),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: generateIndicators(widget.monthlyData),
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<Widget> generateIndicators(List<CategorySummary> monthlyData) {
    List<Widget> indicators = [];
    for (int i = 0; i < monthlyData.length; i++) {
      if (monthlyData[i].amount > 0) {
        indicators.add(Indicator(
            color: categoryColors[i],
            text: monthlyData[i].type.toUpperCase(),
            isSquare: true));
        indicators.add(const SizedBox(
          width: 28,
        ));
      }
    }
    indicators.add(const SizedBox(width: 28));
    return indicators;
  }

  List<PieChartSectionData> generateSections(
      List<CategorySummary> monthlyData) {
    final totalExpenditure = getTotalExpenditure();
    List<PieChartSectionData> sections = [];

    for (int i = 0; i < monthlyData.length; i++) {
      final data = monthlyData[i];
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      sections.add(
        PieChartSectionData(
          color: categoryColors[i % categoryColors.length],
          value: data.amount == 0 ? 0.01 : data.amount / totalExpenditure,
          title: data.amount == 0
              ? ''
              : '${(data.amount / totalExpenditure * 100).toStringAsFixed(2)}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
        ),
      );
    }
    return sections;
  }
}
