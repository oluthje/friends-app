import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friends/widgets/groups/groups_screen.dart';
import '../dashboard/dashboard_card.dart';
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

  Widget buildGroupsScreen(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final Stream<QuerySnapshot> friendsSnapshots = FirebaseFirestore.instance
        .collection(constants.friends)
        .where(constants.userId, isEqualTo: user.uid)
        .snapshots();
    final Stream<QuerySnapshot> groupsSnapshots = FirebaseFirestore.instance
        .collection(constants.groups)
        .where(constants.userId, isEqualTo: user.uid)
        .snapshots();

    return StreamBuilder(
      stream: friendsSnapshots,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
        return StreamBuilder(
          stream: groupsSnapshots,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
            if (snapshot1.hasError || snapshot2.hasError) {
              return Text('Error: ${snapshot1.error}. ${snapshot2.error}');
            }
            if (snapshot1.connectionState == ConnectionState.waiting ||
                snapshot2.connectionState == ConnectionState.waiting) {
              return const Text('Waiting on data');
            }

            var friendsDocs = snapshot1.requireData.docs;
            var groupsDocs = snapshot2.requireData.docs;

            return GroupsScreen(friends: friendsDocs, groups: groupsDocs);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List valuableGroups = sortedGroupsByImportance();

    return DashboardCard(
      title: 'Groups',
      icon: const Icon(Icons.groups),
      emptyCardMessage:
          groups.isEmpty ? "No groups yet, click here to add some!" : null,
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: buildGroupsScreen,
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
