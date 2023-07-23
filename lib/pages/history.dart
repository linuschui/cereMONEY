import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:money_manager/graph_monthly/line_graph.dart';
import 'package:money_manager/components/history_tile.dart';
import 'package:money_manager/data/expense_data.dart';
import 'package:money_manager/pages/expense.dart';
import 'package:money_manager/pages/analytics.dart';
import 'package:money_manager/pages/home.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    // prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  int _selectedIndex = 1;

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
    } else if (index == 2) {
      // Navigate to the Analytics with a smooth slide transition
      Navigator.push(
        context,
        pageTransitionBuilder(const AnalyticsPage()),
      );
    } else if (index == 3) {
      // Navigate to the AddExpense Page with a smooth slide transition
      Navigator.push(
        context,
        pageTransitionBuilder(const ExpensePage()),
      );
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

  // get list of years
  List<String> yearList = [
    '2000',
    '2001',
    '2002',
    '2003',
    '2004',
    '2005',
    '2006',
    '2007',
    '2008',
    '2009',
    '2010',
    '2011',
    '2012',
    '2013',
    '2014',
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030',
  ];
  // default
  String? selectedYear = '2023';

  _HistoryPageState() {
    selectedYear = yearList[23];
  }

  void handleSelectYear() {}

  @override
  Widget build(BuildContext context) {
    selectedYear = selectedYear;
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
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
        body: Column(
          children: [
            const Padding(
                padding: EdgeInsets.all(15.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('HISTORY',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 247, 0, 255))),
                ])),
            DropdownButtonFormField(
              menuMaxHeight: 300,
              isExpanded: false,
              value: selectedYear,
              items: yearList.map((String year) {
                return DropdownMenuItem(
                    value: year,
                    child: DefaultTextStyle(
                        style: const TextStyle(color: Colors.white),
                        child: Text(year)));
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedYear = newValue;
                  });
                }
              },
              decoration: const InputDecoration(
                labelText: "CHOOSE A YEAR",
                labelStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.access_time_filled, color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          Colors.white), // Set underline border color to white
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors
                          .white), // Set focused underline border color to white
                ),
              ),
              icon:
                  const Icon(Icons.arrow_drop_down_circle, color: Colors.white),
              dropdownColor: Colors.black,
              style: const TextStyle(
                  color: Colors.white), // Set dropdown text color to white
            ),
            // Padding(
            //     padding: const EdgeInsets.all(15.0),
            //     child:
            //         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            //       Text('SELECTED YEAR : $selectedYear',
            //           style: const TextStyle(
            //               fontSize: 12,
            //               fontWeight: FontWeight.bold,
            //               color: Color.fromARGB(255, 247, 0, 255))),
            //     ])),
            // MonthlyExpenseLineChart(monthlyExpenseSummaryByYear: value.calculateHistoryExpenseSummaryByYear(2023), year: '2023'),
            HistoryGraph(
                year: selectedYear.toString(),
                yearlyData: value.calculateHistoryExpenseSummaryByYear(
                    int.parse(selectedYear!))),
            Expanded(
              // Use Expanded to make the ListView.builder scrollable independently
              child: ListView.builder(
                shrinkWrap: true,
                physics:
                    const AlwaysScrollableScrollPhysics(), // Use AlwaysScrollableScrollPhysics for the ListView.builder
                itemCount: value.calculateHistoryExpenseSummary().length,
                itemBuilder: (context, index) => HistoryTile(
                  monthYear: value
                      .calculateHistoryExpenseSummary()
                      .keys
                      .elementAt(index),
                  amount: value
                      .calculateHistoryExpenseSummary()
                      .values
                      .elementAt(index),
                  showTapped: (p0) => (),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.black,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
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
      ),
    );
  }
}
