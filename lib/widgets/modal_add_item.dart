import 'package:flutter/material.dart';
import 'form_title.dart';

class ModalAddItem extends StatefulWidget {
  final String name;
  final String? title;
  final Function(String) onSubmit;
  final Widget? child;

  const ModalAddItem({
    Key? key,
    this.title,
    required this.name,
    required this.onSubmit,
    this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModalAddItem();
}

class _ModalAddItem extends State<ModalAddItem> {
  late String _name;

  void _submit(context) {
    widget.onSubmit(_name);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _name = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSize = MediaQuery.of(context).viewInsets.bottom;
    final double bottomPadding = keyboardSize < 25 ? 25 : keyboardSize;

    return Wrap(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 25.0,
            right: 25.0,
            top: 25.0,
            bottom: bottomPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FormTitle(
                text: widget.title!,
              ),
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                    // border: OutlineInputBorder(),
                    // labelText: 'Friend name',
                    ),
                autofocus: true,
                onEditingComplete: () => _submit(context),
                onChanged: (name) => setState(() {
                  _name = name;
                }),
              ),
              widget.child ?? Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () => _submit(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
