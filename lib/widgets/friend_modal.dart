import 'package:flutter/material.dart';

import 'package:friends/widgets/modal_add_item.dart';
import 'package:friends/widgets/intimacy_selection.dart';

class FriendModal extends StatefulWidget {
  final String? name;
  final String? id;
  final Function addFriend;
  final Function editFriend;
  final int intimacy;

  const FriendModal({
    Key? key,
    this.name,
    this.id,
    required this.intimacy,
    required this.addFriend,
    required this.editFriend,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FriendModal();
}

class _FriendModal extends State<FriendModal> {
  late int intimacy;

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
          widget.addFriend(newName, intimacy);
        } else {
          widget.editFriend(widget.id, newName, intimacy);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 14.0),
        child: IntimacySelection(
          intimacy: intimacy,
          onChange: (newIntimacy) {
            intimacy = newIntimacy;
          },
        )
      ),
    );
  }
}