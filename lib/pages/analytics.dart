import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:money_manager/pages/analytics.dart';
import 'package:money_manager/pages/history.dart';
import 'package:money_manager/pages/home_page.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  _AnalyticsPage createState() => _AnalyticsPage();
}

class _AnalyticsPage extends State<AnalyticsPage> {
  int _selectedIndex = 2;

  void _onTabChange(int index) {
    // setState(() {
    //   _selectedIndex = index;
    // });

    if (index == 0) {
      // Navigate to the Home with a smooth slide transition
      Navigator.push(
        context,
        pageTransitionBuilder(HomePage()),
      );
    } else if (index == 1) {
      // Navigate to the HistoryPage with a smooth slide transition
      Navigator.push(
        context,
        pageTransitionBuilder(HistoryPage()),
      );
    } else if (index == 2) {
      // Do nothing, already on the Analytics page.
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
      body: const Center(
        child: Text('This is the AnalyticsPage'),
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
                text: ' Home',
                backgroundColor: _selectedIndex == 0
                    ? Colors.grey.shade800 // Use grey when selected
                    : Colors.transparent, // Use transparent when not selected
              ),
              GButton(
                icon: Icons.history_outlined,
                text: ' History',
                backgroundColor: _selectedIndex == 1
                    ? Colors.grey.shade800 // Use grey when selected
                    : Colors.transparent, // Use transparent when not selected
              ),
              GButton(
                icon: Icons.analytics,
                text: ' Analytics',
                backgroundColor: _selectedIndex == 2
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