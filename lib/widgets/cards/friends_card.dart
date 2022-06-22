import 'dart:math';

import 'package:flutter/material.dart';
import '../../screens/friends_screen.dart';
import 'dashboard_card.dart';
import 'package:friends/constants.dart' as constants;

class FriendsCard extends StatelessWidget {
  final List friends;

  const FriendsCard({Key? key, required this.friends}) : super(key: key);

  List sortedFriendsByImportance() {
    List sorted = friends;

    sorted.sort((friend1, friend2) {
      return (friend1[constants.friendIntimacy]
          .compareTo(friend2[constants.friendIntimacy]));
    });

    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    List sortedFriends = sortedFriendsByImportance();

    return DashboardCard(
      title: 'Friends',
      onPressed: () => showBottomSheet(
        context: context,
        builder: (context) => SizedBox(
          child: FriendsScreen(initFriends: friends),
        ),
      ),
      child: Column(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: min(5, friends.length),
            itemBuilder: (context, int index) {
              return ListTile(
                visualDensity:
                    const VisualDensity(vertical: VisualDensity.minimumDensity),
                title: Text(sortedFriends[index]['name']),
                subtitle: const Text('Arts, Climbing, video games'),
              );
            },
          ),
        ],
      ),
    );
  }
}
