import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:friends/widgets/friends/friends_list_tile.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:friends/constants.dart' as constants;

class FriendsList extends StatelessWidget {
  final List friends;
  final List groups;
  final Function deleteFriend;
  final Function showFriendModal;

  const FriendsList({
    Key? key,
    required this.friends,
    required this.groups,
    required this.deleteFriend,
    required this.showFriendModal,
  }) : super(key: key);

  dynamic getField(doc, field, defualt) {
    return doc.data().toString().contains(field) ? doc.get(field) : defualt;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GroupedListView<dynamic, String>(
        elements: friends,
        groupBy: (element) {
          int intimacy = getField(element, constants.friendIntimacy,
              constants.Intimacies.newFriend.index);
          return constants.Intimacies.values[intimacy].index.toString();
        },
        groupSeparatorBuilder: (String groupValue) {
          var groupName = constants.intimacyNames[groupValue] ?? 'Unknown';
          return Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              groupName,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          );
        },
        itemBuilder: (context, dynamic element) {
          final DocumentSnapshot doc = element;
          final name = doc[constants.name];
          final intimacy = getField(doc, constants.friendIntimacy,
              constants.Intimacies.newFriend.index);
          final checkinInterval = getField(doc, constants.checkInInterval,
              constants.checkinIntervalNames[0]);

          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              deleteFriend(doc.id);
            },
            child: Card(
              child: FriendsListTile(
                name: name,
                checkinInterval: checkinInterval,
                onTap: () => showFriendModal(
                  context,
                  name,
                  doc.id,
                  intimacy,
                  checkinInterval,
                  groups,
                ),
              ),
            ),
          );
        },
        itemComparator: (item1, item2) =>
            item1[constants.name].compareTo(item2[constants.name]),
        groupComparator: (group1, group2) => group1.compareTo(group2),
      ),
    );
  }
}
