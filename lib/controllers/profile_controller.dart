import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_controller.dart';

class ProfileController extends GetxController {
  final FirestoreController firestoreController = Get.find<FirestoreController>();

  var name = ''.obs;
  var age = ''.obs;
  var gender = ''.obs;

  void fetchUserProfile() async {
    try {
      String userId = firestoreController.userId.value;
      DocumentSnapshot userDoc = await firestoreController.firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        name.value = userDoc['name'] ?? '';
        age.value = userDoc['age']?.toString() ?? '';
        gender.value = userDoc['gender'] ?? '';
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }
}