// user_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AnalyticsProvider with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String currentPage = "Confessions";
  DateTime? lastPageEntryTime = DateTime.now();

  Future<void> changePage(String newPage, String uid) async {
    print(newPage + "NEW");
    print(currentPage + "CUrrent");
    await _updateTimeSpentOnPage();
    await _updateTimeSpentOnPageForUser(uid);

    lastPageEntryTime = null;
    currentPage = newPage;
    lastPageEntryTime = DateTime.now();
    notifyListeners();
  }

  Future<void> _updateTimeSpentOnPageForUser(String uid) async {
    var timeSpent = DateTime.now().difference(lastPageEntryTime!).inSeconds;
    final collectionRef = db.collection("analytics");

    final query = collectionRef.where("uid", isEqualTo: uid);
    await query.get().then((querySnapshot) => {
          querySnapshot.docs.forEach((doc) => doc.reference
              .update({currentPage: FieldValue.increment(timeSpent)}))
        });
  }

  Future<void> _updateTimeSpentOnPage() async {
    if (lastPageEntryTime == null) return;
    var timeSpent = DateTime.now().difference(lastPageEntryTime!).inSeconds;
    await db
        .collection('analytics')
        .doc('Global Analytics')
        .update({currentPage: FieldValue.increment(timeSpent)});
  }

  Future<void> clickPost(String post, String uid) async {
    await _updatePost(post);
    await _updatePostForUser(post, uid);
    notifyListeners();
  }

  Future<void> _updatePostForUser(String post, String uid) async {
    final collectionRef = db.collection("analytics");

    final query = collectionRef.where("uid", isEqualTo: uid);
    print(post);

    await query.get().then((querySnapshot) => {
          querySnapshot.docs.forEach(
              (doc) => doc.reference.update({post: FieldValue.increment(1)}))
        });
  }

  Future<void> _updatePost(String post) async {
    if (lastPageEntryTime == null) return;

    await db
        .collection('analytics')
        .doc('Global Analytics')
        .update({post: FieldValue.increment(1)});
  }

  Future<void> changeAction(String action, String uid) async {
    final collectionRef = db.collection("analytics");
    final query = collectionRef.where("uid", isEqualTo: uid);

    await query.get().then((querySnapshot) => {
          querySnapshot.docs
              .forEach((doc) => doc.reference.update({"Action": action}))
        });
  }

  DateTime? lastScrollingTime = DateTime.now();
  DateTime? lastNonScrollingTime = DateTime.now();
  Future<void> setScrolling(bool isScrolling, String iod) async {
    if (isScrolling) {
      var timeSpentNotScrolling =
          DateTime.now().difference(lastNonScrollingTime!).inSeconds;
      final collectionRef = db.collection("analytics");
      final query = collectionRef.where("uid", isEqualTo: iod);

      await query.get().then((querySnapshot) => {
            querySnapshot.docs.forEach((doc) => doc.reference.update({
                  "Time Spent Not Scrolling":
                      FieldValue.increment(timeSpentNotScrolling)
                }))
          });
      lastScrollingTime = DateTime.now();
    } else {
      var timeSpentScrolling =
          DateTime.now().difference(lastScrollingTime!).inSeconds;
      final collectionRef = db.collection("analytics");
      final query = collectionRef.where("uid", isEqualTo: iod);

      await query.get().then((querySnapshot) => {
            querySnapshot.docs.forEach((doc) => doc.reference.update({
                  "Time Spent Scrolling":
                      FieldValue.increment(timeSpentScrolling)
                }))
          });
      lastNonScrollingTime = DateTime.now();
    }
  }
}
