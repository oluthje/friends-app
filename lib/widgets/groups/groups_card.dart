import 'dart:math';
import 'package:flutter/material.dart';
import 'package:friends/screens/groups_screen.dart';
import '../cards/dashboard_card.dart';
import 'package:friends/constants.dart' as constants;

import 'group_list_tile.dart';

class GroupsCard extends StatelessWidget {
  final List friends;
  final List groups;

  const GroupsCard({
    Key? key,
    required this.friends,
    required this.groups,
  }) : super(key: key);

  List sortedGroupsByImportance() {
    List sorted = groups;

    sorted.sort((group1, group2) {
      if (getField(group2, constants.favorited, false)) {
        return 1;
      } else {
        return -1;
      }
    });

    return sorted;
  }

  dynamic getField(doc, field, defualt) {
    return doc.data().toString().contains(field) ? doc.get(field) : defualt;
  }

  @override
  Widget build(BuildContext context) {
    List valuableGroups = sortedGroupsByImportance();

    return DashboardCard(
      title: 'Groups',
      icon: const Icon(Icons.groups),
      emptyCardMessage:
          groups.isEmpty ? "No groups yet, click here to add some!" : null,
      onPressed: () => showBottomSheet(
        context: context,
        builder: (context) => GroupsScreen(
          initFriends: friends,
          initGroups: groups,
        ),
      ),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 0),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: min(3, groups.length),
            itemBuilder: (context, int index) {
              return GroupListTile(
                name: valuableGroups[index][constants.name],
                favorited: valuableGroups[index][constants.favorited],
              );
            },
          ),
        ],
      ),
    );
  }
}
