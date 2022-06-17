import 'package:flutter/material.dart';

class ModalAddItem extends StatelessWidget {
  final String name;
  final Function(String) onSubmit;
  late final TextEditingController _textFieldController;

  ModalAddItem({
    Key? key,
    required this.name,
    required this.onSubmit,
  }) : super(key: key) {
    _textFieldController = TextEditingController(text: name);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text('Todo List Name'),
                TextFormField(
                  controller: _textFieldController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Todo item',
                  ),
                  autofocus: true,
                ),
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
                      onPressed: () {
                        onSubmit(_textFieldController.text);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
      ),
    );
  }
}