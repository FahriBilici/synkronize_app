import 'package:get/get.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';
import 'firestore_controller.dart';

import 'dart:io';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  Rx<String?> privateKey = Rx<String?>(null);

  // Add this line to access FirestoreController
  final FirestoreController firestoreController =
      Get.find<FirestoreController>();

  @override
  void onInit() {
    super.onInit();
    initWeb3Auth();
  }

  Future<void> initWeb3Auth() async {
    Uri redirectUrl;
    String clientId =
        'BAqA-_5w1WVADgQrTeEyTD5OaHwLbjVdeEzdzZDySXps0kRldbxyCmUYUKEuDcIlhS4MMqKz98xh5oAsKv0U46o';

    if (Platform.isAndroid) {
      redirectUrl = Uri.parse('com.yourapp://auth');
    } else if (Platform.isIOS) {
      redirectUrl = Uri.parse('com.yourapp://auth');
    } else {
      throw Exception('Unsupported platform');
    }

    await Web3AuthFlutter.init(Web3AuthOptions(
      clientId: clientId,
      network: Network.sapphire_devnet, // Change to mainnet for production
      redirectUrl: redirectUrl,
    ));
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final Web3AuthResponse response = await Web3AuthFlutter.login(
        LoginParams(
          loginProvider: Provider.google,
        ),
      );
      privateKey.value = response.privKey;

      // Extract user info from the response
      Map<String, dynamic> userInfo = {
        "email": response.userInfo?.email,
        "name": response.userInfo?.name,
        "verifierId": response.userInfo?.verifierId,
        // Include other fields as needed
      };

      // Save user info to Firestore
      String userId = await firestoreController.saveUserInfo(userInfo);
      // Store userId for later use if needed

      // Navigate to home page after successful login
      Get.offAllNamed('/home');
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Failed to sign in with Google.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await Web3AuthFlutter.logout();
      privateKey.value = null;
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign out.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
