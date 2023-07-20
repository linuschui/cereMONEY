import 'package:hive/hive.dart';

import '../models/expense_item.dart';

class HiveDataBase {
  final _myBox = Hive.box("cereMONEY_database_v2");

  // write data
  void saveData(List<ExpenseItem> allExpenses) {
    // convert ExpenseItem objects into String
    List<List<dynamic>> allExpensesFormatted = [];
    for (var expense in allExpenses) {
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime
      ];
      allExpensesFormatted.add(expenseFormatted);
      // store in database
      _myBox.put("all_expenses", allExpensesFormatted);
    }
  }

  // read data
  List<ExpenseItem> readData() {
    List savedExpenses = _myBox.get("all_expenses") ?? [];
    List<ExpenseItem> allExpenses = [];
    for (int i = 0; i < savedExpenses.length; i++) {
      ExpenseItem expenseItem = ExpenseItem(
          name: savedExpenses[i][0],
          amount: savedExpenses[i][1],
          dateTime: savedExpenses[i][2]);
      allExpenses.add(expenseItem);
    }
    return allExpenses;
  }
}
