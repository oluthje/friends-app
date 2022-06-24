import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'package:friends/util/google_sign_in.dart';
import 'package:friends/widgets/sign_up_widget.dart';
import 'package:friends/screens/groups_screen.dart';
import 'package:friends/constants.dart' as constants;
import 'package:friends/widgets/profile_button.dart';
import 'package:friends/widgets/friends/friends_card.dart';
import 'package:friends/widgets/groups/groups_card.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _fbApp = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: const MaterialApp(title: 'Sign in App!', home: HomePage()));
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
        title: const Text('Friends'),
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
                return const Text('Data is loading');
              }

              final friendsDocs = snapshot1.requireData.docs;
              final groupsDocs = snapshot2.requireData.docs;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: <Widget>[
                    FriendsCard(friends: friendsDocs),
                    GroupsCard(friends: friendsDocs, groups: groupsDocs),

                    // RIGHT HERE: perhaps put Friends/Groups screen modal here instead.
                    // Otherwise modals won't have any shadow, or rounded corners.
                    // TextButton(
                    //   onPressed: () => showModalBottomSheet(
                    //       context: context,
                    //       builder: (context) {
                    //         return Expanded(
                    //             child: Text('Bottom modal in the house!!'));
                    //       }),
                    //   child: Text('Bottom Modal'),
                    // ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
