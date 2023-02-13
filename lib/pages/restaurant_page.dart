import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
