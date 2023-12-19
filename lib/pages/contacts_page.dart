import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:gucy/models/contacts_data.dart';
import 'package:gucy/pages/contact_service.dart';

class Contact {
  final String name;
  final String phoneNumber;
  //final bool isEmergency;

  Contact({
    required this.name,
    required this.phoneNumber,
    //required this.isEmergency,
  });
}

// void main() => runApp(
//       MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: ContactsPage(),
//       ),
//     );

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contacts> contactsList = [];
  bool loading = true;

  List<Contacts> filteredList = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
    // setState(() {
    //   //loading = false;
    // });
  }

  Future<void> loadUsers() async {
    List<Contacts> tempUsers = await getUsers();
    print("LoadUsers");
    setState(() {
      contactsList = tempUsers;
      filteredList = contactsList;
      loading = false;
    });
  }

  Future<List<Contacts>> getUsers() async {
    return await getemergencyNums();
  }

  onSearch(String search) {
    setState(() {
      filteredList = contactsList.where((contact) {
        return contact.name.toLowerCase().contains(search.toLowerCase()) ||
            contact.phoneNumber.contains(search);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Emergency Contacts'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: TextField(
                onChanged: (value) => onSearch(value),
                decoration: InputDecoration(
                  filled: true,
                  contentPadding: EdgeInsets.all(0),
                  prefixIcon: Icon(
                    Icons.search,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 14,
                  ),
                  hintText: "Search Contacts",
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: filteredList.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          return contactComponent(contact: filteredList[index]);
                        },
                      )
                    : Center(
                        child: Text(
                          "No contacts found",
                        ),
                      ),
              ),
            ),
          ],
        ));
  }

  Widget contactComponent({required Contacts contact}) {
    return Container(
        //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          //border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: Column(children: [
          Material(
            //color: Colors.transparent, // Required for tap effect
            child: InkWell(
              onTap: () async {
                try {
                  await FlutterPhoneDirectCaller.callNumber(
                      contact.phoneNumber);
                } catch (e) {
                  print('Error calling phone number: $e');
                  // Handle the error as needed
                }
              },
              borderRadius: BorderRadius.circular(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 20),
                      //rest
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact.name,
                            style: TextStyle(
                                //color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Emergency contact',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 183, 32, 21)),
                          ),
                          Text(
                            contact.phoneNumber,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.phone,
                          color: Theme.of(context).colorScheme.primary,
                          size: 25,
                        ),
                        SizedBox(width: 5),
                        // Text(
                        //   contact.phoneNumber,
                        //   textAlign: TextAlign.right,
                        //   style: TextStyle(
                        //       //color: Theme.of(context).colorScheme.primary,
                        //       fontWeight: FontWeight.w500,
                        //       fontSize: 15),
                        //   //style: TextStyle(color: Colors.white),
                        // ),
                        SizedBox(width: 20)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider()
        ]));
  }
}
