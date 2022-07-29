import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friends/constants.dart' as constants;
import 'package:friends/data_managers/data_manager.dart';
import 'package:friends/data_managers/groups_manager.dart';

class FriendsManager extends DataManager {
  final collectionPath = 'friends';

  void addFriend(String name, int intimacy, String interval,
      List selectedGroupIds, List groups) {
    db.collection(collectionPath).add({
      constants.name: name,
      constants.userId: user.uid,
      constants.friendIntimacy: intimacy,
      constants.checkInInterval: interval,
      constants.checkInBaseDate: Timestamp.now(),
      constants.checkInDates: [],
    }).then((doc) => _updateFriendsGroups(doc.id, selectedGroupIds, groups));
  }

  void editFriend(String id, String name, int intimacy, String interval,
      List selectedGroupIds, List groups) {
    final doc = db.collection(collectionPath).doc(id);

    doc.update({
      constants.name: name,
      constants.friendIntimacy: intimacy,
      constants.checkInInterval: interval,
    }).then((value) => null);

    _updateFriendsGroups(id, selectedGroupIds, groups);
  }

  void deleteFriend(String id) {
    final doc = db.collection(collectionPath).doc(id);
    doc.delete().then((value) => null);
  }

  void _updateFriendsGroups(String id, List selectedGroupIds, List groups) {
    final groupsDb = GroupsManager();
    for (dynamic group in groups) {
      String groupId = group.id;
      // if groupId in selectedGroupIds, then add friend to group
      // else remove friend from group
      if (selectedGroupIds.contains(groupId)) {
        groupsDb.addFriendToGroup(groupId, id);
      } else {
        groupsDb.removeFriendFromGroup(groupId, id);
      }
    }
  }
}

// perhaps remove constants, and keep getters setters in data manager files.
// instead of friend[constants.name], do FriendsManager.getName(friend);