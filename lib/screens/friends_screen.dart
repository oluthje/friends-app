import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:friends/widgets/modal_add_item.dart';

class FriendsScreen extends StatefulWidget {
  final Stream<QuerySnapshot> friends;

  bool visible = true;

  FriendsScreen({
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

  void _addFriend(String text) {
    db.collection(collectionPath).add({
      "name": text,
      "user_id": user.uid,
    });
    textFieldController.clear();
  }

  void _editFriend(String id, String name) {
    final doc = db.collection(collectionPath).doc(id);
    doc.update({"name": name}).then((value) => null);
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
          StreamBuilder<QuerySnapshot>(
            stream: widget.friends,
            builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
                ) {

              if (snapshot.hasError) {
                final errMsg = snapshot.error;
                return Text('Something went wrong $errMsg');
              } if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Data is loading');
              }

              final data = snapshot.requireData;

              return NotificationListener<UserScrollNotification>(
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
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      final doc = data.docs[index];
                      final name = doc['name'];

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
                              return ModalAddItem(
                                name: name,
                                onSubmit: (newName) => _editFriend(doc.id, newName),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
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
                  onSubmit: (newName) => _addFriend(newName),
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