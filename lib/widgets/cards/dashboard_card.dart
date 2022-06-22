import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final Widget child;
  final String title;
  final Function onPressed;

  const DashboardCard({
    Key? key,
    required this.child,
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
      child: InkWell(
        onTap: () => onPressed(),
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
            child,
          ],
        ),
      )
    );
  }
}