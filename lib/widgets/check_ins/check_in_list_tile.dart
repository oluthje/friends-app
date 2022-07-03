import 'package:flutter/material.dart';
import 'package:friends/check_in/check_in.dart';

class CheckInListTile extends StatelessWidget {
  final String name;
  final String checkinInterval;
  final bool checkedIn;
  final DateTime deadline;
  final DateTime? lastCheckIn;
  final void Function() checkInToggle;
  final void Function()? onTap;

  const CheckInListTile({
    Key? key,
    required this.name,
    required this.checkinInterval,
    required this.checkedIn,
    required this.checkInToggle,
    required this.deadline,
    this.lastCheckIn,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CheckInCalculator calc = CheckInCalculator();
    final String formattedTimeToDeadline =
        calc.formatTimeUntilDeadline(deadline);
    final String formattedTimeSinceLastCheckIn = lastCheckIn != null
        ? 'Checked in ${calc.formatTimeUntilDeadline(lastCheckIn!)} ago'
        : 'No check ins yet';

    return ListTile(
      title: Text(name),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(formattedTimeSinceLastCheckIn),
        ],
      ),
      trailing: Column(
        children: [
          TextButton(
            onPressed: checkInToggle,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.center,
            ),
            child: Icon(
              checkedIn ? Icons.check_box : Icons.check_box_outline_blank,
            ),
          ),
          Text('$formattedTimeToDeadline left'),
        ],
      ),
      onTap: onTap,
    );
  }
}
