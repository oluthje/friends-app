import 'package:flutter/material.dart';

class ModalAddItem extends StatelessWidget {
  final String name;
  final Function(String) onSubmit;
  late final TextEditingController textFieldController;
  final Widget? child;

  ModalAddItem({
    Key? key,
    required this.name,
    required this.onSubmit,
    this.child,
  }) : super(key: key) {
    textFieldController = TextEditingController(text: name);
  }

  void submit(context) {
    onSubmit(textFieldController.text);
    Navigator.pop(context);
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Text('Todo List Name'),
              TextFormField(
                controller: textFieldController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Todo item',
                ),
                autofocus: true,
                onEditingComplete: () => submit(context),
              ),
              child ?? Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 5),
                  TextButton(
                    child: const Text('Submit'),
                    onPressed: () => submit(context),
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
