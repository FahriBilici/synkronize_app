// controllers/firestore_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var userId = ''.obs; // Add this line to track user ID

  // Modified saveUserInfo function that returns document ID
  Future<String> saveUserInfo(Map<String, dynamic> userInfo) async {
    String docId = userInfo['email'] ?? ''; // Using email as document ID
    await firestore.collection('users').doc(docId).set({
      'email': userInfo['email'],
      'name': userInfo['name'],
      'createdAt': FieldValue.serverTimestamp(),
      'profileImageUrl': userInfo['profileImageUrl'],
      // Add other fields you want to save
    });
    userId.value = docId; // Store the user ID
    return docId;
  }

  // Add this function to get user doc ID by email
  Future<String?> getUserDocId(String email) async {
    try {
      var doc = await firestore.collection('users').doc(email).get();
      if (doc.exists) {
        userId.value = doc.id; // Store the user ID
        return doc.id;
      }
      return null;
    } catch (e) {
      print('Error getting user doc ID: $e');
      return null;
    }
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

  Future<bool> checkUserExists(String email) async {
    QuerySnapshot query = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }
}
