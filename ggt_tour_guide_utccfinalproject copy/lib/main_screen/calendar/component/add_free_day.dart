import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tour_guide_utccfinalproject/main_screen/main_screen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../constant.dart';
import '../../../utillties/custom_page_route.dart';
import '../../../utillties/get_message.dart';
import '../../../widget/popup_dialog.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'dart:developer' as devtools show log;

import '../../../widget/show_error_dialog.dart';

var appointmentsmap = [];

class AddFreeDay extends StatefulWidget {
  const AddFreeDay({super.key});

  @override
  State<AddFreeDay> createState() => _AddFreeDayState();
}

class _AddFreeDayState extends State<AddFreeDay> {
  List work = [];
  List free = [];
  List selectedDay = [];
  ValueNotifier<bool> selectedColors = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Map<String, dynamic>? userData;
    bool loadingSuss = false;
    bool dataMap = false;
    CollectionReference collectionRef = firestore.collection('users');
    Size size = MediaQuery.of(context).size;
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
            
          }
          return Scaffold(
            backgroundColor: primaryBackgroundColor,
            appBar: AppBar(
              toolbarHeight: size.height * 0.06,
              backgroundColor: primaryBackgroundColor,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(
                  Icons.close,
                  color: secondaryBackgroundColor,
                  size: 30,
                ),
                onPressed: () {
                  // FocusScope.of(context).unfocus();
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: Icon(
                      Icons.check,
                      color: secondaryBackgroundColor,
                      size: 30,
                    ),
                    onPressed: () {
                      List saveData = [];
                      selectedDay.sort((a, b) => a.compareTo(b));
                      devtools.log(selectedDay.runtimeType.toString());
                      for (int i = 0; i < selectedDay.length; i++) {
                        devtools.log(DateFormat('yyyy-MM-dd')
                            .format(selectedDay[i])
                            .toString());
                        saveData.add(DateFormat('yyyy-MM-dd')
                            .format(selectedDay[i])
                            .toString());
                      }
                      devtools.log('saveData : ${saveData.length}');
                      for (int i = 0; i < free.length; i++) {
                        saveData.add(free[i]);
                      }
                      devtools.log('free : ${free.length}');
                      devtools.log('saveData update : ${saveData.length}');
                      showPopupDialog(
                          context, "Are you sure to save this.", 'Add', [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel")),
                        TextButton(
                            onPressed: () {
                              try {
                                firestore
                                    .collection('users')
                                    .doc(user.uid)
                                    .update({
                                  'freeDay': saveData,
                                });

                                devtools.log('update sussces');
                                Navigator.of(context).pushAndRemoveUntil(
                                    FadePageRoute(MainScreen(index: 1)),
                                    (Route<dynamic> route) => false);
                              } on FirebaseAuthException catch (e) {
                                devtools.log(e.toString());
                                devtools.log(getMessageFromErrorCode(e.code));
                                showErrorDialog(context,
                                    getMessageFromErrorCode(e.code).toString());

                                // handle if reauthenticatation was not successful
                              } catch (e) {
                                devtools.log(e.toString());
                                showErrorDialog(context, e.toString());
                              }
                            },
                            child: const Text("Save"))
                      ]);
                    },
                  ),
                )
              ],
              elevation: 0,
            ),
            body: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 20, top: 20),
              child: Column(
                children: [
                  Text(
                    "Select free day",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                        fontSize: 30),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.white.withOpacity(0.1))),
                    height: size.height * 0.64,
                    child: SfCalendarTheme(
                      data: SfCalendarThemeData(
                          brightness: Brightness.dark,
                          backgroundColor: primaryBackgroundColor,
                          activeDatesTextStyle:
                              TextStyle(color: primaryTextColor),
                          viewHeaderDayTextStyle:
                              TextStyle(color: primaryTextColor),
                          allDayPanelColor: Colors.yellow,
                          cellBorderColor: Colors.white.withOpacity(0.1)),
                      child: ValueListenableBuilder(
                        valueListenable: selectedColors,
                        builder: (context, value, child) => SfCalendar(
                            onTap: (calendarTapDetails) {
                              if ((calendarTapDetails.appointments?.length ??
                                      0) !=
                                  0) {
                                devtools.log('checking null');
                                devtools.log(selectedDay.toString());
                                // Navigator.of(context)
                                //     .push(FadePageRoute(const EventDetail()));
                              } else {
                                // setState(() {
                                //   if (selectedDay
                                //       .contains(calendarTapDetails.date)) {
                                //     selectedDay.remove(calendarTapDetails.date);
                                //   } else {
                                //     selectedDay.add(calendarTapDetails.date);
                                //   }
                                // });

                                if (selectedDay
                                    .contains(calendarTapDetails.date)) {
                                  selectedDay.remove(calendarTapDetails.date);
                                  selectedColors.value = !selectedColors.value;
                                  selectedColors.value = false;
                                } else {
                                  selectedDay.add(calendarTapDetails.date);
                                  selectedColors.value = !selectedColors.value;
                                  selectedColors.value = true;
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
                  )
                ],
              ),
            )),
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
      return Colors.grey;
    } else {
      devtools.log(selectedDay.length.toString());
      DateTime date = details.date;
      for (int i = 0; i < selectedDay.length; i++) {
        if (date.day == selectedDay[i].day &&
            date.month == selectedDay[i].month &&
            date.year == selectedDay[i].year) {
          return primaryColor;
          // if (selectedColors.value) {
          //   return primaryColor;
          // } else {
          //   return primaryBackgroundColor;
          // }
        }
      }
      return primaryBackgroundColor;
    }
  }

  Border getCellBorderColor(DateTime date) {
    // if (date.day == DateTime.now().day &&
    //     date.month == DateTime.now().month &&
    //     date.year == DateTime.now().year) {
    //   return Border.all(color: Colors.white, width: 2);
    // }
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
