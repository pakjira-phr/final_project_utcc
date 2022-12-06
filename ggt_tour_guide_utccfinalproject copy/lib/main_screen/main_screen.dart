import 'package:flutter/material.dart';
import 'package:ggt_tour_guide_utccfinalproject/main_screen/earnings/earnings.dart';

import '../constant.dart';

import 'dart:developer' as devtools show log;
import 'account_screen/account.dart';
import 'home/home.dart';
import 'calendar/calendar.dart';
import 'jobs/jobs.dart';

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
    const Calendar(),
    const Jobs(),
    const Earnings(),
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
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: primaryBackgroundColor,
          ),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                border:
                    Border(top: BorderSide(color: Colors.white, width: 0.1))),
            child: BottomNavigationBar(
              showUnselectedLabels: true,
              backgroundColor: primaryBackgroundColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: selectedIndex == 0
                      ? const Icon(Icons.home_rounded)
                      : const Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: selectedIndex == 1
                      ? const Icon(Icons.calendar_month)
                      : const Icon(Icons.calendar_month_outlined),
                  label: 'Calendar',
                ),
                BottomNavigationBarItem(
                  icon: selectedIndex == 2
                      ? const Icon(Icons.work)
                      : const Icon(Icons.work_outline),
                  label: 'Jobs',
                ),
                BottomNavigationBarItem(
                  icon: selectedIndex == 3
                      ? const Icon(Icons.attach_money_rounded)
                      : const Icon(Icons.attach_money_rounded),
                  label: 'Earnings',
                ),
                BottomNavigationBarItem(
                  icon: selectedIndex == 4
                      ? const Icon(Icons.account_box_rounded)
                      : const Icon(Icons.account_box_outlined),
                  label: 'Account',
                ),
              ],
              currentIndex: selectedIndex,
              selectedItemColor: primaryColorIcon,
              unselectedItemColor: Colors.white,
              onTap: onItemTapped,
            ),
          ),
        ));
  }
}
