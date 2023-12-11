import 'package:flutter/material.dart';
import 'package:gucy/pages/OutletProfilePage.dart';

class Outlet {
  final String image;
  final String desc;
  final String name;
  final String office;
   double rating;
  final String location;
  final String number;
  final List<Review> reviews;

  Outlet({
    required this.image,
    required this.desc,
    required this.name,
    required this.office,
    required this.rating,
    required this.location,
    required this.number,
    required this.reviews,
  });
}

class Review {
  final String user;
  final String image;
  final double rating;
  final String body;

  Review({
    required this.user,
    required this.image,
    required this.rating,
    required this.body,
  });
}

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
 List<Outlet> outletsList = [
  Outlet(
    image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
    desc: 'Description for 3msaad',
    name: '3msaad',
    office: 'Office 1',
    rating: 4.5,
    location: 'c1.202',
    number: '1234567890',
    reviews: [
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 1',
        rating: 4.0,
        body: 'Review 1',
      ),
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 2',
        rating: 5.0,
        body: 'Review 2',
      ),
    ],
  ),
  Outlet(
    image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
    desc: 'Description for library',
    name: 'library',
    office: 'Office 2',
    rating: 4.3,
    location: 'c1.202',
    number: '1234567890',
    reviews: [
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 3',
        rating: 4.2,
        body: 'Review 3',
      ),
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 4',
        rating: 3.9,
        body: 'Review 4',
      ),
    ],
  ),
  Outlet(
    image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
    desc: 'Description for toilet',
    name: 'toilet',
    office: 'Office 3',
    rating: 4.0,
    location: 'c1.202',
    number: '5555555555',
    reviews: [
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 5',
        rating: 4.5,
        body: 'Review 5',
      ),
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 6',
        rating: 3.8,
        body: 'Review 6',
      ),
    ],
  ),
  Outlet(
    image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
    desc: 'Description for parking',
    name: 'parking',
    office: 'Office 4',
    rating: 4.7,
    location: 'c1.202',
    number: '7777777777',
    reviews: [
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 7',
        rating: 4.8,
        body: 'Review 7',
      ),
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 8',
        rating: 4.9,
        body: 'Review 8',
      ),
    ],
  ),
  Outlet(
    image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
    desc: 'Description for basketball',
    name: 'basketball',
    office: 'Office 5',
    rating: 4.2,
    location: 'c1.202',
    number: '8888888888',
    reviews: [
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 9',
        rating: 4.6,
        body: 'Review 9',
      ),
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 10',
        rating: 4.1,
        body: 'Review 10',
      ),
    ],
  ),
 Outlet(
    image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
    desc: 'Description for gym',
    name: 'gym',
    office: 'Office 6',
    rating: 4.9,
    location: 'c1.202',
    number: '9999999999',
    reviews: [
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 11',
        rating: 4.7,
        body: 'Review 11',
      ),
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 12',
        rating: 4.8,
        body: 'Review 12',
      ),
    ],
  ),
  Outlet(
    image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
    desc: 'Description for volleyball',
    name: 'volleyball',
    office: 'Office 7',
    rating: 3.7,
    location: 'c1.202',
    number: '7777777777',
    reviews: [
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 13',
        rating: 3.5,
        body: 'Review 13',
      ),
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 14',
        rating: 4.0,
        body: 'Review 14',
      ),
    ],
  ),
  Outlet(
    image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
    desc: 'Description for tennis',
    name: 'tennis',
    office: 'Office 8',
    rating: 4.4,
    location: 'c1.202',
    number: '4444444444',
    reviews: [
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 15',
        rating: 4.5,
        body: 'Review 15',
      ),
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 16',
        rating: 4.3,
        body: 'Review 16',
      ),
    ],
  ),
  Outlet(
    image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
    desc: 'Description for football',
    name: 'football',
    office: 'Office 9',
    rating: 4.6,
    location: 'c1.202',
    number: '6666666666',
    reviews: [
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 17',
        rating: 4.7,
        body: 'Review 17',
      ),
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 18',
        rating: 4.5,
        body: 'Review 18',
      ),
    ],
  ),
  Outlet(
    image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
    desc: 'Description for shop',
    name: 'shop',
    office: 'Office 10',
    rating: 4.1,
    location: 'c1.202',
    number: '5555555555',
    reviews: [
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 19',
        rating: 4.2,
        body: 'Review 19',
      ),
      Review(
        image: 'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        user: 'User 20',
        rating: 3.9,
        body: 'Review 20',
      ),
    ],
  ),
];

  List<Outlet> filteredList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      filteredList = outletsList;
    });
  }

  onSearch(String search) {
    setState(() {
      filteredList = outletsList.where((outlet) {
        return outlet.name.toLowerCase().contains(search.toLowerCase()) ||
            outlet.desc.toLowerCase().contains(search.toLowerCase()) ||
            outlet.location.toLowerCase().contains(search.toLowerCase()) ||
            outlet.office.toLowerCase().contains(search.toLowerCase());
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
          child: Container(
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
                          outlet.location,
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
