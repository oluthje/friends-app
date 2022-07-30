import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friends/constants.dart' as constants;
import 'package:friends/data_managers/data_manager.dart';

class CheckInManager extends DataManager {
  final collectionPath = 'friends';

  void addCheckInDate(String friendId, DateTime date) {
    return;
    final doc = db.collection(collectionPath).doc(friendId);
    doc.update({
      constants.checkInDates: FieldValue.arrayUnion([date]),
    }).then((value) => null);
  }

  void removeCheckInDate(String friendId, Timestamp date) {
    return;
    final doc = db.collection(collectionPath).doc(friendId);
    doc.update({
      constants.checkInDates: FieldValue.arrayRemove([date]),
    }).then((value) => null);
  }
}
