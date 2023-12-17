import 'package:flutter/material.dart';
import 'package:gucy/pages/outlets_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gucy/models/outlets_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Replace Outlet and Review classes with your existing implementations

class OutletProfilePage extends StatefulWidget {
  final Outlet outlet;

  const OutletProfilePage({Key? key, required this.outlet}) : super(key: key);

  @override
  _OutletProfilePageState createState() => _OutletProfilePageState();
}

class _OutletProfilePageState extends State<OutletProfilePage> {
  TextEditingController _reviewController = TextEditingController();
  double _userRating = 0.0;
  List<Review> _reviews = [];
  bool _isAddingReview = false;

  @override
  void initState() {
    super.initState();
    _reviews = widget.outlet.reviews;
  }
  openMaps(){
    _launcjMaps(widget.outlet.location);
  }
  void _launcjMaps(String location) async{
    Uri url =Uri.parse(location);
    try {
           
           await launchUrl(url);
         } catch (e) {
           print('can not open: $e');
           // Handle the error as needed
        }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.outlet.name),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(MediaQuery.of(context).viewInsets.bottom);
          setState(() {
            _isAddingReview = true;
            showNewReview(context);
          });
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    //image
                    Container(
                      width: 60,
                      height: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(widget.outlet.image),
                      ),
                    ),
                    SizedBox(width: 10),
                    //rest
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                       
                        Text(
                          widget.outlet.name,
                          style: TextStyle(
                              //color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                        SizedBox(height: 2),
                        _buildRatingStars(widget.outlet.rating),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(onPressed: openMaps, child: Text("open in maps"))
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Description',
                  style: TextStyle(fontSize: 20),
                ),
                //SizedBox(height: 10),
                Divider(),
                Text(
                  widget.outlet.desc,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),

            // Display staff reviews

            if (_reviews.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Reviews',
                    style: TextStyle(fontSize: 20),
                  ),
                  Divider(),
                  //SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildReviewsList(),
                  ),
                ],
              ),

            // Floating Action Button to add review
            // Padding(
            //   padding: EdgeInsets.only(top: 20),
            //   child: Align(
            //     alignment: Alignment.bottomRight,
            //     child: FloatingActionButton(
            //       onPressed: () {
            //         setState(() {
            //           _isAddingReview = true;
            //         });
            //       },
            //       child: Icon(Icons.add),
            //     ),
            //   ),
            // ),

            // Add a review form
            //if (_isAddingReview)
          ],
        ),
      ),
    );
  }

 List<Widget> _buildReviewsList() {
  return _reviews.map((review) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                  "https://cdn-icons-png.flaticon.com/512/147/147142.png"),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.user,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    _buildRatingStars(review.rating),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: SizedBox(
                    width: 300,
                    child: Text(
                      review.body,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }).toList();
}

  Widget reviewComponent({required Review review}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Material(
        color: Colors.transparent, // Required for tap effect
        borderRadius: BorderRadius.circular(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(review.image),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.user,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      review.body,
                      style: TextStyle(
                        color: Colors.black,
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
                children: [_buildRatingStars(review.rating)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  

 

 void _addReview() async {
  if (_reviewController.text.isNotEmpty) {
    // Create a reference to the 'outlets' collection in Firestore
    CollectionReference outletsCollection =
        FirebaseFirestore.instance.collection('outlets');

    // Create a new review object
    Review newReview = Review(
      image:
          'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
      user: 'User 111', // Replace with the actual user's name or ID
      rating: _userRating,
      body: _reviewController.text,
    );

    // Add the new review data to Firestore
    print(widget.outlet.id);
    QuerySnapshot querySnapshot = await outletsCollection
        .where('name', isEqualTo: widget.outlet.name)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Get the first document reference if it exists
      DocumentReference outletDocRef = querySnapshot.docs[0].reference;

      try {
        // Update the reviews array of the found outlet document
        await outletDocRef.update({
          'reviews': FieldValue.arrayUnion([newReview.toJson()])
        });

        setState(() {
          _reviews.add(newReview);
          _reviewController.clear();
          _userRating = 0.0;
          _isAddingReview = false;
        });
      } catch (e) {
        print('Error adding review: $e');
        // Handle the error as needed
      }
    } else {
      print('Outlet document not found');
      // Handle the case where the outlet document doesn't exist
    }

  }
}

void showNewReview(BuildContext ctx) {
  bool isReviewEmpty = false;

  showModalBottomSheet(
    context: ctx,
    isScrollControlled: true,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Text(
                    'What is your rating?',
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  RatingBar.builder(
                    initialRating: _userRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 50,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _userRating = rating;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please share your opinion',
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      hintText: 'Write your review here...',
                      border: OutlineInputBorder(),
                    ),
                    minLines: 3,
                    maxLines: null,
                  ),
                  SizedBox(height: 10),
                  if (isReviewEmpty)
                    Text(
                      'Please enter a review',
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_reviewController.text.isEmpty) {
                        setState(() {
                          isReviewEmpty = true;
                        });
                      } else {
                        _addReview();
                        Navigator.of(ctx).pop();
                      }
                    },
                    child: Text('Submit Review'),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}


  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
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




























// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:gucy/models/outlets_data.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:url_launcher/url_launcher.dart';

// class OutletProfilePage extends StatefulWidget {
//   final Outlet outlet;

//   const OutletProfilePage({Key? key, required this.outlet}) : super(key: key);

//   @override
//   _OutletProfilePageState createState() => _OutletProfilePageState();
// }

// class _OutletProfilePageState extends State<OutletProfilePage> {
//   TextEditingController _reviewController = TextEditingController();
//   double _userRating = 0.0;
//   List<Review> _reviews = [];
//   bool _isAddingReview = false;

//   @override
//   void initState() {
//     super.initState();
//     _reviews = widget.outlet.reviews;
//   }

//   openMaps() {
//     _launchMaps(widget.outlet.location);
//   }

//   void _launchMaps(String location) async {
//     Uri url = Uri.parse(location);
//     try {
//       await launchUrl(url);
//     } catch (e) {
//       print('can not open: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.outlet.name),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             _isAddingReview = true;
//             showNewReview(context);
//           });
//         },
//         child: Icon(Icons.add),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       width: 60,
//                       height: 60,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(50),
//                         child: Image.network(widget.outlet.image),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.outlet.name,
//                           style: TextStyle(
//                               fontWeight: FontWeight.w500, fontSize: 20),
//                         ),
//                         SizedBox(height: 2),
//                         _buildRatingStars(widget.outlet.rating),
//                       ],
//                     ),
//                   ],
//                 ),
//                 ElevatedButton(
//                     onPressed: openMaps, child: Text("open in maps"))
//               ],
//             ),
//             // ... other widget elements
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildReviewsList() {
//   return _reviews.map((review) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 60,
//             height: 60,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(50),
//               child: Image.network(
//                   "https://cdn-icons-png.flaticon.com/512/147/147142.png"),
//             ),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       review.user,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                     _buildRatingStars(review.rating),
//                   ],
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 10),
//                   child: SizedBox(
//                     width: 300,
//                     child: Text(
//                       review.body,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }).toList();
// }

//   void addReviewToDatabase(Review review) async {
//     try {
//       Map<String, dynamic> newReviewData = {
//         'user': review.user,
//         'image': review.image,
//         'rating': review.rating,
//         'body': review.body,
//       };

//       await FirebaseFirestore.instance
//           .collection('outlets')
//           .doc(widget.outlet.id)
//           .update({
//         'reviews': FieldValue.arrayUnion([newReviewData]),
//       });

//       setState(() {
//         widget.outlet.reviews.add(review);
//       });

//       // You might also want to recalculate the outlet's average rating here
//     } catch (e) {
//       print('Error adding review to database: $e');
//     }
//   }

//   void _addReview() {
//     if (_reviewController.text.isNotEmpty) {
//       Review newReview = Review(
//         image:
//             'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
//         user: 'User 111', // Replace with the actual user's name or ID
//         rating: _userRating,
//         body: _reviewController.text,
//       );

//       addReviewToDatabase(newReview);

//       _reviewController.clear();
//       _userRating = 0.0;
//       _isAddingReview = false;
//     }
//   }

//   void showNewReview(BuildContext ctx) {
//   bool isReviewEmpty = false;

//   showModalBottomSheet(
//     context: ctx,
//     isScrollControlled: true,
//     builder: (sheetContext) {
//       return Padding(
//         padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
//         child: StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return Container(
//               height: 400,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 30),
//                   Text(
//                     'What is your rating?',
//                     style: TextStyle(fontSize: 25),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 10),
//                   RatingBar.builder(
//                     initialRating: _userRating,
//                     minRating: 1,
//                     direction: Axis.horizontal,
//                     allowHalfRating: true,
//                     itemCount: 5,
//                     itemSize: 50,
//                     itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
//                     itemBuilder: (context, _) => Icon(
//                       Icons.star,
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                     onRatingUpdate: (rating) {
//                       setState(() {
//                         _userRating = rating;
//                       });
//                     },
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Please share your opinion',
//                     style: TextStyle(fontSize: 25),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 10),
//                   TextField(
//                     controller: _reviewController,
//                     decoration: InputDecoration(
//                       hintText: 'Write your review here...',
//                       border: OutlineInputBorder(),
//                     ),
//                     minLines: 3,
//                     maxLines: null,
//                   ),
//                   SizedBox(height: 10),
//                   if (isReviewEmpty)
//                     Text(
//                       'Please enter a review',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_reviewController.text.isEmpty) {
//                         setState(() {
//                           isReviewEmpty = true;
//                         });
//                       } else {
//                         _addReview();
//                         Navigator.of(ctx).pop();
//                       }
//                     },
//                     child: Text('Submit Review'),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       );
//     },
//   );
// }

//  Widget _buildRatingStars(double rating) {
//     int fullStars = rating.floor(); // Extract the whole number part
//     double fraction = rating - fullStars; // Calculate the fractional part

//     List<Widget> stars = List.generate(
//       fullStars,
//       (index) => Icon(
//         Icons.star,
//         color: Theme.of(context).colorScheme.primary,
//         size: 25,
//       ),
//     );
//     int n = 5 - fullStars;
//     if (fraction > 0) {
//       n = n - 1;
//       stars.add(Icon(
//         Icons.star_half,
//         color: Theme.of(context).colorScheme.primary,
//         size: 25,
//       ));
//     }
//     for (int i = 0; i < n; i++) {
//       stars.add(Icon(
//         Icons.star_outline,
//         color: Theme.of(context).colorScheme.primary,
//         size: 25,
//       ));
//     }

//     return Row(children: stars);
//   }

//   @override
//   void dispose() {
//     _reviewController.dispose();
//     super.dispose();
//   }
// }
