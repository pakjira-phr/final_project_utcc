import 'package:flutter/material.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/home_screen/home.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/my_trip/my_trips.dart';

import '../constant.dart';

import 'dart:developer' as devtools show log;
import 'account_screen/account.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  // const MainScreen({super.key});
  MainScreen({
    super.key,
    required this.index,
  });
  int index;

  @override
  // ignore: no_logic_in_create_state
  State<MainScreen> createState() => _MainScreenState(index: index);
}

class _MainScreenState extends State<MainScreen> {
  _MainScreenState({
    required this.index,
  });
  int index;
  int selectedIndex = 0;

  @override
  void initState() {
    selectedIndex = index;
    super.initState();
  }

  final List<Widget> widgetOptions = <Widget>[
    const Home(),
    const MyTrips(),
    const Account(),
  ];

  void onItemTapped(int index) {
    devtools.log('index : $index');
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetOptions.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: secondaryBackgroundColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center),
            label: 'My Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_rounded),
            label: 'Account',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: tertiaryColor,
        unselectedItemColor: deactivatedText,
        onTap: onItemTapped,
      ),
    );
  }
}
