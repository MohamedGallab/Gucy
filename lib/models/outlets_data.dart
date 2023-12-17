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

  Map<String, dynamic> toJson() =>
      {'user': user, 'image': image, 'rating': rating, 'body': body};

  static Review fromJson(Map<String, dynamic> json) => Review(
        user: json['user'],
        image: json['image'],
        rating: json['rating'].toDouble(),
        body: json['body'],
      );
}

class Outlet {
  String? id;
  final String image;
  final String desc;
  final String name;
  
  final List<Review> reviews;
  final String location;
  
  // Calculate average rating property
  double get rating {
    if (reviews.isEmpty) {
      return 3.0; // Default value when there are no reviews
    } else {
      double totalRating = reviews.fold(0.0, (sum, review) => sum + review.rating);
      return totalRating / reviews.length;
    }
  }

  Outlet({
    required this.image,
    required this.desc,
    required this.name,
    
    required this.reviews,
    required this.location,
  });

  Map<String, dynamic> toJson() => {
        'image': image,
        'desc': desc,
        'name': name,
        
        'reviews': reviews.map((review) => review.toJson()).toList(),
        'location': location,
        'rating': rating, // Include the average rating in toJson()
      };

  static Outlet fromJson(Map<String, dynamic> json) => Outlet(
        image: json['image'],
        desc: json['desc'],
        name: json['name'],
        
        reviews: (json['reviews'] as List)
            .map((reviewJson) => Review.fromJson(reviewJson))
            .toList(),
        location: json['location'],
      );
}
































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

//   Map<String, dynamic> toJson() =>
//       {'user': user, 'image': image, 'rating': rating, 'body': body};

//   static Review fromJson(Map<String, dynamic> json) => Review(
//         user: json['user'],
//         image: json['image'],
//         rating: json['rating'].toDouble(),
//         body: json['body'],
//       );
// }

// class Outlet {
//   final String image;
//   final String desc;
//   final String name;
//   final String office;
//   final List<Review> reviews;
//   final String location;

//   Outlet({
//     required this.image,
//     required this.desc,
//     required this.name,
//     required this.office,
//     required this.reviews,
//     required this.location,
//   });

//   double get averageRating {
//     if (reviews.isEmpty) {
//       return 0.0; // Default value when there are no reviews
//     } else {
//       double totalRating = reviews.fold(0.0, (sum, review) => sum + review.rating);
//       return totalRating / reviews.length;
//     }
//   }

//   Map<String, dynamic> toJson() => {
//         'image': image,
//         'desc': desc,
//         'name': name,
//         'office': office,
//         'reviews': reviews.map((review) => review.toJson()).toList(),
//         'location': location,
//       };

//   static Outlet fromJson(Map<String, dynamic> json) => Outlet(
//         image: json['image'],
//         desc: json['desc'],
//         name: json['name'],
//         office: json['office'],
//         reviews: (json['reviews'] as List)
//             .map((reviewJson) => Review.fromJson(reviewJson))
//             .toList(),
//         location: json['location'],
//       );
// }
