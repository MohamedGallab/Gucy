import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contacts_data.dart';
// import 'package:gucians/database/database_references.dart';

Future<List<Contacts>> getemergencyNums() async {
  CollectionReference emegencyNumbersCollection =
      FirebaseFirestore.instance.collection('contacts');
  QuerySnapshot emergencyNums = await emegencyNumbersCollection.get();
  List<Contacts> allemergencyNums = [];
  if (emergencyNums.docs.isNotEmpty) {
    for (QueryDocumentSnapshot document in emergencyNums.docs) {
      Contacts emergencyNum =
          Contacts.fromJson(document.data() as Map<String, dynamic>);
      allemergencyNums.add(emergencyNum);
    }
  }
  return allemergencyNums;
}