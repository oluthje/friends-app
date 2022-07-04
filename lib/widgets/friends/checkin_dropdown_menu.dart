import 'package:flutter/material.dart';
import 'package:friends/constants.dart' as constants;

class CheckinDropdownMenu extends StatefulWidget {
  final String checkinInterval;
  final Function(String?) onChanged;

  const CheckinDropdownMenu({
    Key? key,
    required this.checkinInterval,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CheckinDropdownMenu();
}

class _CheckinDropdownMenu extends State<CheckinDropdownMenu> {
  late String checkinInterval;

  @override
  void initState() {
    checkinInterval = widget.checkinInterval;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> names = constants.checkinIntervalNames;
    return DropdownButton(
      value: checkinInterval,
      items: names.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? interval) {
        setState(() {
          checkinInterval = interval!;
          widget.onChanged(interval);
        });
      },
    );
  }
}
