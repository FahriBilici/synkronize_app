// lib/controllers/onboarding_controller.dart
import 'package:get/get.dart';
import 'firestore_controller.dart';

class OnboardingController extends GetxController {
  final FirestoreController firestoreController = Get.find<FirestoreController>();

  Future<void> saveOnboardingInfo(String email, Map<String, dynamic> onboardingInfo) async {
    try {
      await firestoreController.saveUserOnboardingInfo(email, onboardingInfo);
    } catch (e) {
      print('Error saving onboarding info: $e');
    }
  }
}