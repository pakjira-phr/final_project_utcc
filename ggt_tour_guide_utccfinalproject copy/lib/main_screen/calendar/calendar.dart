import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ggt_tour_guide_utccfinalproject/main_screen/calendar/component/add_free_day.dart';

import 'package:flutter/material.dart';
import 'package:ggt_tour_guide_utccfinalproject/constant.dart';
import 'package:ggt_tour_guide_utccfinalproject/widget/popup_dialog.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';
import 'dart:developer' as devtools show log;

// // ignore: depend_on_referenced_packages
// import 'package:intl/intl.dart';

import '../../utillties/custom_page_route.dart';
import 'component/event_details.dart';

var appointmentsmap = [];

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List work = [];
  List free = [];

  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;
  bool loadingSuss = false;
  bool dataMap = false;
  bool isPersonnalInfoCompleate = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference collectionRef = firestore.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: collectionRef.doc(user!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done || loadingSuss) {
          loadingSuss = true;
          if (!dataMap) {
            userData = snapshot.data!.data() as Map<String, dynamic>;
            dataMap = true;
            work = userData!['workDay'];
            free = userData!['freeDay'];
            //check อันนึงจากหน้านึงได้เพราะใส่ดักไว้ก่อนหน้าแล้วถ้ามีข้อมูล = ใส่หมดทั้งหน้า
            if (userData!['firstName'] != '' &&
                userData!['thaiIdCardNo'] != '' &&
                userData!['licenseCardNo'] != '' &&
                userData!['phoneNumber'] != '') {
              isPersonnalInfoCompleate = true;
            }
          }
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                devtools.log('Pressed add');
                if (userData!['banned'] == true) {
                  showPopupDialog(
                      context,
                      'You are banned until ${userData!['bannedUntil']}\nif you have any question please contact\nemail : ggt.admin@gmail.com',
                      'You are banned', [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("OK"))
                  ]);
                } else {
                  if (isPersonnalInfoCompleate) {
                    Navigator.of(context)
                        .push(FadePageRoute(const AddFreeDay()));
                  } else {
                    showPopupDialog(
                        context,
                        'Please complete your personal information and contact information before add free day.',
                        'Complete your information', [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"))
                    ]);
                  }
                }
              },
              backgroundColor: primaryColor,
              child: Icon(
                Icons.add,
                color: primaryTextColor,
              ),
            ),
            backgroundColor: primaryBackgroundColor,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.white.withOpacity(0.1))),
                    height: size.height * 0.64,
                    child: SfCalendarTheme(
                      data: SfCalendarThemeData(
                          headerTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.025),
                          brightness: Brightness.dark,
                          backgroundColor: primaryBackgroundColor,
                          activeDatesTextStyle:
                              TextStyle(color: primaryTextColor),
                          viewHeaderDayTextStyle:
                              TextStyle(color: primaryTextColor),
                          allDayPanelColor: Colors.yellow,
                          cellBorderColor: Colors.white.withOpacity(0.5)),
                      child: SfCalendar(
                          onTap: (calendarTapDetails) {
                            bool check = false;
                            devtools.log(
                                'message ${calendarTapDetails.appointments}');
                            if ((calendarTapDetails.appointments?.length ??
                                    0) !=
                                0) {
                              devtools.log('checking null');
                              devtools.log(calendarTapDetails.date.runtimeType
                                  .toString());
                              for (int i = 0; i < work.length; i++) {
                                DateTime temp = DateTime.parse(work[i]);
                                if (calendarTapDetails.date?.day == temp.day &&
                                    calendarTapDetails.date?.month ==
                                        temp.month &&
                                    calendarTapDetails.date?.year ==
                                        temp.year) {
                                  devtools.log('Yes');
                                  check = true;
                                  Navigator.of(context).push(FadePageRoute(
                                      EventDetails(
                                          isWork: true,
                                          date: calendarTapDetails.date)));
                                }
                              }
                              if (check == false) {
                                Navigator.of(context).push(FadePageRoute(
                                    EventDetails(
                                        isWork: false,
                                        date: calendarTapDetails.date)));
                              }
                            }
                          },
                          showDatePickerButton: true,
                          cellEndPadding: 3,
                          view: CalendarView.month,
                          dataSource: getCalendarDataSource(free, work),
                          monthCellBuilder: monthCellBuilder,
                          todayHighlightColor: Colors.yellow,
                          monthViewSettings: const MonthViewSettings(
                            showTrailingAndLeadingDates: false,
                          )),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 7, right: 7),
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                color: Colors.yellow,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.05,
                          ),
                          Text(
                            'Today',
                            style: TextStyle(color: primaryTextColor),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        children: [
                          Container(
                            height: size.height * 0.03,
                            width: size.width * 0.1,
                            color: primaryColor,
                          ),
                          SizedBox(
                            width: size.width * 0.05,
                          ),
                          Text(
                            'Free day',
                            style: TextStyle(color: primaryTextColor),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        children: [
                          Container(
                            height: size.height * 0.03,
                            width: size.width * 0.1,
                            color: secondaryColor,
                          ),
                          SizedBox(
                            width: size.width * 0.05,
                          ),
                          Text(
                            'Work day',
                            style: TextStyle(color: primaryTextColor),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
        return Container(
          decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   colors: [primaryColor, primaryTextColor, secondaryColor],
              //   stops: const [0, 0.5, 1],
              //   begin: const AlignmentDirectional(1, -1),
              //   end: const AlignmentDirectional(-1, 1),
              // ),
              color: primaryBackgroundColor),
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget monthCellBuilder(BuildContext buildContext, MonthCellDetails details) {
    final Color backgroundColor = getMonthCellBackgroundColor(details);
    Border borderColor = getCellBorderColor(details.date);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: borderColor,
      ),
      child: Center(child: getTextDay(details.date)),
    );
  }

  Color getMonthCellBackgroundColor(MonthCellDetails details) {
    if (details.appointments.isNotEmpty) {
      for (int i = 0; i < appointmentsmap.length; i++) {
        if (details.date == appointmentsmap[i]['date']) {
          if (appointmentsmap[i]['subject'] == 'Work') {
            return secondaryColor;
          }
        }
      }
      return primaryColor;
    }
    return primaryBackgroundColor;
  }

  Border getCellBorderColor(DateTime date) {
    if (date.day == DateTime.now().day &&
        date.month == DateTime.now().month &&
        date.year == DateTime.now().year) {
      return Border.all(color: Colors.white, width: 2);
    }
    return Border.all(color: Colors.white.withOpacity(0.1), width: 0.5);
  }

  Widget getTextDay(DateTime date) {
    if (date.day == DateTime.now().day &&
        date.month == DateTime.now().month &&
        date.year == DateTime.now().year) {
      return Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: Colors.yellow,
        ),
        child: Center(
          child: Text(
            date.day.toString(),
            style: TextStyle(
                color: primaryBackgroundColor, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return Text(
      date.day.toString(),
      style: TextStyle(color: primaryTextColor),
    );
  }
}

AppointmentDataSource getCalendarDataSource(List free, List work) {
  List<Appointment> appointments = <Appointment>[];

  free.sort((a, b) => a.compareTo(b));
  for (int i = 0; i < free.length; i++) {
    appointments.add(Appointment(
      startTime: DateTime.parse(free[i]),
      isAllDay: true,
      endTime: DateTime.parse(free[i]).add(const Duration(minutes: 0)),
      subject: 'Free',
      color: Colors.black.withOpacity(0),
      startTimeZone: '',
      endTimeZone: '',
    ));
  }
  work.sort((a, b) => a.compareTo(b));
  for (int i = 0; i < work.length; i++) {
    appointments.add(Appointment(
      startTime: DateTime.parse(work[i]),
      isAllDay: true,
      endTime: DateTime.parse(work[i]).add(const Duration(minutes: 0)),
      subject: 'Work',
      // color: primaryColor,
      color: Colors.black.withOpacity(0),
      startTimeZone: '',
      endTimeZone: '',
    ));
  }

  appointmentsmap = appointments.map((e) {
    return {'subject': e.subject, 'date': e.startTime};
  }).toList();
  return AppointmentDataSource(appointments);
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
