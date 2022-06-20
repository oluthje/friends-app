import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

import 'package:friends/constants.dart' as constants;
import 'package:friends/widgets/friend_modal.dart';

class FriendsScreen extends StatefulWidget {
  final List friends;

  const FriendsScreen({
    Key? key,
    required this.friends,
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

  void _addFriend(String text, int intimacy) {
    db.collection(collectionPath).add({
      constants.name: text,
      constants.userId: user.uid,
      constants.friendIntimacy: intimacy,
    });
    textFieldController.clear();
  }

  void _editFriend(String id, String name, int intimacy) {
    final doc = db.collection(collectionPath).doc(id);
    doc.update({
      constants.name: name,
      constants.friendIntimacy: intimacy,
    }).then((value) => null);
  }

  void _deleteFriend(String id) {
    final doc = db.collection(collectionPath).doc(id);
    doc.delete().then((doc) => null,
      onError: (e) => print("Error updating document $e"),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
                padding: const EdgeInsets.only(top: 16.0),
                itemCount: widget.friends.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot doc = widget.friends[index];
                  final name = doc[constants.name];
                  int intimacy = doc.data().toString().contains(constants.friendIntimacy)
                      ? doc.get(constants.friendIntimacy) : constants.Intimacies.newFriend.index;

                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _deleteFriend(doc.id);
                    },
                    child: ListTile(
                      title: Text(name),
                      onTap: () => showModalBottomSheet<void>(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return FriendModal(
                            name: name,
                            id: doc.id,
                            intimacy: intimacy,
                            editFriend: _editFriend,
                            addFriend: _addFriend,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
        transform: Matrix4.translationValues(0, visible ? 0 : 100, 0),
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
              ),
              builder: (BuildContext context) {
                return FriendModal(
                  name: '',
                  id: '',
                  intimacy: constants.Intimacies.newFriend.index,
                  editFriend: _editFriend,
                  addFriend: _addFriend,
                );
              },
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      )
    );
  }
}