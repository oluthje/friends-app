import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authentication/google_sign_in.dart';

class ProfileButton extends StatelessWidget {
  final User user;

  const ProfileButton({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);

    return TextButton(
      style: style,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            alignment:
                Alignment.lerp(Alignment.topCenter, Alignment.center, 0.35),
            title: const Text('Account'),
            contentPadding: const EdgeInsets.all(20.0),
            children: [
              ElevatedButton(
                  onPressed: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.logout();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Log out')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
            ],
          ),
        );
      },
      child: CircleAvatar(
        backgroundImage: NetworkImage(user.photoURL!),
      ),
    );
  }
}
