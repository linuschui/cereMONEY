import 'package:money_manager/bar_graph/individual_bar.dart';

class BarData {
  final double mondayAmount;
  final double tuesdayAmount;
  final double wednesdayAmount;
  final double thursdayAmount;
  final double fridayAmount;
  final double saturdayAmount;
  final double sundayAmount;

  BarData(
      {required this.mondayAmount,
      required this.tuesdayAmount,
      required this.wednesdayAmount,
      required this.thursdayAmount,
      required this.fridayAmount,
      required this.saturdayAmount,
      required this.sundayAmount});

  List<IndiviudalBar> barData = [];

  void initialiseBarData() {
    barData = [
      IndiviudalBar(x: 0, y: mondayAmount),
      IndiviudalBar(x: 1, y: tuesdayAmount),
      IndiviudalBar(x: 2, y: wednesdayAmount),
      IndiviudalBar(x: 3, y: thursdayAmount),
      IndiviudalBar(x: 4, y: fridayAmount),
      IndiviudalBar(x: 5, y: saturdayAmount),
      IndiviudalBar(x: 6, y: sundayAmount)
    ];
  }
}
