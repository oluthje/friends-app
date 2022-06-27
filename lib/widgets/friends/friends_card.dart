import 'dart:math';

import 'package:flutter/material.dart';
import 'package:friends/widgets/friends/friends_list_tile.dart';
import '../../screens/friends_screen.dart';
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
          builder: (context) => FriendsScreen(initFriends: friends),
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
