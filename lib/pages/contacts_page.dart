import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:gucy/models/contacts_data.dart';
import 'package:gucy/pages/contact_service.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact {
  final String name;
  final String phoneNumber;
  final bool isEmergency;

  Contact({
    required this.name,
    required this.phoneNumber,
    required this.isEmergency,
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
  bool loading =true;
  
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
    setState(() {
      contactsList = tempUsers;
      filteredList = contactsList;
      loading=false;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          //color: Colors.grey.shade900,
          child: TextField(
            onChanged: (value) => onSearch(value),
           // style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              //fillColor: Colors.grey[850],
              contentPadding: EdgeInsets.all(0),
              prefixIcon: Icon(
                Icons.search,
                // color: Colors.grey.shade500
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              hintStyle: TextStyle(
                fontSize: 14,
                //color: Colors.grey.shade500,
              ),
              hintText: "Search Contacts",
            ),
          ),
        ),
        Expanded(
          child: loading
      ? Center(
          child: CircularProgressIndicator(), // Show loading indicator
        )
      :  Container(
            //color: Colors.grey.shade900,
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
                      //style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget contactComponent({required Contacts contact}) {
  // return GestureDetector(
  //   onTap: () {
  //     print("Contact clicked: ${contact.name}");
  //     // Add code here to perform actions when tapped
  //   },
  //   child:
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //     padding: EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10),
  //       //border: Border.all(color: Colors.grey),
  //     ),
  //     child: Material(
  //       //color: Colors.transparent, // Required for tap effect
  //       child: InkWell(
  //         onTap: () async {
  //       if (contact.isEmergency) {
  //       try {
  //         await FlutterPhoneDirectCaller.callNumber(contact.phoneNumber);
  //       } catch (e) {
  //         print('Error calling phone number: $e');
  //         // Handle the error as needed
  //       }
  //     } else {
  //       // Handle normal contact action here (e.g., open dialer)
  //       // You can implement your desired action for normal contacts here
  //        try {
  //         String temp =contact.phoneNumber;
  //         Uri phoneno = Uri.parse('tel:$temp');
  //         await launchUrl(phoneno);
  //       } catch (e) {
  //         print('Error calling phone number: $e');
  //         // Handle the error as needed
  //       }
  //     }
  //         },
  //         borderRadius: BorderRadius.circular(10),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   contact.name,
  //                   style: TextStyle(
  //                    // color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 SizedBox(height: 5),
  //                  Text(
  //                     contact.isEmergency ? 'Emergency contact' : 'Normal contact',
  //                     style: TextStyle(
  //                       color: contact.isEmergency ? Colors.red : Colors.green,
  //                       fontSize: 12,
  //                     ),
                
  //                 ),
  //               ],
  //             ),
  //             SizedBox(width: 10),
  //             Text(
  //               contact.phoneNumber,
  //               style: TextStyle(
  //                 //color: Colors.grey,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   // ),
  // );
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
         if (contact.isEmergency) {
         try {
          await FlutterPhoneDirectCaller.callNumber(contact.phoneNumber);
         } catch (e) {
           print('Error calling phone number: $e');
           // Handle the error as needed
         }
       } else {
         // Handle normal contact action here (e.g., open dialer)
         // You can implement your desired action for normal contacts here
          try {
           String temp =contact.phoneNumber;
           Uri phoneno = Uri.parse('tel:$temp');
           await launchUrl(phoneno);
         } catch (e) {
           print('Error calling phone number: $e');
           // Handle the error as needed
        }
       }
              },
              borderRadius: BorderRadius.circular(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                     
                      SizedBox(width: 10),
                      //rest
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
                          Text(
                            contact.name,
                            style: TextStyle(
                                //color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                          SizedBox(height: 5),
                    Text(
                     contact.isEmergency ? 'Emergency contact' : 'Normal contact',
                       style: TextStyle(
                         color: contact.isEmergency ? Colors.red : Colors.green,
                         fontSize: 12,
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
                        Text(
                          contact.phoneNumber,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              //color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                          //style: TextStyle(color: Colors.white),
                        ),
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
