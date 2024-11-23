import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'controllers/auth_controller.dart';
import 'views/login_view.dart';
import 'views/home_view.dart';
import 'views/onboarding_view.dart';
import 'views/dating_view.dart';
import 'views/social_view.dart';
import 'views/profile_view.dart';
import 'views/stake_solana_view.dart';
import 'controllers/firestore_controller.dart';
import 'bindings/auth_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dating App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialBinding: AuthBinding(), // Add this line
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/onboarding', page: () => const OnboardingView()),
        GetPage(name: '/login', page: () => const LoginView()),
        GetPage(name: '/home', page: () => const HomeView()),
        GetPage(name: '/dating', page: () => const DatingView()),
        GetPage(name: '/social', page: () => const SocialView()),
        GetPage(name: '/profile', page: () => const ProfileView()),
        GetPage(name: '/stake_solana', page: () => const StakeSolanaView()),
      ],
    );
  }
}
