import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'StaffProfilePage.dart';
import '../models/staff_data.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({Key? key}) : super(key: key);

  @override
  _StaffPageState createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  // List<Staff> StaffList = [
  //   Staff(
  //     image:
  //         'https://i1.rgstatic.net/ii/profile.image/1139601779490817-1648713645310_Q512/Milad-Ghantous-2.jpg',
  //     desc: 'This is Dr Milad Michel, Faculty of MET. I teach CO, DSD, Microprocessors, and Mobile dev. It is my pleasure to be one of the first professors on this great app!',
  //     name: 'Milad Ghantous',
  //     office: 'Office 1',
  //     rating: 4.5,
  //     title: "Professor (MET)",
  //     location: 'C7.213',
  //     number: '1234567890',
  //     reviews: [
  //       Review(
  //         user: 'User 1',
  //         rating: 4.0,
  //         body: 'This Professor is fire ngl .. Best grades so far!',
  //       ),
  //       Review(
  //         user: 'User 2',
  //         rating: 2.5,
  //         body: 'There is no way I\'m passing his courses',
  //       ),
  //     ],
  //   ),
  //   Staff(
  //     image:
  //         'https://media.licdn.com/dms/image/C4D03AQFA_7Nbpec-5w/profile-displayphoto-shrink_400_400/0/1649660429265?e=2147483647&v=beta&t=jMdrDeMNlQq2t904n5NZ3LbqFxAGsXy3iEn2hyOuiUI',
  //     desc: 'Description for Haytham',
  //     name: 'Haytham Ismail ',
  //     office: 'Office 1',
  //     rating: 3.5,
  //     title: "Professor (MET)",
  //     location: 'C7.218',
  //     number: '1234567890',
  //     reviews: [
  //       Review(
  //         user: 'User 1',
  //         rating: 4.0,
  //         body: 'Review 1',
  //       ),
  //       Review(
  //         user: 'User 2',
  //         rating: 5.0,
  //         body: 'Review 2',
  //       ),
  //     ],
  //   ),
  //   Staff(
  //     image:
  //         'https://pbs.twimg.com/media/E2K9OQbXsAEmQfZ.jpg',
  //     desc: 'Description for Ayman',
  //     name: 'Mohamed Ayman',
  //     office: 'Office 1',
  //     rating: 3.0,
  //     title: "Teaching Assistant (MET)",
  //     location: 'C2.213',
  //     number: '1234567890',
  //     reviews: [
  //       Review(
  //         user: 'User 1',
  //         rating: 3.0,
  //         body: 'Review 1',
  //       ),
  //       Review(
  //         user: 'User 2',
  //         rating: 5.0,
  //         body: 'Review 2',
  //       ),
  //     ],
  //   ),
  //   Staff(
  //     image:
  //         'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
  //     desc: 'Description for Mariam',
  //     name: 'Mariam Essam',
  //     office: 'Office 1',
  //     rating: 5,
  //     title: "Professor (ARCH)",
  //     location: 'D3.113',
  //     number: '1234567890',
  //     reviews: [
  //       Review(
  //         user: 'User 1',
  //         rating: 5.0,
  //         body: 'Review 1',
  //       ),
  //       Review(
  //         user: 'User 2',
  //         rating: 5.0,
  //         body: 'Review 2',
  //       ),
  //     ],
  //   ),
  // ];

  List<Staff> StaffList = [];
  List<Staff> filteredList = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    List<Staff> tempStaff = await getStaff();
    setState(() {
      StaffList = tempStaff;
      filteredList = StaffList;
      loading = false;
    });
  }

  Future<List<Staff>> getStaff() async {
    try {
      print("Fetching from DB 1");
      CollectionReference staffCollection =
          FirebaseFirestore.instance.collection('staff');
      QuerySnapshot staffSnapshot = await staffCollection.get();
      print("Fetching from DB 2");
      List<Staff> allStaff = [];
      if (staffSnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in staffSnapshot.docs) {
          print(document.data());
          Map<String, dynamic> staffData =
              document.data() as Map<String, dynamic>;
          List<dynamic> reviewsData = staffData['reviews'] ?? [];
          print(reviewsData);
          List<Review> reviews = reviewsData.map((review) {
            return Review.fromJson(review);
          }).toList();
          
          Staff staff = Staff(
              id:document.id,
              image: staffData['image'],
              desc: staffData['desc'],
              name: staffData['name'],
              reviews: reviews,
              location: staffData['location'],
              office: staffData['office'],
              title: staffData['title']);
          print(staff.name);
          allStaff.add(staff);
        }
      }
      print("ALL staff size: " + allStaff.length.toString());
      return allStaff;
    } catch (e) {
      // Handle any potential errors during data fetching
      print('Error fetching Staff: $e');
      throw e; // Re-throw the error to propagate it to the calling code
    }
  }

  onSearch(String search) {
    setState(() {
      filteredList = StaffList.where((staff) {
        return staff.name.toLowerCase().contains(search.toLowerCase()) ||
            staff.desc.toLowerCase().contains(search.toLowerCase()) ||
            staff.location.toLowerCase().contains(search.toLowerCase()) ||
            staff.title.toLowerCase().contains(search.toLowerCase()) ||
            staff.office.toLowerCase().contains(search.toLowerCase());
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
              hintText: "Search Staff",
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
                      return staffComponent(staff: filteredList[index]);
                    },
                  )
                : Center(
                    child: Text(
                      "No Staff found",
                      //style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget staffComponent({required Staff staff}) {
    // return GestureDetector(
    //   onTap: () {

    //     // Add code here to perform actions when tapped
    //   },
    //   child:
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
                print("Staff clicked: ${staff.name}");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StaffProfilePage(staff: staff),
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
                          child: Image.network(staff.image),
                        ),
                      ),
                      SizedBox(width: 10),
                      //rest
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            staff.title,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            staff.name,
                            style: TextStyle(
                                //color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                          SizedBox(height: 2),
                          _buildRatingStars(staff.rating),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.store,
                          color: Theme.of(context).colorScheme.primary,
                          size: 25,
                        ),
                        SizedBox(width: 5),
                        Text(
                          staff.office,
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
