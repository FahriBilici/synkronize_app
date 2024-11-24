import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../controllers/auth_controller.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  final OnboardingController _onboardingController = Get.find<OnboardingController>();
  final AuthController _authController = Get.find<AuthController>();

  int _currentPage = 0;
  final List<Map<String, String>> _questions = [
    {'question': 'What\'s your ideal way to spend a weekend?'},
    {'question': 'How do you usually handle conflicts?'},
    {'question': 'What’s most important in a relationship?'},
    {'question': 'Which type of activity excites you most?'},
    {'question': 'How do you prefer to plan your life?'},
  ];

  final Map<String, String> _answers = {};
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _questions.length) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _saveOnboardingInfo();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _saveOnboardingInfo() async {
    String email = _authController.currentUserEmail.value;
    Map<String, dynamic> onboardingInfo = {
      'age': _ageController.text,
      'questions': _answers,
    };

    await _onboardingController.saveOnboardingInfo(email, onboardingInfo);
    Get.offAllNamed('/stake_solana');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentPage + 1} of ${_questions.length + 1}'),
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: _questions.length + 1,
        itemBuilder: (context, index) {
          if (index < _questions.length) {
            return _buildQuestionPage(_questions[index]['question']!, index);
          } else {
            return _buildFinalPage();
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentPage > 0)
              Expanded(
                child: ElevatedButton(
                  onPressed: _previousPage,
                  child: const Text('Back'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _nextPage,
                child: Text(_currentPage == _questions.length
                    ? 'Finish'
                    : 'Next'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionPage(String question, int index) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              question,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                _answers[question] = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your answer',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Please provide the following information:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Age',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _genderController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Gender',
              ),
            ),
          ],
        ),
      ),
    );
  }
}