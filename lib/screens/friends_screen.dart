import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

import 'package:friends/constants.dart' as constants;
import 'package:friends/widgets//friends/friend_modal.dart';
import 'package:friends/widgets/friends/friends_list.dart';

class FriendsScreen extends StatefulWidget {
  final List initFriends;

  const FriendsScreen({
    Key? key,
    required this.initFriends,
  }) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreen();
}

class _FriendsScreen extends State<FriendsScreen> {
  final db = FirebaseFirestore.instance;
  final collectionPath = 'friends';
  final user = FirebaseAuth.instance.currentUser!;
  final textFieldController = TextEditingController();
  bool visible = true;

  void _addFriend(String text, int intimacy, String checkinInterval) {
    db.collection(collectionPath).add({
      constants.name: text,
      constants.userId: user.uid,
      constants.friendIntimacy: intimacy,
      constants.checkinInterval: checkinInterval,
    });
    textFieldController.clear();
  }

  void _editFriend(
      String id, String name, int intimacy, String checkinInterval) {
    final doc = db.collection(collectionPath).doc(id);
    doc.update({
      constants.name: name,
      constants.friendIntimacy: intimacy,
      constants.checkinInterval: checkinInterval,
    }).then((value) => null);
  }

  void _deleteFriend(String id) {
    final doc = db.collection(collectionPath).doc(id);
    doc.delete().then(
          (doc) => null,
          onError: (e) => print("Error updating document $e"),
        );
  }

  dynamic noFriendsWarning(noFriends) {
    if (noFriends) {
      return const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text('No friends yet, click the button below to add some!'),
      );
    }
    return const Padding(padding: EdgeInsets.zero);
  }

  dynamic showFriendModal(BuildContext context, String name, String id,
      int intimacy, String checkinInterval) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return FriendModal(
          name: name,
          id: id,
          intimacy: intimacy,
          editFriend: _editFriend,
          addFriend: _addFriend,
          initCheckinInterval: checkinInterval,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> friends = db
        .collection(constants.friends)
        .where(constants.userId, isEqualTo: user.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Friends')),
      body: StreamBuilder<QuerySnapshot>(
        stream: friends,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          var friendsDocs = widget.initFriends;

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState != ConnectionState.waiting) {
            friendsDocs = snapshot.requireData.docs;
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              noFriendsWarning(friendsDocs.isEmpty),
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
                    deleteFriend: _deleteFriend,
                    friends: friendsDocs,
                    showFriendModal: showFriendModal,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
        transform: Matrix4.translationValues(0, visible ? 0 : 110, 0),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () => showFriendModal(
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
