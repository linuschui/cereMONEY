import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HistoryTile extends StatelessWidget {
  final String monthYear;
  final double amount;
  void Function(BuildContext)? showTapped;

  HistoryTile(
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
              SlidableAction(onPressed: showTapped, icon: Icons.delete),
            ]),
        child: ListTile(
          textColor: Colors.white,
          title: Text(monthYear.split(' ')[0].toUpperCase()),
          subtitle: Text(monthYear.split(' ')[1]),
          trailing: Text(amount.toStringAsFixed(2)),
        ));
  }
}
