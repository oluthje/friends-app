import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:friends/constants.dart' as constants;
import 'package:friends/widgets/friends/friends_list.dart';
import '../../data_storage/data_storage.dart';

class FriendsScreen extends StatefulWidget {
  final List friends;
  final Function showFriendModal;

  const FriendsScreen({
    Key? key,
    required this.friends,
    required this.showFriendModal,
  }) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreen();
}

class _FriendsScreen extends State<FriendsScreen> {
  final db = FriendsStorage();
  bool visible = true;

  dynamic noFriendsWarning(noFriends) {
    if (noFriends) {
      return const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text('No friends yet, click the button below to add some!'),
      );
    }
    return const Padding(padding: EdgeInsets.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Friends')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          noFriendsWarning(widget.friends.isEmpty),
          NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              final ScrollDirection direction = notification.direction;
              setState(() {
                if (direction == ScrollDirection.reverse) {
                  visible = false;
                } else if (direction == ScrollDirection.forward) {
                  visible = true;
                }
              });
              return true;
            },
            child: Expanded(
              child: FriendsList(
                deleteFriend: db.deleteFriend,
                friends: widget.friends,
                showFriendModal: widget.showFriendModal,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
        transform: Matrix4.translationValues(0, visible ? 0 : 110, 0),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () => widget.showFriendModal(
            context,
            '',
            '',
            constants.Intimacies.newFriend.index,
            constants.checkinIntervalNames[0],
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
