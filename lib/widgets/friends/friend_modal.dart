import 'package:flutter/material.dart';
import 'package:friends/constants.dart' as constants;
import 'package:friends/widgets/item_selection.dart';

import 'package:friends/widgets/modal_add_item.dart';
import 'package:friends/widgets/intimacy_selection.dart';
import 'package:friends/widgets/friends/checkin_dropdown_menu.dart';

class FriendModal extends StatefulWidget {
  final String? name;
  final String? id;
  final Function addFriend;
  final Function editFriend;
  final int intimacy;
  final String initCheckinInterval;
  final List groups;

  const FriendModal({
    Key? key,
    this.name,
    this.id,
    required this.intimacy,
    required this.addFriend,
    required this.editFriend,
    required this.initCheckinInterval,
    required this.groups,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FriendModal();
}

class _FriendModal extends State<FriendModal> {
  late int intimacy;
  late String checkinInterval = widget.initCheckinInterval;
  late List selectedGroupIndices = getGroupIndicesForFriend();

  // from list of Groups snapshots, return indices of groups that has friendId
  List<int> getGroupIndicesForFriend() {
    List<int> indices = [];
    widget.groups.asMap().forEach((index, group) {
      if (group[constants.friendIds].contains(widget.id)) {
        indices.add(index);
      }
    });

    return indices;
  }

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
        // convert group indices to group ids
        List selectedGroupIds = [];
        for (int index in selectedGroupIndices) {
          selectedGroupIds.add(widget.groups[index].id);
        }

        if (widget.id == '') {
          widget.addFriend(newName, intimacy, checkinInterval, selectedGroupIds,
              widget.groups);
        } else {
          widget.editFriend(widget.id, newName, intimacy, checkinInterval,
              selectedGroupIds, widget.groups);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 14.0),
        child: Column(
          children: [
            ItemSelection(
              items: widget.groups,
              selectedItems: selectedGroupIndices,
              onUpdated: (indices) {
                selectedGroupIndices = indices;
              },
            ),
            IntimacySelection(
              intimacy: intimacy,
              onChange: (newIntimacy) {
                intimacy = newIntimacy;
              },
            ),
            CheckinDropdownMenu(
              checkinInterval: checkinInterval,
              onChanged: (String? newValue) {
                checkinInterval = newValue!;
              },
            ),
          ],
        ),
      ),
    );
  }
}
