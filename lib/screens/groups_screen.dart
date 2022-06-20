import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

import 'package:friends/widgets/modal_add_item.dart';
import 'package:friends/widgets/item_selection.dart';
import 'package:friends/constants.dart' as constants;

class GroupsScreen extends StatefulWidget {
  final List friends;
  final List groups;

  const GroupsScreen({
    Key? key,
    required this.friends,
    required this.groups,
  }) : super(key: key);

  @override
  State<GroupsScreen> createState() => _GroupsScreen();
}

class _GroupsScreen extends State<GroupsScreen> {
  final db = FirebaseFirestore.instance;
  final collectionPath = 'groups';
  final user = FirebaseAuth.instance.currentUser!;
  final textFieldController = TextEditingController();
  bool visible = true;

  void _addGroup(String name, List friendIDs) {
    db.collection(collectionPath).add({
      constants.name: name,
      constants.friendIds: friendIDs,
      constants.userId: user.uid,
    });
    textFieldController.clear();
  }

  void _editGroup(String id, String name, List selectedFriends) {
    final doc = db.collection(collectionPath).doc(id);
    doc.update({constants.name: name, constants.friendIds: selectedFriends}).then((value) => null);
  }

  void _deleteGroup(String id) {
    final doc = db.collection(collectionPath).doc(id);
    doc.delete().then((doc) => null,
      onError: (e) => print("Error updating document $e"));

  }

  ModalAddItem addItemModal(name, doc, selectedFriendIDs) {
    List selectedIndices = [];

    // get the indices of all selected friends
    for (int i = 0; i < widget.friends.length; i++) {
      if (selectedFriendIDs.contains(widget.friends[i].id)) {
        selectedIndices.add(i);
      }
    }

    return ModalAddItem(
      name: name,
      onSubmit: (newName) {
        // convert item indices into list of friend IDs
        List friendIDs = [];
        for (int i = 0; i < selectedIndices.length; i++) {
          final selectedIndex = selectedIndices[i];
          friendIDs.add(widget.friends[selectedIndex].id);
        }

        if (doc == '') {
          _addGroup(newName, friendIDs);
        } else {
          _editGroup(doc.id, newName, friendIDs);
        }
      },
      child: ItemSelection(
        items: widget.friends,
        selectedItems: selectedIndices,
        onUpdated: (items) {
          selectedIndices = items;
        },
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final groups = widget.groups;

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
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final doc = groups[index];
                  final name = doc[constants.name];
                  final selectedFriendIDs = doc[constants.friendIds];

                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _deleteGroup(doc.id);
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
                          return addItemModal(name, doc, selectedFriendIDs);
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
                return addItemModal('', '', []);
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