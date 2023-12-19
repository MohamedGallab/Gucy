import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gucy/models/outlets_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:gucy/providers/user_provider.dart';

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
  bool hasReview = true;

  @override
  void initState() {
    super.initState();
    _reviews = widget.outlet.reviews;
  }

  openMaps() {
    _launcjMaps(widget.outlet.location);
  }

  void _launcjMaps(String location) async {
    Uri url = Uri.parse(location);
    try {
      await launchUrl(url);
    } catch (e) {
      print('can not open: $e');
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    for (int i = 0; i < widget.outlet.reviews.length; i++) {
      if (widget.outlet.reviews[i].userId == userProvider.user?.uid) {
        setState(() {
          hasReview = false;
        });
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.outlet.name),
      ),
      floatingActionButton: hasReview
          ? FloatingActionButton(
              onPressed: () {
                print(MediaQuery.of(context).viewInsets.bottom);
                setState(() {
                  showNewReview(context);
                });
              },
              child: Icon(Icons.add),
            )
          : null,
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
                ElevatedButton(
                    onPressed: openMaps,
                    child: Row(
                      children: [
                        Icon(Icons.map),
                      ],
                    ))
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
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
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Phone number",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    try {
                                      String temp = widget.outlet.number;
                                      Uri phoneno = Uri.parse('tel:$temp');
                                      launchUrl(phoneno);
                                    } catch (e) {
                                      print('Error calling phone number: $e');
                                    }
                                  },
                                  child: Text(
                                    widget.outlet.number,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Display outlet reviews
            SizedBox(height: 10),
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
                    children: _buildReviewsList(userProvider),
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

  List<Widget> _buildReviewsList(userProvider) {
    List<Widget> widgets = [];
    for (int i = 0; i < _reviews.length; i++) {
      if (userProvider.user?.uid == _reviews[i].userId) {
        setState(() {
          hasReview = false;
          print("has review?" + hasReview.toString());
        });
        widgets.insert(
            0,
            Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(_reviews[i].image),
                      ),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            SizedBox(width: 10),
                            Container(
                              width: 150,
                              child: Text(
                                "You",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            //SizedBox(width: 110),
                            Container(
                              child: _buildRatingStars(_reviews[i].rating),
                            ),
                            Container(
                                width: 20,
                                child: IconButton(
                                    icon: Icon(Icons.clear),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer,
                                    onPressed: () {
                                      setState(() {
                                        _showDeleteConfirmationDialog(context);
                                      });
                                    })),
                          ]),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: SizedBox(
                                  width: 300,
                                  child: Text(
                                    _reviews[i].body,
                                  ))),
                        ])
                  ],
                )));
      } else {
        widgets.add(Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(_reviews[i].image),
                  ),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    SizedBox(width: 10),
                    Container(
                      width: 150,
                      child: Text(
                        _reviews[i].userName.length > 12
                            ? _reviews[i].userName.substring(0, 10) + ".."
                            : _reviews[i].userName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    //SizedBox(width: 110),
                    Container(
                      child: _buildRatingStars(_reviews[i].rating),
                    )
                  ]),
                  Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: SizedBox(
                          width: 300,
                          child: Text(
                            _reviews[i].body,
                          ))),
                ])
              ],
            )));
      }
    }
    return widgets;
    // return _reviews.map((review) {
    //   return Padding(
    //       padding: EdgeInsets.only(bottom: 10),
    //       child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Container(
    //             width: 60,
    //             height: 60,
    //             child: ClipRRect(
    //               borderRadius: BorderRadius.circular(50),
    //               child: Image.network(review.image),
    //             ),
    //           ),
    //           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    //             Row(children: [
    //               SizedBox(width: 10),
    //               Container(
    //                 width: 150,
    //                 child: Text(
    //                   userProvider.user?.uid == review.userId
    //                       ? review.userName + "*"
    //                       : review.userName,
    //                   style:
    //                       TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    //                 ),
    //               ),
    //               //SizedBox(width: 110),
    //               Container(
    //                 child: _buildRatingStars(review.rating),
    //               )
    //             ]),
    //             Padding(
    //                 padding: EdgeInsets.only(left: 10),
    //                 child: SizedBox(
    //                     width: 300,
    //                     child: Text(
    //                       review.body,
    //                     ))),
    //           ])
    //         ],
    //       ));
    // }).toList();
  }

  void showNewReview(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        builder: (sheetContext) {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          print(hasReview);
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
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
                        color: Colors.amber,
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
                    ElevatedButton(
                      onPressed: () {
                        _addReview(userProvider);
                        Navigator.of(context).pop();
                      },
                      child: Text('Submit Review'),
                    ),
                  ],
                ),
              ));
        });
  }

  void _addReview(userProvider) async {
    if (_reviewController.text.isNotEmpty) {
      setState(() {
        hasReview = false;
      });
      print("review not created");
      // Create a reference to the 'outlets' collection in Firestore
      CollectionReference outletCollection =
          FirebaseFirestore.instance.collection('outlets');
      // Create a new review object
      Review newReview = Review(
        image: userProvider.user?.picture == "" ||
                userProvider.user?.picture == null
            ? "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Windows_10_Default_Profile_Picture.svg/768px-Windows_10_Default_Profile_Picture.svg.png?20221210150350"
            : userProvider.user?.picture,
        userId: userProvider.user?.uid as String,
        userName: userProvider.user?.name as String,
        rating: _userRating,
        body: _reviewController.text,
      );

      // Add the new review data to Firestore
      print("review created");
      QuerySnapshot querySnapshot = await outletCollection
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

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform delete action here
                // Add your delete logic here
                //widget.outlet
                setState(() {
                  hasReview = true;
                  deleteReview(userProvider);
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteReview(userProvider) async {
    try {
      List newList = [];
      int remove = -1;
      for (int i = 0; i < _reviews.length; i++) {
        if (_reviews[i].userId == userProvider.user?.uid) {
          remove = i;
        } else {
          newList.add(_reviews[i].toJson());
        }
      }
      if (remove > -1) _reviews.removeAt(remove);
      await FirebaseFirestore.instance
          .collection('outlets')
          .doc(widget.outlet.id)
          .update({'reviews': newList});
      print('Review deleted successfully!');
    } catch (e) {
      print('Error deleting review: $e');
    }
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
