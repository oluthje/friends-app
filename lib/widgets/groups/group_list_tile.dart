import 'package:flutter/material.dart';

class GroupListTile extends StatelessWidget {
  final String name;
  final Function onFavoritedToggle;
  final Function onTap;
  final bool favorited;

  const GroupListTile({
    Key? key,
    required this.name,
    required this.onFavoritedToggle,
    required this.onTap,
    required this.favorited,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
      ),
      title: Text(name),
      trailing: TextButton(
        onPressed: () => onFavoritedToggle(),
        child: Icon(favorited ? Icons.favorite : Icons.favorite_outline),
      ),
      onTap: () => onTap(),
    );
  }
}
