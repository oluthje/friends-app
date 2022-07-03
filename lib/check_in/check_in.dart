import 'package:friends/constants.dart' as constants;

/*
Calculates:

Calculates isCheckedIn:
  check_in_base_date, check_in_dates and check_in_deadlines => to calculate
  if friend has been checked in with.
 
*/
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckInCalculator {
  // finds difference in duration between two dates
  Duration _dateDiff(DateTime date1, DateTime date2) {
    return date1.difference(date2);
  }

  // find latest_date from dates
  DateTime _latestDate(List<Timestamp> dates) {
    DateTime now = DateTime.now();
    Timestamp latest = dates[0];

    for (Timestamp date in dates) {
      if (_dateDiff(now, date.toDate()) < _dateDiff(now, latest.toDate())) {
        latest = date;
      }
    }

    return latest.toDate();
  }

  /*
  Deadline is calculated by:
  days = ceiling(daysFromBasedate / daysInInterval) * daysInInterval
  deadline = baseDate + days
  */
  DateTime deadline(
      Timestamp baseDate, List<Timestamp> dates, String interval) {
    int daysInInterval = constants.checkinIntervalDays[interval];

    int daysFromBasedate = DateTime.now().difference(baseDate.toDate()).inDays;

    int days =
        (daysFromBasedate / Duration(days: daysInInterval).inDays).ceil();
    if (days == 0) {
      days = 1;
    }
    days = days * daysInInterval;

    return baseDate.toDate().add(Duration(days: days));
  }

  bool isCheckedIn(Timestamp baseDate, List<Timestamp> dates, String interval) {
    if (dates.isEmpty) return false;

    DateTime latestCheckIn = _latestDate(dates);
    DateTime checkInDeadline = deadline(baseDate, dates, interval);
    DateTime checkInStartDate = checkInDeadline
        .subtract(Duration(days: constants.checkinIntervalDays[interval]));

    // If latestCheckIn is between checkInStartDate and checkInDeadline,
    // then return true. Else return false

    final checkedIn = latestCheckIn.isAfter(checkInStartDate) &&
            latestCheckIn.isBefore(checkInDeadline) ||
        latestCheckIn == checkInDeadline;

    return checkedIn;
  }
}

// Step 1: friend adds a check in
//  friend now has a check_in dict, with base_date, interval and dates

// How to calculate check in deadline.
// (deadline is days from today) deadline = base_date + interval days



// base date = 0
// interval = 4
// today = 27

// deadline = (today - basedate) / interval