// controllers/firestore_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Save user info to Firestore with auto-generated ID
  Future<String> saveUserInfo(Map<String, dynamic> userInfo) async {
    // Create document reference with auto-generated ID
    DocumentReference docRef = firestore.collection('users').doc();

    // Get the auto-generated ID
    String userId = docRef.id;

    // Save data with the ID included
    await docRef.set({
      'email': userInfo['email'],
      'name': userInfo['name'],
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return userId;
  }

  // Add data to Firestore
  Future<void> addData(String collection, Map<String, dynamic> data) async {
    await firestore.collection(collection).add(data);
  }

  // Update data in Firestore
  Future<void> updateData(
      String collection, String docId, Map<String, dynamic> data) async {
    await firestore.collection(collection).doc(docId).update(data);
  }

  // Delete data from Firestore
  Future<void> deleteData(String collection, String docId) async {
    await firestore.collection(collection).doc(docId).delete();
  }

  // Get stream of data from Firestore
  Stream<QuerySnapshot> getData(String collection) {
    return firestore.collection(collection).snapshots();
  }
}
