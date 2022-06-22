import 'package:flutter/material.dart';

class FriendsListTile extends StatelessWidget {
  final String name;
  final Function onTap;

  const FriendsListTile({
    Key? key,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: const Text('Arts, Climbing, video games'),
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
      ),
      onTap: () => onTap(),
    );
  }
}
