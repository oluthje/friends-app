import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final List<Widget> children;
  final String title;
  final Function onPressed;

  const DashboardCard({
    Key? key,
    required this.children,
    required this.title,
    required this.onPressed,
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
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              'Friends',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Column(children: children),
          TextButton(
            onPressed: () => onPressed(),
            child: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text('View all'),
              ),
            ),
          ),
        ],
      ),
    );
  }}