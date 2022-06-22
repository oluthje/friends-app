import 'dart:math';

import 'package:flutter/material.dart';
import '../../screens/friends_screen.dart';
import 'package:friends/widgets/friends_list.dart';

import 'dashboard_card.dart';

class FriendsCard extends StatelessWidget {
  final List friends;

  const FriendsCard({
    Key? key,
    required this.friends
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Friends',
      onPressed: () => showBottomSheet(
        context: context,
        builder: (context) => FriendsScreen(initFriends: friends),
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
                visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity),
                title: Text(friends[index]['name']),
                subtitle: const Text('Arts, Climbing, video games'),
              );
            }
          ),
        ],
      ),
    );
  }
}