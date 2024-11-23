import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/firestore_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FirestoreController(), permanent: true);
    Get.put(AuthController(), permanent: true);
  }
}
