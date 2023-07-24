import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ceremoney/data/expense_data.dart';
import 'package:ceremoney/graph_monthly/pie_chart.dart';
import 'package:ceremoney/pages/transaction.dart';
import 'package:ceremoney/pages/history.dart';
import 'package:ceremoney/pages/home.dart';
import 'package:provider/provider.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  _AnalyticsPage createState() => _AnalyticsPage();
}

class _AnalyticsPage extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    // prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  // PAGE INDEX
  int _selectedIndex = 2;

  // handle tab change
  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        pageTransitionBuilder(const HomePage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        pageTransitionBuilder(const HistoryPage()),
      );
    } else if (index == 2) {
      // current page
    } else if (index == 3) {
      Navigator.push(
        context,
        pageTransitionBuilder(const TransactionPage()),
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

  List<String> monthList = [
    'JANUARY',
    'FEBRUARY',
    'MARCH',
    'APRIL',
    'MAY',
    'JUNE',
    'JULY',
    'AUGUST',
    'SEPTEMBER',
    'OCTOBER',
    'NOVEMBER',
    'DECEMBER'
  ];

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

  // get list of years and months
  List<String> getYearMonthList() {
    List<String> yearMonthList = [];
    for (String year in yearList) {
      for (int month = 0; month < 12; month++) {
        String currYearMonth = '${monthList[month]} $year';
        yearMonthList.add(currYearMonth);
      }
    }
    return yearMonthList;
  }

  // default
  String? selectedYearMonth = 'JULY 2023';

  _AnalyticsPage() {
    selectedYearMonth = 'JULY 2023';
  }

  // yearmonth formatter
  String formatYearMonth(String yearMonth) {
    int currMonth = 0;
    String month = yearMonth.split(' ')[0];
    String year = yearMonth.split(' ')[1];
    for (int i = 0; i < 12; i++) {
      if (month == monthList[i]) {
        currMonth = i + 1;
      }
    }
    return '$currMonth/$year';
  }

  @override
  Widget build(BuildContext context) {
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
                  Navigator.push(
                    context,
                    pageTransitionBuilder(const TransactionPage()),
                  );
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
                  Text(
                    'ANALYTICS',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 247, 0, 255)),
                  ),
                ])),
            DropdownButtonFormField(
              menuMaxHeight: 300,
              isExpanded: false,
              value: selectedYearMonth,
              items: getYearMonthList().map((String yearMonth) {
                return DropdownMenuItem(
                    value: yearMonth,
                    child: DefaultTextStyle(
                        style: const TextStyle(color: Colors.white),
                        child: Text(yearMonth)));
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedYearMonth = newValue;
                  });
                }
              },
              decoration: const InputDecoration(
                labelText: "CHOOSE A MONTH",
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
            SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.all(15.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                      'TOTAL AMOUNT SPENT : ${value.calculateTotalExpenditureByMonth(formatYearMonth(selectedYearMonth!))}',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 247, 0, 255))),
                ])),
            AnalyticsGraph(
                yearMonth: formatYearMonth(selectedYearMonth!),
                monthlyData: value.calculateCategoryExpenseSummaryByMonth(
                    formatYearMonth(selectedYearMonth!)))
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
