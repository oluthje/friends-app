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

// Other
const numIntimacies = 4;

enum Intimacies { good, rising, newFriend, acquaintance }

const Map<String, String> intimacyNames = {
  '0': 'Good',
  '1': 'Rising',
  '2': 'New',
  '3': 'Acquainted',
};
