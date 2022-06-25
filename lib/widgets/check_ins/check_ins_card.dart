import 'dart:math';

import 'package:flutter/material.dart';
import 'package:friends/widgets/friends/friends_list_tile.dart';
import '../../screens/friends_screen.dart';
import '../cards/dashboard_card.dart';
import 'package:friends/constants.dart' as constants;

class CheckInsCard extends StatelessWidget {
  final List friends;

  const CheckInsCard({
    Key? key,
    required this.friends,
  }) : super(key: key);

  int getCheckinImportance(checkinInteral) {
    var importance = constants.checkinIntervalNames.indexOf(checkinInteral);
    if (importance == 0) return 100;
    return importance;
  }

  // Sort friends by how often their check in is.
  List sortedFriendsByCheckins() {
    List sorted = friends;

    sorted.sort((friend1, friend2) {
      final friend1Value = getCheckinImportance(constants.getField(friend1,
          constants.checkinInterval, constants.checkinIntervalNames[0]));
      final friend2Value = getCheckinImportance(constants.getField(friend2,
          constants.checkinInterval, constants.checkinIntervalNames[0]));

      return (friend1Value.compareTo(friend2Value));
    });

    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    List sortedFriends = sortedFriendsByCheckins();

    return DashboardCard(
      title: 'Check Ins',
      icon: const Icon(Icons.check),
      emptyCardMessage:
          friends.isEmpty ? "No checkins yet, click here to add some!" : null,
      onPressed: () => showBottomSheet(
        context: context,
        builder: (context) => SizedBox(
          child: FriendsScreen(initFriends: friends),
        ),
      ),
      // child: Container(),
      child: Column(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: min(3, friends.length),
            itemBuilder: (context, int index) {
              final name = sortedFriends[index][constants.name];
              final checkinInterval = constants.getField(sortedFriends[index],
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