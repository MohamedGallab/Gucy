// user_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gucy/models/user_data.dart';

class UserProvider extends ChangeNotifier {
  UserData? _user = null;
  FirebaseFirestore db = FirebaseFirestore.instance;
  String _email = "";

  UserData? get user => _user;
  String get email => _email;

  bool get isAuthenticated => _user != null;

  UserProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      _email = "";
      if (user == null) {
        _user = null;
        _email = "";
      } else {
        var docRef = db.collection("users").doc(user.uid);
        DocumentSnapshot doc = await docRef.get();
        final data = doc.data() as Map<String, dynamic>;
        _user = UserData.fromJson(data);
        _email = user.email!;
      }
      notifyListeners();
    });
  }

  Future<String> registerUser(String email, String password) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);

      var user = {
        "uid": userCredential.user!.uid,
        "name": convertEmailToName(email),
        "picture": "",
        "score": 0,
        "eventPermission": (email.contains("student")) ? "None" : "All"
      };

      await db.collection("users").doc(userCredential.user!.uid).set(user);
      _email = userCredential.user!.email!;

      Map<String, dynamic> analytics = {
        "uid": userCredential.user!.uid,
      };
      await db.collection("analytics").doc().set(analytics);

      await userCredential.user!.sendEmailVerification();
      notifyListeners();

      return "success";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String> loginUser(String email, String password) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instanceFor(app: app).signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user!.emailVerified == false) {
        return "email-not-verified";
      } else {
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      }
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .snapshots()
          .listen(
        (DocumentSnapshot snapshot) {
          if (snapshot.exists) {
            final data = snapshot.data() as Map<String, dynamic>;
            _user = UserData.fromJson(data);
            _email = userCredential.user!.email!;
            notifyListeners();
          }
        },
      );
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String> updateUser(UserData user) async {
    try {
      await db.collection("users").doc(user.uid).update(user.toJson());
      _user = user;

      notifyListeners();
      return "success";
    } on FirebaseException catch (e) {
      return e.code;
    }
  }

  Future<String> setToken(FirebaseMessaging fbm) async {
    try {
      final token = await fbm.getToken();
      await db.collection('users').doc(_user?.uid).set(
        {'token': token},
        SetOptions(
            merge:
                true), // Use merge: true to add the field if it doesn't exist
      );
      return "success";
    } on FirebaseException catch (e) {
      return e.code;
    }
  }


  Future<void> sendVerification(String email, String password) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instanceFor(app: app).signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.sendEmailVerification();
      notifyListeners();
    } catch (e) {
      print(e);

  Future<String> removeToken() async {
    try {
      await db.collection('users').doc(_user?.uid).update(
        {'token': ""},
      );
      return "success";
    } on FirebaseException catch (e) {
      return e.code;

    }
  }

  Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
    _email = "";

    notifyListeners();
  }

  String convertEmailToName(String email) {
    // Split the email address by '@' and '.' to extract the name
    List<String> parts = email.split('@')[0].split('.');

    // Convert each part to title case
    List<String> titleCaseParts = parts.map((part) {
      return part[0].toUpperCase() + part.substring(1);
    }).toList();

    // Combine the title case parts to get the full name
    String fullName = titleCaseParts.join(' ');

    return fullName;
  }
}
