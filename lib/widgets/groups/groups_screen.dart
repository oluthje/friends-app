import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:friends/widgets/groups/group_list_tile.dart';

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
      constants.favorited: false,
    });
    textFieldController.clear();
  }

  void _editGroup(
      String id, String name, List selectedFriends, bool favorited) {
    final doc = db.collection(collectionPath).doc(id);
    doc.update({
      constants.name: name,
      constants.friendIds: selectedFriends,
      constants.favorited: favorited,
    }).then((value) => null);
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
          _editGroup(doc.id, newName, friendIDs, false);
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

  dynamic noGroupsWarning(noGroups) {
    if (noGroups) {
      return const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text('No groups yet, click the button below to add some!'),
      );
    }
    return const Padding(padding: EdgeInsets.zero);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    dynamic getField(doc, field, defualt) {
      return doc.data().toString().contains(field) ? doc.get(field) : defualt;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Groups')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          noGroupsWarning(widget.groups.isEmpty),
          NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              final ScrollDirection direction = notification.direction;
              setState(
                () {
                  if (direction == ScrollDirection.reverse) {
                    visible = false;
                  } else if (direction == ScrollDirection.forward) {
                    visible = true;
                  }
                },
              );
              return true;
            },
            child: Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 16.0),
                itemCount: widget.groups.length,
                itemBuilder: (context, index) {
                  final doc = widget.groups[index];
                  final String name = doc[constants.name];
                  final bool favorited =
                      getField(doc, constants.favorited, false);
                  final List selectedFriendIDs = doc[constants.friendIds];

                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _deleteGroup(doc.id);
                    },
                    child: GroupListTile(
                      name: name,
                      favorited: favorited,
                      onFavoritedToggle: () => _editGroup(
                          doc.id, name, selectedFriendIDs, !favorited),
                      onTap: () => showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn,
          transform: Matrix4.translationValues(0, visible ? 0 : 100, 0),
          child: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
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
        ),
      ),
    );
  }
}
