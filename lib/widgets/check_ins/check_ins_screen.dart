import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

import 'package:friends/constants.dart' as constants;
// import 'package:friends/widgets//friends/friend_modal.dart';
// import 'package:friends/widgets/friends/friends_list.dart';
import 'package:friends/widgets/friends/friends_list_tile.dart';

class CheckInsScreen extends StatefulWidget {
  final List friends;

  const CheckInsScreen({
    Key? key,
    required this.friends,
  }) : super(key: key);

  @override
  State<CheckInsScreen> createState() => _CheckInsScreen();
}

class _CheckInsScreen extends State<CheckInsScreen> {
  final textFieldController = TextEditingController();
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
      appBar: AppBar(title: const Text('Check Ins')),
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
              child: ListView.builder(
                itemBuilder: (BuildContext context, index) {
                  final name = widget.friends[index][constants.name];

                  return FriendsListTile(name: name);
                },
                itemCount: widget.friends.length,
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: AnimatedContainer(
      //   duration: const Duration(milliseconds: 250),
      //   curve: Curves.fastOutSlowIn,
      //   transform: Matrix4.translationValues(0, visible ? 0 : 110, 0),
      //   child: FloatingActionButton(
      //     backgroundColor: Colors.blue,
      //     onPressed: () => showFriendModal(
      //       context,
      //       '',
      //       '',
      //       constants.Intimacies.newFriend.index,
      //       constants.checkinIntervalNames[0],
      //     ),
      //     child: const Icon(Icons.add),
      //   ),
      // ),
    );
  }
}
