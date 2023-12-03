
import 'package:flutter/material.dart';
import 'package:gucy/pages/outlets_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.outlet.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display outlet details
            Text(
              widget.outlet.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Location: ${widget.outlet.location}',
              style: TextStyle(fontSize: 18),
            ),
            // Display other outlet information
            // ...

            // Display outlet reviews
            if (_reviews.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Reviews:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildReviewsList(),
                  ),
                ],
              ),

            // Floating Action Button to add review
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _isAddingReview = true;
                    });
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ),

            // Add a review form
            if (_isAddingReview)
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rate this Outlet:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    RatingBar.builder(
                      initialRating: _userRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 30,
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
                      },
                      child: Text('Submit Review'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildReviewsList() {
    return _reviews.map((review) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User: ${review.user}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('Rating: ${review.rating}'),
          Text(review.body),
          Divider(),
        ],
      );
    }).toList();
  }

  void _addReview() {
    if (_reviewController.text.isNotEmpty) {
      setState(() {
        _reviews.add(
          Review(
            user: 'User', // Replace with the actual user's name or ID
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
}


