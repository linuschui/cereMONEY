import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseTile extends StatelessWidget {
  final String type;
  final String name;
  final String amount;
  final DateTime dateTime;
  final void Function(BuildContext)? deleteTapped;

// format the date time : [DD/MM/YYYY HH:MM:SS]
  String dateTimeFormatter(DateTime dateTime) {
    String year = dateTime.toLocal().year.toString();
    String month = dateTime.toLocal().month.toString();
    String day = dateTime.toLocal().day.toString();
    String hour = dateTime.toLocal().hour.toString();
    String minute = dateTime.toLocal().minute.toString();
    String second = dateTime.toLocal().second.toString();
    if (month.length == 1) {
      month = '0$month';
    }
    if (day.length == 1) {
      day = '0$day';
    }
    if (hour.length == 1) {
      hour = '0$hour';
    }
    if (minute.length == 1) {
      minute = '0$minute';
    }
    if (second.length == 1) {
      second = '0$second';
    }
    String newDateTime = '$day/$month/$year $hour:$minute:$second';
    return newDateTime;
  }

  const ExpenseTile(
      {super.key,
      required this.type,
      required this.name,
      required this.amount,
      required this.dateTime,
      required this.deleteTapped});

  // check if transaction type is savings
  bool isSavings() {
    List<String> savingTypes = ['SALARY', 'DEPOSITS', 'OTHER INCOME'];
    return savingTypes.contains(type);
  }

  @override
  Widget build(BuildContext context) {
    // sliding animation
    return Slidable(
        endActionPane: ActionPane(
            extentRatio: 0.2,
            motion: const StretchMotion(),
            children: [
              SlidableAction(onPressed: deleteTapped, icon: Icons.delete),
            ]),
        child: ListTile(
          textColor: isSavings()
              ? Colors.green
              : double.parse(amount) < 100
                  ? Colors.white
                  : Colors.red,
          title: Text('$type : $name'),
          subtitle: Text(dateTimeFormatter(dateTime)),
          trailing: Text('\$$amount'),
        ));
  }
}
