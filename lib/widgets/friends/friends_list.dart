import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:friends/widgets/friends/friends_list_tile.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:friends/constants.dart' as constants;
import 'package:friends/widgets/friends/friend_modal.dart';

class FriendsList extends StatelessWidget {
  final List friends;
  final Function addFriend;
  final Function editFriend;
  final Function deleteFriend;

  const FriendsList({
    Key? key,
    required this.friends,
    required this.addFriend,
    required this.editFriend,
    required this.deleteFriend,
  }) : super(key: key);

  int getIntimacy(element) {
    return element.data().toString().contains(constants.friendIntimacy)
        ? element.get(constants.friendIntimacy)
        : constants.Intimacies.newFriend.index;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GroupedListView<dynamic, String>(
        elements: friends,
        groupBy: (element) {
          int intimacy = getIntimacy(element);
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
          int intimacy = getIntimacy(element);

          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              deleteFriend(doc.id);
            },
            child: Card(
              child: FriendsListTile(
                name: name,
                onTap: () => showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return FriendModal(
                      name: name,
                      id: doc.id,
                      intimacy: intimacy,
                      editFriend: editFriend,
                      addFriend: addFriend,
                    );
                  },
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
