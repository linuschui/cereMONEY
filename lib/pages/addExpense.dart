import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:money_manager/data/expense_data.dart';
import 'package:money_manager/models/expense_item.dart';
import 'package:money_manager/pages/analytics.dart';
import 'package:money_manager/pages/history.dart';
import 'package:money_manager/pages/home_page.dart';
import 'package:provider/provider.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({Key? key}) : super(key: key);
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  @override
  void initState() {
    super.initState();
    // prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  _AddExpensePageState() {
    selectedExpenseCategory = expenseCategories[0];
  }

  List<String> expenseCategories = [
    'FOOD',
    'CLOTHING',
    'TRASNSPORTATION',
    'HEALTH',
    'TRAVEL',
    'PET',
    'RENT',
    'MISCELLANEOUS'
  ];

  String? selectedExpenseCategory = ''; // Default category
  TextEditingController newExpenseDollarsController = TextEditingController();
  TextEditingController newExpenseCentsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void save() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text('PROCESSING DATA',
                style: TextStyle(
                    color: Color.fromARGB(255, 247, 0, 255),
                    fontWeight: FontWeight.bold)),
          ),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 3),
        ),
      );
      String amount =
          '${newExpenseDollarsController.text}.${newExpenseCentsController.text}';
      double amountPrecision = double.parse(amount);
      String finalAmount = amountPrecision.toStringAsFixed(2);
      ExpenseItem newExpense = ExpenseItem(
          name: selectedExpenseCategory!,
          amount: finalAmount,
          dateTime: DateTime.now());
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
      // Navigator.pop(context);
      setState(() {
        _selectedIndex = 0;
      });
      Navigator.push(
        context,
        pageTransitionBuilder(const HomePage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Center(
              child: Text('SUCCESSFULLY ADDED',
                  style: TextStyle(
                      color: Color.fromARGB(255, 247, 0, 255),
                      fontWeight: FontWeight.bold)),
            ),
            backgroundColor: Colors.black),
      );
      clear();
    }
  }

  void cancel() {
    Navigator.pop(context);
    setState(() {
      _selectedIndex = 0;
    });
    Navigator.push(
      context,
      pageTransitionBuilder(const HomePage()),
    );
    clear();
  }

  void clear() {
    newExpenseDollarsController.clear();
    newExpenseCentsController.clear();
  }

  int _selectedIndex = 3;

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigate to the Home with a smooth slide transition
      Navigator.push(
        context,
        pageTransitionBuilder(const HomePage()),
      );
    } else if (index == 1) {
      // Do nothing, already on the History page.
      Navigator.push(
        context,
        pageTransitionBuilder(const HistoryPage()),
      );
    } else if (index == 2) {
      // Navigate to the Analytics with a smooth slide transition
      Navigator.push(
        context,
        pageTransitionBuilder(const AnalyticsPage()),
      );
    } else if (index == 3) {
      // Do nothing, already on the History page.
    }
  }

  PageRouteBuilder pageTransitionBuilder(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        toolbarHeight: 60,
        title: Row(
          children: [
            const Text('CEREMONEY'),
            IconButton(
              icon: const Icon(Icons.monetization_on),
              onPressed: () {
                // Add the onPressed action here, e.g., open a drawer
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Padding(
                padding: EdgeInsets.all(15.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('ADD AN EXPENSE',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 247, 0, 255))),
                ])),
            const SizedBox(
              height: 20,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      value: selectedExpenseCategory,
                      items: expenseCategories.map((String category) {
                        return DropdownMenuItem(
                            value: category,
                            child: DefaultTextStyle(
                              style: const TextStyle(color: Colors.white),
                              child: Text(category.toUpperCase()),
                            ));
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedExpenseCategory = newValue;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: "TYPE OF EXPENSE",
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.add_shopping_cart_rounded,
                            color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .white), // Set underline border color to white
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .white), // Set focused underline border color to white
                        ),
                      ),
                      icon: const Icon(Icons.arrow_drop_down_circle,
                          color: Colors.white),
                      dropdownColor: Colors.black,
                      style: const TextStyle(
                          color:
                              Colors.white), // Set dropdown text color to white
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                      },
                      controller: newExpenseDollarsController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'DOLLARS',
                        border: const OutlineInputBorder(),
                        labelStyle: const TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white), // Border color when focused
                          borderRadius:
                              BorderRadius.circular(10.0), // Rounded corners
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .white), // Border color when enabled but not focused
                          borderRadius:
                              BorderRadius.circular(10.0), // Rounded corners
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .red), // Border color when there's an error
                          borderRadius:
                              BorderRadius.circular(10.0), // Rounded corners
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .red), // Border color when there's an error and focused
                          borderRadius:
                              BorderRadius.circular(10.0), // Rounded corners
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(5),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: newExpenseCentsController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'CENTS',
                        border: const OutlineInputBorder(),
                        labelStyle: const TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white), // Border color when focused
                          borderRadius:
                              BorderRadius.circular(10.0), // Rounded corners
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .white), // Border color when enabled but not focused
                          borderRadius:
                              BorderRadius.circular(10.0), // Rounded corners
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .red), // Border color when there's an error
                          borderRadius:
                              BorderRadius.circular(10.0), // Rounded corners
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .red), // Border color when there's an error and focused
                          borderRadius:
                              BorderRadius.circular(10.0), // Rounded corners
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.black, // Background color of the button
                            foregroundColor: const Color.fromARGB(
                                255, 247, 0, 255), // Text color of the button
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // Rounded corners
                            ),
                            elevation: 3, // Elevation of the button
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24), // Button padding
                          ),
                          child: const Text('SAVE',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        ElevatedButton(
                          onPressed: cancel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.black, // Background color of the button
                            foregroundColor: const Color.fromARGB(
                                255, 247, 0, 255), // Text color of the button
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // Rounded corners
                            ),
                            elevation: 3, // Elevation of the button
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24), // Button padding
                          ),
                          child: const Text('CANCEL',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                )),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            backgroundColor: Colors.black,
            tabBackgroundColor: Colors.grey,
            color: Colors.white,
            activeColor: Colors.white,
            gap: 8,
            padding: const EdgeInsets.all(16),
            tabs: [
              GButton(
                icon: Icons.home,
                text: ' HOME',
                backgroundColor: _selectedIndex == 0
                    ? Colors.grey.shade800 // Use grey when selected
                    : Colors.transparent, // Use transparent when not selected
              ),
              GButton(
                icon: Icons.history_outlined,
                text: ' HISTORY',
                backgroundColor: _selectedIndex == 1
                    ? Colors.grey.shade800 // Use grey when selected
                    : Colors.transparent, // Use transparent when not selected
              ),
              GButton(
                icon: Icons.analytics,
                text: ' ANALYTICS',
                backgroundColor: _selectedIndex == 2
                    ? Colors.grey.shade800 // Use grey when selected
                    : Colors.transparent, // Use transparent when not selected
              ),
              GButton(
                icon: Icons.add,
                text: ' ADD',
                backgroundColor: _selectedIndex == 3
                    ? Colors.grey.shade800 // Use grey when selected
                    : Colors.transparent, // Use transparent when not selected
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: _onTabChange,
          ),
        ),
      ),
    );
  }
}
