import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController {
  File? profileImage;
  final ImagePicker picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? selectedGender;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Function to log out the user
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  /// Load user profile data from Firestore
  Future<void> loadProfileData() async {
    try {
      DocumentSnapshot snapshot =
          await firestore.collection('profiles').doc('user_profile').get();
      if (snapshot.exists) {
        nameController.text = snapshot['name'] ?? '';
        phoneController.text = snapshot['phone'] ?? '';
        selectedGender = snapshot['gender'];
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  /// Pick an image from the gallery
  Future<void> pickImage(BuildContext context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image picked successfully!')),
      );
    }
  }

  /// Complete and update profile in Firestore
  Future<void> completeProfile(BuildContext context) async {
    try {
      await firestore.collection('profiles').doc('user_profile').set({
        'name': nameController.text,
        'phone': phoneController.text,
        'gender': selectedGender,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile.')),
      );
    }
  }

  /// Delete the user profile from Firestore
  Future<void> deleteProfile(BuildContext context) async {
    try {
      await firestore.collection('profiles').doc('user_profile').delete();
      nameController.clear();
      phoneController.clear();
      selectedGender = null;
      profileImage = null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile deleted successfully!')),
      );
    } catch (e) {
      print('Error deleting profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting profile.')),
      );
    }
  }
}