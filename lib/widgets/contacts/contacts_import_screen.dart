import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:friends/widgets/intimacy_selection.dart';
import 'package:friends/widgets/friends/checkin_dropdown_menu.dart';

class ContactsImportScreen extends StatefulWidget {
  const ContactsImportScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ContactsImportScreen> createState() => _ContactsImportScreen();
}

class _ContactsImportScreen extends State<ContactsImportScreen> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts(
          withProperties: true, withThumbnail: true);
      setState(() => _contacts = contacts);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Add Friends'),
        ),
        body: _body(),
      );

  Widget _body() {
    if (_permissionDenied)
      return const Center(child: Text('Permission denied'));
    if (_contacts == null)
      return const Center(child: CircularProgressIndicator());
    return ListView.builder(
      itemCount: _contacts!.length,
      itemBuilder: (context, i) =>
          ContactExpansionTile(name: _contacts![i].displayName),
    );
  }
}

class ContactExpansionTile extends StatefulWidget {
  final String name;

  const ContactExpansionTile({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  State<ContactExpansionTile> createState() => _ContactExpansionTileState();
}

class _ContactExpansionTileState extends State<ContactExpansionTile> {
  bool _expanded = false;

  Widget _trailingWidget() {
    if (_expanded) {
      return Container();
    }
    return TextButton(
      child: const Icon(Icons.add),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.name),
      trailing: SizedBox(
        width: 50,
        height: 50,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _trailingWidget(),
        ),
      ),
      children: [
        IntimacySelection(intimacy: 0, onChange: () {}),
        Row(
          children: [
            const Spacer(
              flex: 7,
            ),
            CheckinDropdownMenu(
              checkinInterval: 'None',
              onChanged: (dynamic name) {},
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextButton(
                child: const Icon(Icons.minimize),
                onPressed: () {},
              ),
            ),
          ],
        )
      ],
      onExpansionChanged: (expanded) {
        setState(() {
          _expanded = expanded;
        });
      },
    );
  }
}

// class ContactPage extends StatelessWidget {
//   final Contact contact;
//   const ContactPage(this.contact, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) => Scaffold(
//       appBar: AppBar(title: Text(contact.displayName)),
//       body: Column(children: [
//         (contact.photoOrThumbnail != null
//             ? CircleAvatar(
//                 backgroundImage: MemoryImage(contact.photoOrThumbnail!),
//               )
//             : Text('No image available')),
//         Text('First name: ${contact.name.first}'),
//         Text('Last name: ${contact.name.last}'),
//         Text(
//             'Phone number: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}'),
//         Text(
//             'Email address: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}'),
//       ]));
// }
