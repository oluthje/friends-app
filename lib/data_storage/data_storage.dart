import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friends/constants.dart' as constants;

class DataStorage {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  dynamic getField(doc, field, defualt) {
    return doc.data().toString().contains(field) ? doc.get(field) : defualt;
  }
}

class FriendsStorage extends DataStorage {
  final collectionPath = 'friends';

  void addFriend(String text, int intimacy, String checkinInterval) {
    db.collection(collectionPath).add({
      constants.name: text,
      constants.userId: user.uid,
      constants.friendIntimacy: intimacy,
      constants.checkInInterval: checkinInterval,
      constants.checkInBaseDate: Timestamp.now(),
      constants.checkInDates: [],
    });
  }

  void editFriend(
      String id, String name, int intimacy, String checkinInterval) {
    final doc = db.collection(collectionPath).doc(id);

    doc.update({
      constants.name: name,
      constants.friendIntimacy: intimacy,
      constants.checkInInterval: checkinInterval,
    }).then((value) => null);
  }

  void deleteFriend(String id) {
    final doc = db.collection(collectionPath).doc(id);
    doc.delete().then((value) => null);
  }
}

class GroupsStorage extends DataStorage {
  final collectionPath = 'groups';

  void addGroup(String name, List friendIDs) {
    db.collection(collectionPath).add({
      constants.name: name,
      constants.friendIds: friendIDs,
      constants.userId: user.uid,
      constants.favorited: false,
    });
  }

  void editGroup(String id, String name, List selectedFriends, bool favorited) {
    final doc = db.collection(collectionPath).doc(id);
    doc.update({
      constants.name: name,
      constants.friendIds: selectedFriends,
      constants.favorited: favorited,
    }).then((value) => null);
  }

  void deleteGroup(String id) {
    final doc = db.collection(collectionPath).doc(id);
    doc.delete().then((value) => null);
  }
}

class CheckInStorage extends DataStorage {
  final collectionPath = 'friends';

  void addCheckInDate(String friendId, DateTime date) {
    final doc = db.collection(collectionPath).doc(friendId);
    doc.update({
      constants.checkInDates: FieldValue.arrayUnion([date]),
    }).then((value) => null);
  }

  void removeCheckInDate(String friendId, Timestamp date) {
    final doc = db.collection(collectionPath).doc(friendId);
    doc.update({
      constants.checkInDates: FieldValue.arrayRemove([date]),
    }).then((value) => null);
  }
}
