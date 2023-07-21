import 'package:money_manager/graph_weekly/individual_bar.dart';

class BarData {
  final double mondayAmount;
  final double tuesdayAmount;
  final double wednesdayAmount;
  final double thursdayAmount;
  final double fridayAmount;
  final double saturdayAmount;
  final double sundayAmount;
  final double mondaySavings;
  final double tuesdaySavings;
  final double wednesdaySavings;
  final double thursdaySavings;
  final double fridaySavings;
  final double saturdaySavings;
  final double sundaySavings;

  BarData(
      {required this.mondayAmount,
      required this.tuesdayAmount,
      required this.wednesdayAmount,
      required this.thursdayAmount,
      required this.fridayAmount,
      required this.saturdayAmount,
      required this.sundayAmount,
      required this.mondaySavings,
      required this.tuesdaySavings,
      required this.wednesdaySavings,
      required this.thursdaySavings,
      required this.fridaySavings,
      required this.saturdaySavings,
      required this.sundaySavings});

  List<IndiviudalBar> barData = [];

  void initialiseBarData() {
    barData = [
      IndiviudalBar(x: 0, y: mondayAmount + mondaySavings),
      IndiviudalBar(x: 1, y: tuesdayAmount + tuesdaySavings),
      IndiviudalBar(x: 2, y: wednesdayAmount + wednesdaySavings),
      IndiviudalBar(x: 3, y: thursdayAmount + thursdaySavings),
      IndiviudalBar(x: 4, y: fridayAmount + fridaySavings),
      IndiviudalBar(x: 5, y: saturdayAmount + saturdaySavings),
      IndiviudalBar(x: 6, y: sundayAmount + sundaySavings),
      // IndiviudalBar(x: 0, y: mondaySavings),
      // IndiviudalBar(x: 1, y: tuesdaySavings),
      // IndiviudalBar(x: 2, y: wednesdaySavings),
      // IndiviudalBar(x: 3, y: thursdaySavings),
      // IndiviudalBar(x: 4, y: fridaySavings),
      // IndiviudalBar(x: 5, y: saturdaySavings),
      // IndiviudalBar(x: 6, y: sundaySavings),
    ];
  }
}
