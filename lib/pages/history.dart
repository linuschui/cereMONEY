import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:money_manager/pages/home_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        toolbarHeight: 60,
        title: Row(
          children: [
            const Text('cereMONEY'),
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
        child: Text('This is the HistoryPage'),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            backgroundColor: Colors.black,
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
                icon: Icons.settings,
                text: ' Settings',
                backgroundColor: _selectedIndex == 2
                    ? Colors.grey.shade800 // Use grey when selected
                    : Colors.transparent, // Use transparent when not selected
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });

              // Navigate to the corresponding page when a button is pressed
              if (index == 0) {
                // Navigation for the Home tab (index 0)
                // Add your navigation code here, for example:
                // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HomePage(), // Navigate to the HistoryPage
                  ),
                );
              } else if (index == 1) {
                // Navigation for the History tab (index 1) - Current page, no need for navigation.
              } else if (index == 2) {
                // Navigation for the Settings tab (index 2)
                // Add your navigation code here, for example:
                // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
              }
            },
          ),
        ),
      ),
    );
  }
}
