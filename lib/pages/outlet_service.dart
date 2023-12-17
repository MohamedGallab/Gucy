// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/outlets_data.dart';


// Future<List<Outlet>> getOutlets() async {
//   print("abdo1;");
//   CollectionReference outletsCollection =
//       FirebaseFirestore.instance.collection('outlets');
//   QuerySnapshot outletSnapshot = await outletsCollection.get();

//   List<Outlet> allOutlets = [];
//   if (outletSnapshot.docs.isNotEmpty) {
//     for (QueryDocumentSnapshot document in outletSnapshot.docs) {
//       print("abdosaid00");
//       print(document.data());
//       Map<String, dynamic> outletData = document.data() as Map<String, dynamic>;
//       List<dynamic> reviewsData = outletData['reviews'] ?? [];
//       List<Review> reviews = reviewsData.map((review) {
//         return Review.fromJson(review);
//       }).toList();

//       Outlet outlet = Outlet(
//         image: outletData['image'],
//         desc: outletData['desc'],
//         name: outletData['name'],
//         reviews: reviews,
//         location: outletData['location'],
//       );
//       print(outlet.name);
//       allOutlets.add(outlet);
//     }
//   }
  
//   return allOutlets;
// }















// // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:gucians/database/database_references.dart';
// // import 'package:gucy/pages/outlets_page.dart';


// // Future<List<Outlet>> getOutletd() async {
// //   CollectionReference usersCollection =
// //       FirebaseFirestore.instance.collection('outlets');
// //   QuerySnapshot outlets =
// //       await usersCollection.get();
// //   List<Outlet> allOutlets = [];
// //   if (outlets.docs.isNotEmpty) {
// //     for (QueryDocumentSnapshot document in outlets.docs) {
// //       Map<String, dynamic> user = document.data() as Map<String, dynamic>;
// //       user['id'] = document.id;
// //       Outlet userData = UserModel.fromJson(user);
// //       allOutlets.add(userData);
// //     }
// //   }
// //   return allOutlets;
// // }

