// file to keep all important constants, like firebase field names

// Firebase collections
const friends = 'friends';
const groups = 'groups';

// Firebase field names
const friendIds = 'friend_ids';
const name = 'name';
const userId = 'user_id';
const friendIntimacy = 'friend_intimacy';
const favorited = 'favorited';
const checkInInterval = 'check_in_interval';
const checkInBaseDate = 'check_in_base_date';
const checkInDates = 'check_in_dates';

// Other
const numIntimacies = 4;

enum Intimacies { good, rising, newFriend, acquaintance }

const Map<String, String> intimacyNames = {
  '0': 'Good',
  '1': 'Moderate',
  '2': 'New',
  '3': 'Acquainted',
};

enum CheckinIntervals { daily, biweekly, weekly, monthly, yearly }

const List<String> checkinIntervalNames = [
  'None',
  'Daily',
  'Biweekly',
  'Weekly',
  'Monthly',
  'Yearly'
];

Map checkinIntervalDays = {
  checkinIntervalNames[0]: 0,
  checkinIntervalNames[1]: 1,
  checkinIntervalNames[2]: 3,
  checkinIntervalNames[3]: 7,
  checkinIntervalNames[4]: 30,
  checkinIntervalNames[5]: 365,
};

dynamic getField(doc, String field, defualt) {
  return doc.data().toString().contains(field) ? doc.get(field) : defualt;
}
