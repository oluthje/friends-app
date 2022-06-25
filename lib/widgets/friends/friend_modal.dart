import 'package:flutter/material.dart';

import 'package:friends/widgets/modal_add_item.dart';
import 'package:friends/widgets/intimacy_selection.dart';
import 'package:friends/widgets/friends/checkin_dropdown_menu.dart';
import 'package:friends/constants.dart' as constants;

class FriendModal extends StatefulWidget {
  final String? name;
  final String? id;
  final Function addFriend;
  final Function editFriend;
  final int intimacy;
  final String initCheckinInterval;

  const FriendModal({
    Key? key,
    this.name,
    this.id,
    required this.intimacy,
    required this.addFriend,
    required this.editFriend,
    required this.initCheckinInterval,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FriendModal();
}

class _FriendModal extends State<FriendModal> {
  late int intimacy;
  late String checkinInterval = widget.initCheckinInterval;

  @override
  void initState() {
    intimacy = widget.intimacy;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalAddItem(
      name: widget.name ?? '',
      onSubmit: (newName) {
        if (widget.id == '') {
          widget.addFriend(newName, intimacy, checkinInterval);
        } else {
          widget.editFriend(widget.id, newName, intimacy, checkinInterval);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 14.0),
        child: Column(
          children: [
            IntimacySelection(
              intimacy: intimacy,
              onChange: (newIntimacy) {
                intimacy = newIntimacy;
              },
            ),
            CheckinDropdownMenu(
              checkinInterval: checkinInterval,
              onChanged: (String? newValue) {
                setState(() {
                  checkinInterval = newValue!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
