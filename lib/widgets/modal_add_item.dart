import 'package:flutter/material.dart';

class ModalAddItem extends StatefulWidget {
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

  @override
  State<ModalAddItem> createState() => _ModalAddItem();
}

class _ModalAddItem extends State<ModalAddItem> {

  void submit(context) {
    widget.onSubmit(widget.textFieldController.text);
    Navigator.pop(context);
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
                controller: widget.textFieldController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Todo item',
                ),
                autofocus: true,
                onEditingComplete: () => submit(context),
              ),
              widget.child ?? Container(),
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
        )
      ),
    );
  }
}