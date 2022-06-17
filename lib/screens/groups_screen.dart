import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:friends/widgets/modal_add_item.dart';

class GroupsScreen extends StatefulWidget {
  final List friends;
  final List groups;

  bool visible = true;

  GroupsScreen({
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

  void _addGroup(String text) {
    db.collection(collectionPath).add({
      "name": text,
      "friends": [],
      "user_id": user.uid,
    });
    textFieldController.clear();
  }

  void _editGroup(String id, String name) {
    final doc = db.collection(collectionPath).doc(id);
    doc.update({"name": name}).then((value) => null);
  }

  void _deleteGroup(String id) {
    final doc = db.collection(collectionPath).doc(id);
    doc.delete().then((doc) => null,
      onError: (e) => print("Error updating document $e"),
    );
  }

  ModalAddItem addItemModal(name, doc) {
    return ModalAddItem(
      name: name,
      onSubmit: (newName) => {
        if (doc == '') {
          _addGroup(newName)
        } else {
          _editGroup(doc.id, newName)
        }
      },
      child: Column(
        children: [
          for (var i = 0; i < widget.groups.length; i++) Text(widget.groups[i]['name'])
        ],
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final groups = widget.groups;
    final friends = widget.friends;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              final ScrollDirection direction = notification.direction;
              setState(() {
                if (direction == ScrollDirection.reverse) {
                  widget.visible = false;
                } else if (direction == ScrollDirection.forward) {
                  widget.visible = true;
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
                  final name = doc['name'];

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
                          return addItemModal(name, doc);
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
        transform: Matrix4.translationValues(0, widget.visible ? 0 : 100, 0),
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
                return ModalAddItem(
                  name: '',
                  onSubmit: (newName) => {
                    _addGroup(newName)
                  },
                  child: Column(
                    children: [
                      for (var i = 0; i < friends.length; i++) Text(friends[i]['name'])
                    ],
                  ),
                );
                //addItemModal('', '');
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