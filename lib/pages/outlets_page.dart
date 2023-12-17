import 'package:flutter/material.dart';
import 'package:gucy/models/contacts_data.dart';
import 'package:gucy/models/outlets_data.dart';
import 'package:gucy/pages/OutletProfilePage.dart';
import 'package:gucy/pages/outlet_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/outlets_data.dart';

// class Outlet {
//   final String image;
//   final String desc;
//   final String name;
//   final String office;
//   double rating;
//   final String location;
//   final String number;
//   final List<Review> reviews;

//   Outlet({
//     required this.image,
//     required this.desc,
//     required this.name,
//     required this.office,
//     required this.rating,
//     required this.location,
//     required this.number,
//     required this.reviews,
//   });
// }

// class Review {
//   final String user;
//   final String image;
//   final double rating;
//   final String body;

//   Review({
//     required this.user,
//     required this.image,
//     required this.rating,
//     required this.body,
//   });
// }

// void main() => runApp(
//       MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: OutletPage(),
//       ),
//     );

class OutletPage extends StatefulWidget {
  const OutletPage({Key? key}) : super(key: key);

  @override
  _OutletPageState createState() => _OutletPageState();
}

class _OutletPageState extends State<OutletPage> {
  List<Outlet> outletsList = [];

  List<Outlet> filteredList = [];
  bool loading = true ;

  @override
  void initState() {
    super.initState();
    print("a");
    loadUsers();
  }

   Future<void> loadUsers() async {
    List<Outlet> tempUsers = await getOutlets();
    print("b");
    setState(() {
      outletsList = tempUsers;
      filteredList = outletsList;
      loading=false;
    });
  }

  Future<List<Outlet>> getOutlets() async {
  print("c");
  try {
    CollectionReference outletsCollection =
        FirebaseFirestore.instance.collection('outlets');
    QuerySnapshot outletSnapshot = await outletsCollection.get();

    List<Outlet> allOutlets = [];
    if (outletSnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot document in outletSnapshot.docs) {
        print("abdosaid00");
        print(document.data());
        Map<String, dynamic> outletData =
            document.data() as Map<String, dynamic>;
        List<dynamic> reviewsData = outletData['reviews'] ?? [];
        List<Review> reviews = reviewsData.map((review) {
          return Review.fromJson(review);
        }).toList();

        Outlet outlet = Outlet(
          image: outletData['image'],
          desc: outletData['desc'],
          name: outletData['name'],
          reviews: reviews,
          location: outletData['location'],
        );
        print(outlet.name);
        allOutlets.add(outlet);
      }
    }

    return allOutlets;
  } catch (e) {
    // Handle any potential errors during data fetching
    print('Error fetching outlets: $e');
    throw e; // Re-throw the error to propagate it to the calling code
  }
}


  onSearch(String search) {
    setState(() {
      filteredList = outletsList.where((outlet) {
        return outlet.name.toLowerCase().contains(search.toLowerCase()) ||
            outlet.desc.toLowerCase().contains(search.toLowerCase()) ||
            outlet.location.toLowerCase().contains(search.toLowerCase());
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
            //style: TextStyle(color: Colors.white),
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
              hintText: "Search Outlets",
            ),
          ),
        ),
        Expanded(
          child: loading
      ? Center(
          child: CircularProgressIndicator(), // Show loading indicator
        )
      : Container(
            //color: Colors.grey.shade900,
            child: filteredList.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return outletComponent(outlet: filteredList[index]);
                    },
                  )
                : Center(
                    child: Text(
                      "No outlets found",
                      //style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget outletComponent({required Outlet outlet}) {
    // return GestureDetector(
    //   onTap: () {
        
    //     // Add code here to perform actions when tapped
    //   },
    //   child:
      // return Container(
      //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      //   padding: EdgeInsets.all(10),
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(10),
      //     border: Border.all(color: Colors.grey),
      //   ),
      //   child: Material(
      //     color: Colors.transparent, // Required for tap effect
      //     child: InkWell(
      //       onTap: () {
      //         print("Outlet clicked: ${outlet.name}");
      //         Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => OutletProfilePage(outlet: outlet),
      //     ),
      //   );
      //         // Add code here to perform actions when tapped
      //       },
      //       borderRadius: BorderRadius.circular(10),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Row(
      //             children: [
      //               Container(
      //                 width: 60,
      //                 height: 60,
      //                 child: ClipRRect(
      //                   borderRadius: BorderRadius.circular(50),
      //                   child: Image.network(outlet.image),
      //                 ),
      //               ),
      //               SizedBox(width: 10),
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     outlet.name,
      //                     style: TextStyle(
      //                       color: Colors.white,
      //                       fontWeight: FontWeight.w500,
      //                     ),
      //                   ),
      //                   SizedBox(height: 5),
      //                   _buildRatingStars(outlet.rating),
      //                 ],
      //               ),
      //             ],
      //           ),
      //           Expanded(
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.end,
      //               children: [
      //                 Icon(
      //                   Icons.store,
      //                   color:Theme.of(context).colorScheme.primary,
      //                   size: 20,
      //                 ),
      //                 SizedBox(width: 5),
      //                 Text(
      //                   outlet.location,
      //                   textAlign: TextAlign.right,
      //                   //style: TextStyle(color: Colors.white),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
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
              onTap: () {
                print("Staff clicked: ${outlet.name}");
                      Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OutletProfilePage(outlet: outlet),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 20),
                      //image
                      Container(
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(outlet.image),
                        ),
                      ),
                      SizedBox(width: 10),
                      //rest
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
                          Text(
                            outlet.name,
                            style: TextStyle(
                                //color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                          SizedBox(height: 2),
                          _buildRatingStars(outlet.rating),
                        ],
                      ),
                    ],
                  ),
                  // Expanded(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       Icon(
                  //         Icons.store,
                  //         color: Theme.of(context).colorScheme.primary,
                  //         size: 25,
                  //       ),
                  //       SizedBox(width: 5),
                  //       Text(
                  //         outlet.location,
                  //         textAlign: TextAlign.right,
                  //         style: TextStyle(
                  //             //color: Theme.of(context).colorScheme.primary,
                  //             fontWeight: FontWeight.w500,
                  //             fontSize: 15),
                  //         //style: TextStyle(color: Colors.white),
                  //       ),
                  //       SizedBox(width: 20)
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Divider()
        ]));
    
  }

  Widget _buildRatingStars(double rating) {
   int fullStars = rating.floor(); // Extract the whole number part
    double fraction = rating - fullStars; // Calculate the fractional part

    List<Widget> stars = List.generate(
      fullStars,
      (index) => Icon(
        Icons.star,
        color: Theme.of(context).colorScheme.primary,
        size: 25,
      ),
    );
    int n = 5 - fullStars;
    if (fraction > 0) {
      n = n - 1;
      stars.add(Icon(
        Icons.star_half,
        color: Theme.of(context).colorScheme.primary,
        size: 25,
      ));
    }
    for (int i = 0; i < n; i++) {
      stars.add(Icon(
        Icons.star_outline,
        color: Theme.of(context).colorScheme.primary,
        size: 25,
      ));
    }

    return Row(children: stars);
  }
}
