import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'package:friends/util/google_sign_in.dart';
import 'package:friends/widgets/sign_up_widget.dart';
import 'package:friends/screens/friends_screen.dart';
import 'package:friends/screens/groups_screen.dart';
import 'package:friends/constants.dart' as constants;

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
    child: const MaterialApp(
      title: 'Sign in App!',
      home: HomePage()
    )

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
  int selectedIndex = 1;

  void _onBarItemTapped(int index) {
    setState(() { selectedIndex = index; });
  }

  List<Widget> _widgetOptions(friends, groups) => [
    const Text('Check ins'),
    FriendsScreen(friends: friends),
    GroupsScreen(groups: groups, friends: friends),
  ];

  final navigationItems = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Check Ins',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Friends',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.list),
      label: 'Groups',
    ),
  ];

  final navItemTitles = const <String>[
    'Check Ins',
    'Friends',
    'Groups',
  ];

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    final user = FirebaseAuth.instance.currentUser!;
    final db = FirebaseFirestore.instance;
    final Stream<QuerySnapshot> friends = db.collection(constants.friends).where(constants.userId, isEqualTo: user.uid).snapshots();
    final Stream<QuerySnapshot> groups = db.collection(constants.groups).where(constants.userId, isEqualTo: user.uid).snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(navItemTitles.elementAt(selectedIndex)),
        actions: <Widget>[
          TextButton(
            style: style,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  alignment: Alignment.lerp(Alignment.topCenter, Alignment.center, 0.35),
                  title: const Text('Account'),
                  contentPadding: const EdgeInsets.all(20.0),
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                          provider.logout();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Log out')
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel')
                    ),
                  ],
                ),
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL!),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: friends,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {

          return StreamBuilder<QuerySnapshot>(
            stream: groups,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {

              if (snapshot1.hasError || snapshot2.hasError) {
                return Text('Error: ${snapshot1.error}. ${snapshot2.error}');
              } if (snapshot1.connectionState == ConnectionState.waiting ||
                  snapshot2.connectionState == ConnectionState.waiting) {
                return const Text('Data is loading');
              }

              final friendsDocs = snapshot1.requireData.docs;
              final groupsDocs = snapshot2.requireData.docs;

              return _widgetOptions(friendsDocs, groupsDocs).elementAt(selectedIndex);
            }
          );
        }
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: navigationItems,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onBarItemTapped,
      ),
    );
  }
}
