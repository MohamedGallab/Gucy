import 'package:flutter/material.dart';
import 'package:gucy/pages/staff_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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

  @override
  void initState() {
    super.initState();
    _reviews = widget.staff.reviews;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.staff.name),
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
                Icon(
                  Icons.more_vert,
                  //color: Theme.of(context).colorScheme.primary,
                  size: 25,
                ),
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
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  SizedBox(width: 10),
                  Text(
                    review.user,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(width: 110),
                  _buildRatingStars(review.rating),
                ]),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: SizedBox(
                    width: 300,
                    child:Text(
                      review.body,
                      //"asasd asdasd asdf asdasd as das d asd as das d asd asd sad as d asd asd"
                      //style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
              ])
            ],
          ));
    }).toList();
  }

  void showNewReview(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        builder: (sheetContext) {
          return 
          Padding(
          padding: EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom),
          child:Container(
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
                    _addReview();
                    Navigator.of(context).pop();
                  },
                  child: Text('Submit Review'),
                ),
              ],
            ),
          ));
        });
  }

  void _addReview() {
    if (_reviewController.text.isNotEmpty) {
      setState(() {
        _reviews.add(
          Review(
            user: 'User X', // Replace with the actual user's name or ID
            rating: _userRating,
            body: _reviewController.text,
          ),
        );
        _reviewController.clear();
        _userRating = 0.0;
        _isAddingReview = false; // Close review form after submitting
      });
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
}
