import 'package:get/get.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';
import 'firestore_controller.dart';

import 'dart:io';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var privateKey = ''.obs;
  var currentUserEmail = ''.obs; // Add this line to track user email

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
      privateKey.value = response.privKey ?? '';

      String? userEmail = response.userInfo?.email;
      currentUserEmail.value = userEmail ?? ''; // Store the email

      // Check if user exists
      String? existingUserId =
          await firestoreController.getUserDocId(userEmail ?? '');

      if (existingUserId == null) {
        // Only save if user doesn't exist
        Map<String, dynamic> userInfo = {
          "email": userEmail,
          "name": response.userInfo?.name,
          "profileImageUrl": ""
        };

        await firestoreController.saveUserInfo(userInfo);
      }

      Get.offAllNamed('/onboarding');
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Failed to sign in with Google',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await Web3AuthFlutter.logout();
      privateKey.value = "";
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
