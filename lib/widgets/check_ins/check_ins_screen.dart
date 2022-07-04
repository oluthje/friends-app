import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'package:friends/check_in/check_in.dart';
import 'package:friends/constants.dart' as constants;
import 'package:friends/data_storage/data_storage.dart';
import 'package:friends/widgets/check_ins/check_in_list_tile.dart';

class CheckInsScreen extends StatefulWidget {
  final List<dynamic> friends;

  const CheckInsScreen({
    Key? key,
    required this.friends,
  }) : super(key: key);

  @override
  State<CheckInsScreen> createState() => _CheckInsScreen();
}

class _CheckInsScreen extends State<CheckInsScreen> {
  final CheckInStorage checkInStorage = CheckInStorage();
  final CheckInCalculator checkInCalculator = CheckInCalculator();
  final textFieldController = TextEditingController();
  bool visible = true;

  dynamic noFriendsWarning(noFriends) {
    if (noFriends) {
      return const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text('No friends yet, click the button below to add some!'),
      );
    }
    return const Padding(padding: EdgeInsets.zero);
  }

  int getCheckinImportance(checkinInteral) {
    var importance = constants.checkinIntervalNames.indexOf(checkinInteral);
    if (importance == 0) return 100;
    return importance;
  }

  bool hasCheckIn(friend) {
    return constants.getField(friend, constants.checkInInterval,
            constants.checkinIntervalNames[0]) !=
        constants.checkinIntervalNames[0];
  }

  List sortedFriendsByCheckins() {
    List sorted = widget.friends;

    sorted.removeWhere((element) => !hasCheckIn(element));

    sorted.sort((friend1, friend2) {
      final friend1Value = getCheckinImportance(constants.getField(friend1,
          constants.checkInInterval, constants.checkinIntervalNames[0]));
      final friend2Value = getCheckinImportance(constants.getField(friend2,
          constants.checkInInterval, constants.checkinIntervalNames[0]));

      return (friend1Value.compareTo(friend2Value));
    });

    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final sortedFriends = sortedFriendsByCheckins();

    return Scaffold(
      appBar: AppBar(title: const Text('Check Ins')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          noFriendsWarning(widget.friends.isEmpty),
          NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              final ScrollDirection direction = notification.direction;
              setState(() {
                if (direction == ScrollDirection.reverse) {
                  visible = false;
                } else if (direction == ScrollDirection.forward) {
                  visible = true;
                }
              });
              return true;
            },
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemBuilder: (BuildContext context, index) {
                    final friend = sortedFriends[index];
                    final name = friend[constants.name];

                    // check if user has checked in
                    final baseDate = friend[constants.checkInBaseDate];

                    List<Timestamp> dates = [];
                    for (Timestamp date in friend[constants.checkInDates]) {
                      dates.add(date);
                    }

                    final interval = friend[constants.checkInInterval];
                    final checkedIn = checkInCalculator.isCheckedIn(
                        baseDate, dates, interval);
                    final DateTime deadline =
                        checkInCalculator.deadline(baseDate, dates, interval);

                    return Card(
                      child: CheckInListTile(
                        name: name,
                        checkinInterval: interval,
                        checkedIn: checkedIn,
                        deadline: deadline,
                        lastCheckIn: dates.isEmpty ? null : dates.last.toDate(),
                        checkInToggle: () {
                          if (checkedIn) {
                            // remove last check in
                            checkInStorage.removeCheckInDate(
                              friend.id,
                              dates.last,
                            );
                          } else {
                            checkInStorage.addCheckInDate(
                              friend.id,
                              DateTime.now(),
                            );
                          }
                        },
                      ),
                    );
                  },
                  itemCount: sortedFriends.length,
                ),
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: AnimatedContainer(
      //   duration: const Duration(milliseconds: 250),
      //   curve: Curves.fastOutSlowIn,
      //   transform: Matrix4.translationValues(0, visible ? 0 : 110, 0),
      //   child: FloatingActionButton(
      //     backgroundColor: Colors.blue,
      //     onPressed: () => showFriendModal(
      //       context,
      //       '',
      //       '',
      //       constants.Intimacies.newFriend.index,
      //       constants.checkinIntervalNames[0],
      //     ),
      //     child: const Icon(Icons.add),
      //   ),
      // ),
    );
  }
}
