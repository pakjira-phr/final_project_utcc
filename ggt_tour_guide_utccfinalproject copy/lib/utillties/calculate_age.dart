// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

int calculateAge(String birthDateString) {
  // devtools.log(tourguideAllData[tourguideDataId[0]]['birthDay']
  //     .runtimeType
  //     .toString());
  // devtools.log('${DateTime.now()}');
  var inputFormat = DateFormat('dd-MM-yyyy');
  var date1 = inputFormat.parse(
      // tourguideAllData[tourguideDataId[0]]['birthDay']
      birthDateString);

  var outputFormat = DateFormat('yyyy-MM-dd');
  DateTime birthDate = DateTime.parse(outputFormat.format(date1));
  // devtools.log(birthDate.toString());

  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}
