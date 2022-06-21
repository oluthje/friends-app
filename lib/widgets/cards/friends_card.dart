import 'package:flutter/material.dart';
import '../../screens/friends_screen.dart';
import 'package:friends/widgets/friends_list.dart';

class FriendsCard extends StatelessWidget {
  final List friends;

  const FriendsCard({
    Key? key,
    required this.friends
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
              onPressed: () {
                showBottomSheet(
                    context: context,
                    builder: (context) => FriendsScreen(initFriends: friends)
                );
              },
              child: const Text('Friends')
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: friends.length,
              itemBuilder: (context, int index) {
                return ListTile(
                  visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity),
                  title: Text(friends[index]['name']),
                  subtitle: Text('Arts, Climbing, video games'),
                );
              }
            ),
            // child: FriendsList(friends: friends, addFriend: () {}, editFriend: () {}, deleteFriend: () {}),
          ),
        ],
      ),
    );
  }}