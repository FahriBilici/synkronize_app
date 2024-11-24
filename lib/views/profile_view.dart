import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synkronize_app/controllers/firestore_controller.dart';
import 'package:synkronize_app/controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  final FirestoreController firestoreController = Get.find<FirestoreController>();
  final ProfileController profileController = Get.put(ProfileController());
  final ImagePicker _picker = ImagePicker();
  final storage = FirebaseStorage.instance;

  ProfileView({super.key});

  Future<void> uploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final String userId = firestoreController.userId.value;
      final storageRef = storage.ref().child('profile_images/$userId.jpg');

      await storageRef.putFile(File(image.path));
      final imageUrl = await storageRef.getDownloadURL();

      await firestoreController.updateData('users', userId, {'profileImageUrl': imageUrl});
    } catch (e) {
      print('Error uploading image: $e');
      Get.snackbar('Error', 'Failed to upload image');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetch user profile when the view is built
    profileController.fetchUserProfile();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: firestoreController.firestore
                  .collection('users')
                  .doc(firestoreController.userId.value)
                  .snapshots(),
              builder: (context, snapshot) {
                String? imageUrl;
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!['profileImageUrl'] != '') {
                  imageUrl = snapshot.data!.get('profileImageUrl') as String?;
                }

                return Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                      child: imageUrl == null
                          ? CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.camera_alt,
                          size: 60,
                          color: Colors.grey[700],
                        ),
                      )
                          : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.deepPurple,
                        child: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.white,
                          ),
                          onPressed: uploadImage,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Obx(() => Text(
              profileController.name.value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            )),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Age: ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Obx(() => Text(
                  profileController.age.value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                const SizedBox(width: 20),
                const Text(
                  'Gender: ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Obx(() => Text(
                  profileController.gender.value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Add edit functionality here
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}