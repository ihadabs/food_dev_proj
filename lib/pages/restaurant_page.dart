import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_4/app.dart';
import 'package:project_4/pages/nav_page.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  List<Meal> mealsToShow = [];
  StreamSubscription? listener;

  @override
  void initState() {
    super.initState();

    final mealCollection = FirebaseFirestore.instance.collection('meal');

    final onlyRestaurantMealCollection = mealCollection.where(
      'restaurant_id',
      isEqualTo: widget.restaurant.id,
    );

    onlyRestaurantMealCollection.snapshots().listen((collection) {
      final docs = collection.docs;
      List<Meal> newList = [];
      for (final doc in docs) {
        final data = doc.data();
        final mealFromData = Meal.fromMap(data);
        newList.add(mealFromData);
      }

      mealsToShow = newList;
      setState(() {});
    });
  }

  @override
  void dispose() {
    listener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
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
          RestaurantCard(restaurant: widget.restaurant),
          for (final meal in mealsToShow) MealCard(meal: meal),
        ],
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.meal,
  });

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.network(
              meal.imageUrl,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
            Text(
              meal.name,
              style: const TextStyle(fontSize: 30),
            ),
          ],
        ),
        Text(
          meal.price.toString(),
          style: const TextStyle(fontSize: 30),
        ),
        ElevatedButton(
          onPressed: () {
            FirebaseFirestore.instance.collection('cart').doc(meal.id).set(meal.toMap());
          },
          child: const Icon(Icons.shopping_cart_checkout),
        ),
        ElevatedButton(
          onPressed: () {
            FirebaseFirestore.instance.collection('cart').doc(meal.id).delete();
          },
          child: const Icon(Icons.delete_forever),
        ),
      ],
    );
  }
}
