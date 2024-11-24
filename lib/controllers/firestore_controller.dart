// controllers/firestore_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var userId = ''.obs;

  Future<String> saveUserInfo(Map<String, dynamic> userInfo) async {
    String docId = userInfo['email'] ?? '';
    await firestore.collection('users').doc(docId).set({
      'email': userInfo['email'],
      'name': userInfo['name'],
      'createdAt': FieldValue.serverTimestamp(),
      'profileImageUrl': userInfo['profileImageUrl'],
    });
    userId.value = docId;
    return docId;
  }

  Future<String?> getUserDocId(String email) async {
    try {
      var doc = await firestore.collection('users').doc(email).get();
      if (doc.exists) {
        userId.value = doc.id;
        return doc.id;
      }
      return null;
    } catch (e) {
      print('Error getting user doc ID: $e');
      return null;
    }
  }

  Future<void> addData(String collection, Map<String, dynamic> data) async {
    await firestore.collection(collection).add(data);
  }

  Future<void> updateData(
      String collection, String docId, Map<String, dynamic> data) async {
    await firestore.collection(collection).doc(docId).update(data);
  }

  Future<void> deleteData(String collection, String docId) async {
    await firestore.collection(collection).doc(docId).delete();
  }

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

  // New function to save user's onboarding questions and answers, as well as personal information like age
  Future<void> saveUserOnboardingInfo(String email, Map<String, dynamic> onboardingInfo) async {
    try {
      List<Map<String, String>> questionsAndAnswers = [];
      Map<String, dynamic> questions = onboardingInfo['questions'];
      questions.forEach((question, answer) {
        questionsAndAnswers.add({'question': question, 'answer': answer});
      });

      await firestore.collection('users').doc(email).update({
        'age': onboardingInfo['age'],
        'onboardingQuestions': questionsAndAnswers,
      });
    } catch (e) {
      print('Error saving user onboarding info: $e');
    }
  }
}