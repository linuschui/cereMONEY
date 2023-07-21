import 'package:hive/hive.dart';

import '../models/expense_item.dart';

class HiveDataBase {
  final _myBox = Hive.box("cereMONEY_database_v3");

  // write data
  void saveData(List<ExpenseItem> allExpenses) {
    // convert ExpenseItem objects into String
    List<List<dynamic>> allExpensesFormatted = [];
    for (var expense in allExpenses) {
      List<dynamic> expenseFormatted = [
        expense.type,
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
          type: savedExpenses[i][0],
          name: savedExpenses[i][1],
          amount: savedExpenses[i][2],
          dateTime: savedExpenses[i][3]);
      allExpenses.add(expenseItem);
    }
    return allExpenses;
  }
}
