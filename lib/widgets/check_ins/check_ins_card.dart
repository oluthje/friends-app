import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../check_ins/check_ins_screen.dart';
import '../dashboard/dashboard_card.dart';
import 'package:friends/constants.dart' as constants;

import 'check_in_list_tile.dart';

class CheckInsCard extends StatelessWidget {
  final List friends;

  const CheckInsCard({
    Key? key,
    required this.friends,
  }) : super(key: key);

  int getCheckinImportance(checkinInterval) {
    var importance = constants.checkinIntervalNames.indexOf(checkinInterval);
    if (importance == 0) return 100;
    return importance;
  }

  // Sort friends by how often their check in is.
  List sortedFriendsByCheckins() {
    List sorted = friends
        .where((friend) =>
            friend[constants.checkInInterval] !=
            constants.checkinIntervalNames[0])
        .toList();

    sorted.sort((friend1, friend2) {
      final friend1Value = getCheckinImportance(constants.getField(friend1,
          constants.checkInInterval, constants.checkinIntervalNames[0]));
      final friend2Value = getCheckinImportance(constants.getField(friend2,
          constants.checkInInterval, constants.checkinIntervalNames[0]));

      return (friend1Value.compareTo(friend2Value));
    });

    return sorted;
  }

  Widget buildCheckInsScreen(BuildContext context) {
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

        return CheckInsScreen(friends: friendsDocs);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List sortedFriends = sortedFriendsByCheckins();

    return DashboardCard(
      title: 'Check Ins',
      icon: const Icon(Icons.check),
      emptyCardMessage:
          friends.isEmpty ? "No checkins yet, click here to add some!" : null,
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: buildCheckInsScreen,
        ),
      ),
      child: Column(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedFriends.length.clamp(0, 3),
            itemBuilder: (context, int index) {
              final friend = sortedFriends[index];
              return CheckInListTile(
                friend: friend,
              );
            },
          ),
        ],
      ),
    );
  }
}
