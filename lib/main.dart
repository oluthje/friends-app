import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friends/widgets/friends/friend_modal.dart';
import 'package:provider/provider.dart';

import 'package:friends/authentication/google_sign_in.dart';
import 'package:friends/authentication/sign_up_widget.dart';
import 'package:friends/constants.dart' as constants;
import 'package:friends/widgets/dashboard/profile_button.dart';
import 'package:friends/widgets/friends/friends_card.dart';
import 'package:friends/widgets/groups/groups_card.dart';
import 'package:friends/widgets/check_ins/check_ins_card.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          title: 'Sign in App!',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          home: const HomePage(),
        ),
      );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return const FriendsApp(title: 'Friends');
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!!'));
            } else {
              return const SignUpWidget();
            }
          },
        ),
      );
}

void showFriendModal(BuildContext context, String name, String id, int intimacy,
    String checkinInterval, List groups) {
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
        initCheckinInterval: checkinInterval,
        groups: groups,
      );
    },
  );
}

class FriendsApp extends StatefulWidget {
  final String title;

  const FriendsApp({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<FriendsApp> createState() => _FriendsApp();
}

class _FriendsApp extends State<FriendsApp> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final db = FirebaseFirestore.instance;
    final Stream<QuerySnapshot> friends = db
        .collection(constants.friends)
        .where(constants.userId, isEqualTo: user.uid)
        .snapshots();
    final Stream<QuerySnapshot> groups = db
        .collection(constants.groups)
        .where(constants.userId, isEqualTo: user.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: <Widget>[
          ProfileButton(user: user),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: friends,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
          return StreamBuilder<QuerySnapshot>(
            stream: groups,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
              if (snapshot1.hasError || snapshot2.hasError) {
                return Text('Error: ${snapshot1.error}. ${snapshot2.error}');
              }
              if (snapshot1.connectionState == ConnectionState.waiting ||
                  snapshot2.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final friendsDocs = snapshot1.requireData.docs;
              final groupsDocs = snapshot2.requireData.docs;

              return Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  left: 8.0,
                  right: 8.0,
                  bottom: 25.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      FriendsCard(
                        friends: friendsDocs,
                        groups: groupsDocs,
                        showFriendModal: showFriendModal,
                      ),
                      GroupsCard(
                        friends: friendsDocs,
                        groups: groupsDocs,
                      ),
                      CheckInsCard(
                        friends: friendsDocs,
                        groups: groupsDocs,
                        showFriendModal: showFriendModal,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
