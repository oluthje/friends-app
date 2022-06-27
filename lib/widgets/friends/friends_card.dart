import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friends/widgets/friends/friends_list_tile.dart';
import 'friends_screen.dart';
import '../cards/dashboard_card.dart';
import 'package:friends/constants.dart' as constants;

class FriendsCard extends StatelessWidget {
  final List friends;

  const FriendsCard({
    Key? key,
    required this.friends,
  }) : super(key: key);

  List sortedFriendsByImportance() {
    List sorted = friends;

    sorted.sort((friend1, friend2) {
      return (friend1[constants.friendIntimacy]
          .compareTo(friend2[constants.friendIntimacy]));
    });

    return sorted;
  }

  Widget buildFriendsScreen(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final Stream<QuerySnapshot> friendsSnapshots = FirebaseFirestore.instance
        .collection(constants.friends)
        .where(constants.userId, isEqualTo: user.uid)
        .snapshots();

    return StreamBuilder(
      stream: friendsSnapshots,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Waiting on data');
        }

        var friendsDocs = snapshot.requireData.docs;

        return FriendsScreen(friends: friendsDocs);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List sortedFriends = sortedFriendsByImportance();

    return DashboardCard(
      title: 'Friends',
      icon: const Icon(Icons.home),
      emptyCardMessage:
          friends.isEmpty ? "No friends yet, click here to add some!" : null,
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: buildFriendsScreen,
        ),
      ),
      child: Column(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: min(4, friends.length),
            itemBuilder: (context, int index) {
              final friend = sortedFriends[index];
              final name = friend[constants.name];
              final checkinInterval = constants.getField(friend,
                  constants.checkinInterval, constants.checkinIntervalNames[0]);

              return FriendsListTile(
                name: name,
                checkinInterval: checkinInterval,
              );
            },
          ),
        ],
      ),
    );
  }
}
