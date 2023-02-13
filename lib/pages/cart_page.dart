import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_4/app.dart';
import 'package:project_4/pages/restaurant_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Meal> cartMeals = [];
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();

    subscription ??= FirebaseFirestore.instance.collection('cart').snapshots().listen((collection) {
      final docs = collection.docs;
      final List<Meal> someList = [];
      for (final doc in docs) {
        final data = doc.data();
        final mealFromData = Meal.fromMap(data);
        someList.add(mealFromData);
      }

      cartMeals = someList;
      setState(() {});
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: ListView(
        children: [
          for (final meal in cartMeals) MealCard(meal: meal),
          ElevatedButton(
            onPressed: () {
              final order = Order(meals: cartMeals);
              FirebaseFirestore.instance.collection('order').add(order.toMap());
              for (final meal in cartMeals) {
                FirebaseFirestore.instance.collection('cart').doc(meal.id).delete();
              }
            },
            child: const Text('Place Order'),
          ),
        ],
      ),
    );
  }
}

class Order {
  final List<Meal> meals;

  const Order({
    required this.meals,
  });

  Map<String, dynamic> toMap() {
    return {
      'meals': meals.map((m) => m.toMap()).toList(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      meals: (map['meals'] as List).map((e) => Meal.fromMap(e)).toList(),
    );
  }
}
