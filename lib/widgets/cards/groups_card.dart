import 'package:flutter/material.dart';
import 'package:friends/screens/groups_screen.dart';
import '../../screens/friends_screen.dart';
import 'package:friends/widgets/friends_list.dart';

import 'dashboard_card.dart';

class GroupsCard extends StatelessWidget {
  final List friends;
  final List groups;

  const GroupsCard({
    Key? key,
    required this.friends,
    required this.groups,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Groups',
      onPressed: () => showBottomSheet(
          context: context,
          builder: (context) => GroupsScreen(initFriends: friends, initGroups: groups),
      ),
      children: [
        SizedBox(
          height: 100,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groups.length,
              itemBuilder: (context, int index) {
                return ListTile(
                  visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity),
                  title: Text(groups[index]['name']),
                );
              }
            ),
          ),
        ],
      );
    }
  }