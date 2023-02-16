import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.title = ''});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  /// Pick an image
                  print('1: Pick an image');
                  final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

                  /// Return if user canceled
                  if (image == null) {
                    print('2: User canceled');
                    return;
                  }

                  /// Upload to firebase storage
                  print('3: Uploading...');
                  final ref = FirebaseStorage.instance.ref().child("bills/55/33.jpeg");
                  await ref.putFile(File(image.path));
                  final url = await ref.getDownloadURL();

                  print('4: Save in Firestore');
                  final profilesCollection = FirebaseFirestore.instance.collection('profile');
                  final userProfileDocument = profilesCollection.doc(FirebaseAuth.instance.currentUser?.uid);
                  userProfileDocument.set({'photo_url': url}, SetOptions(merge: true));
                } catch (e) {
                  print('GG Upload error: $e');
                }
              },
              child: const Text('Upload imagee'),
            ),
            if (isLoading)
              Container(
                constraints: const BoxConstraints(maxWidth: 50, maxHeight: 50),
                height: 50,
                width: 50,
                child: const CircularProgressIndicator(color: Colors.green),
              ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(hintText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final password = passwordController.text;

                setState(() {
                  isLoading = true;
                });

                try {
                  final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                } catch (error) {
                  print(error);
                }

                setState(() {
                  isLoading = false;
                });

                // print(result);
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
