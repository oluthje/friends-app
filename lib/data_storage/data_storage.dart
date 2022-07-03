import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friends/constants.dart' as constants;

class DataStorage {
  final db = FirebaseFirestore.instance;

  dynamic getField(doc, field, defualt) {
    return doc.data().toString().contains(field) ? doc.get(field) : defualt;
  }
}

// class FriendsStorage

// class GroupStorage

class CheckInStorage extends DataStorage {
  final collectionPath = 'friends';

  void addCheckInDate(String friendId, DateTime date) {
    final doc = db.collection(collectionPath).doc(friendId);
    doc.update({
      constants.checkInDates: FieldValue.arrayUnion([date]),
    }).then((value) => null);
  }

  void removeCheckInDate(String friendId, Timestamp date) {
    print('remove: $date');
    final doc = db.collection(collectionPath).doc(friendId);
    doc.update({
      constants.checkInDates: FieldValue.arrayRemove([date]),
    }).then((value) => null);
  }
}
