import 'package:intl/intl.dart';
import 'package:moment_dart/moment_dart.dart';

class FormatDateUtils {
  static String formatDateTime(DateTime dateTime) {
    return dateTime.toMoment().calendar().split(" ")[0];
  }

  static String formatToCalendar(DateTime inputDate) {
    DateTime currentDate = DateTime.now();
    // print(inputDate.weekday != currentDate.weekday &&
    //     inputDate.week == currentDate.week &&
    //     inputDate.difference(currentDate).inDays > 0);
    if (isSameDay(inputDate, currentDate)) {
      return 'Hoy';
    } else if (isSameDay(
      inputDate,
      currentDate.subtract(const Duration(days: 1)),
    )) {
      return 'Ayer';
    } else if (isSameDay(inputDate, currentDate.add(const Duration(days: 1)))) {
      return 'Mañana';
    } else if (inputDate.weekday != currentDate.weekday &&
        inputDate.week == currentDate.week &&
        inputDate.difference(currentDate).inDays > 0) {
      return 'Este ${getWeekdayName(inputDate.weekday)}';
    } else if (inputDate.isBefore(currentDate)) {
      if (inputDate.difference(currentDate).inDays.abs() <= 7) {
        return 'Pasado ${getWeekdayName(inputDate.weekday)}';
      } else {
        return getFormattedDate(inputDate);
      }
    } else {
      if (inputDate.difference(currentDate).inDays <= 7) {
        return 'Proximo ${getWeekdayName(inputDate.weekday)}';
      } else {
        return getFormattedDate(inputDate);
      }
    }
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static String getWeekdayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Lunes';
      case DateTime.tuesday:
        return 'Martes';
      case DateTime.wednesday:
        return 'Miercoles';
      case DateTime.thursday:
        return 'Jueves';
      case DateTime.friday:
        return 'Viernes';
      case DateTime.saturday:
        return 'Sabado';
      case DateTime.sunday:
        return 'Domingo';
      default:
        return '';
    }
  }

  static String getFormattedDate(DateTime date) {
    DateFormat formatter = DateFormat('MMM dd');
    return '${getWeekdayName(date.weekday)}, ${formatter.format(date)}';
  }
}

List<String> availableDates = [
  "2:00pm",
  "2:30pm",
  "3:00pm",
  "3:30pm",
  "4:00pm",
  "4:30pm",
  "5:00pm",
  "5:30pm",
];
