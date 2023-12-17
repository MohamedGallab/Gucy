import 'package:flutter/material.dart';
import 'package:gucy/pages/staff_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/staff_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:gucy/providers/user_provider.dart';

class StaffProfilePage extends StatefulWidget {
  final Staff staff;

  const StaffProfilePage({Key? key, required this.staff}) : super(key: key);

  @override
  _StaffProfilePageState createState() => _StaffProfilePageState();
}

class _StaffProfilePageState extends State<StaffProfilePage> {
  TextEditingController _reviewController = TextEditingController();
  double _userRating = 0.0;
  List<Review> _reviews = [];
  bool _isAddingReview = false;
  bool hasReview = true;
  @override
  void initState() {
    super.initState();
    _reviews = widget.staff.reviews;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(
      context,
    );
    for (int i = 0; i < widget.staff.reviews.length; i++) {
      if (widget.staff.reviews[i].userId == userProvider.user?.uid) {
        setState(() {
          hasReview = false;
        });
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.staff.name),
      ),
      //hasReview
      floatingActionButton: hasReview
          ? FloatingActionButton(
              onPressed: () {
                print(MediaQuery.of(context).viewInsets.bottom);
                setState(() {
                  _isAddingReview = true;
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
                        child: Image.network(widget.staff.image),
                      ),
                    ),
                    SizedBox(width: 10),
                    //rest
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.staff.title,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.staff.name,
                          style: TextStyle(
                              //color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                        SizedBox(height: 2),
                        _buildRatingStars(widget.staff.rating),
                      ],
                    ),
                  ],
                ),
                // Icon(
                //   Icons.more_vert,
                //   //color: Theme.of(context).colorScheme.primary,
                //   size: 25,
                // ),
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
                  widget.staff.desc,
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

  // Future<void> getDocumentById(String documentId) async {
  //   try {
  //     // Reference to the Firestore collection
  //     CollectionReference staffCollection =
  //         FirebaseFirestore.instance.collection('users');

  //     // Get a specific document by ID
  //     DocumentSnapshot documentSnapshot =
  //         await staffCollection.doc(documentId).get();

  //     // Check if the document exists
  //     if (documentSnapshot.exists) {
  //       // Access the data from the document
  //       Map<String, dynamic> data =
  //           documentSnapshot.data() as Map<String, dynamic>;

  //       // Print or use the data as needed
  //       print("Document data: $data");
  //     } else {
  //       print("Document does not exist");
  //     }
  //   } catch (error) {
  //     print("Error getting document: $error");
  //   }
  // }

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
                        _reviews[i].userName.length>12?_reviews[i].userName.substring(0, 10)+"..":_reviews[i].userName,
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
          final userProvider = Provider.of<UserProvider>(
            context,
          );
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
      CollectionReference staffCollection =
          FirebaseFirestore.instance.collection('staff');
      // Create a new review object
      Review newReview = Review(
        image: userProvider.user?.picture == "" ||
                userProvider.user?.picture == null
            ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"
            : userProvider.user?.picture,
        userId: userProvider.user?.uid as String,
        userName: userProvider.user?.name as String,
        rating: _userRating,
        body: _reviewController.text,
      );

      // Add the new review data to Firestore
      print("review created");
      QuerySnapshot querySnapshot = await staffCollection
          .where('name', isEqualTo: widget.staff.name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document reference if it exists
        DocumentReference staffDocRef = querySnapshot.docs[0].reference;

        try {
          // Update the reviews array of the found outlet document
          await staffDocRef.update({
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
        final userProvider = Provider.of<UserProvider>(
          context,
        );
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
                //widget.staff
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
      for (int i = 0; i < _reviews.length; i++) {
        if (_reviews[i].userId == userProvider.user?.uid) {
          _reviews.removeAt(i);
        } else {
          newList.add(_reviews[i].toJson());
        }
      }
      await FirebaseFirestore.instance
          .collection('staff')
          .doc(widget.staff.id)
          .update({'reviews': newList});
      print('Review deleted successfully!');
    } catch (e) {
      print('Error deleting review: $e');
    }
  }
}
