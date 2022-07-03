import 'package:flutter/material.dart';

class FriendsListTile extends StatelessWidget {
  final String name;
  final String? checkinInterval;
  final void Function()? onTap;
  final Widget? trailing;

  const FriendsListTile({
    Key? key,
    required this.name,
    this.checkinInterval,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String checkinName = '';
    if (checkinInterval != null && checkinInterval != 'None') {
      checkinName = checkinInterval!;
    }

    return ListTile(
      title: Text(name),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Arts, Climbing, video games'),
          Text(checkinName),
        ],
      ),
      trailing: trailing,
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
      ),
      onTap: onTap,
    );
  }
}
