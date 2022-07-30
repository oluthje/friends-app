import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friends/constants.dart' as constants;
import 'package:friends/data_managers/data_manager.dart';

class GroupsManager extends DataManager {
  final collectionPath = 'groups';

  void addGroup(String name, List friendIDs) {
    return;
    db.collection(collectionPath).add({
      constants.name: name,
      constants.friendIds: friendIDs,
      constants.userId: user.uid,
      constants.favorited: false,
    });
  }

  void editGroup(String id, String name, List selectedFriends, bool favorited) {
    return;
    final doc = db.collection(collectionPath).doc(id);
    doc.update({
      constants.name: name,
      constants.friendIds: selectedFriends,
      constants.favorited: favorited,
    }).then((value) => null);
  }

  // add friend if possible
  void addFriendToGroup(String groupId, String friendId) {
    return;
    final doc = db.collection(collectionPath).doc(groupId);
    doc.update({
      constants.friendIds: FieldValue.arrayUnion([friendId]),
    }).then((value) => null);
  }

  // remove friend if possible
  void removeFriendFromGroup(String groupId, String friendId) {
    return;
    final doc = db.collection(collectionPath).doc(groupId);
    doc.update({
      constants.friendIds: FieldValue.arrayRemove([friendId]),
    }).then((value) => null);
  }

  void deleteGroup(String id) {
    return;
    final doc = db.collection(collectionPath).doc(id);
    doc.delete().then((value) => null);
  }
}
