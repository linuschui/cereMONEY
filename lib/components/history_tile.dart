import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HistoryTile extends StatelessWidget {
  final String monthYear;
  final double amount;
  final void Function(BuildContext)? showTapped;

  const HistoryTile(
      {super.key,
      required this.monthYear,
      required this.amount,
      required this.showTapped});

  @override
  Widget build(BuildContext context) {
    return Slidable(
        endActionPane: ActionPane(
            extentRatio: 0.2,
            motion: const StretchMotion(),
            children: [
              SlidableAction(onPressed: (p0) => {}, icon: Icons.show_chart),
            ]),
        child: ListTile(
          textColor: Colors.white,
          title: Text(monthYear.split(' ')[0].toUpperCase()),
          subtitle: Text(monthYear.split(' ')[1]),
          trailing: Text(amount.toStringAsFixed(2)),
        ));
  }
}
