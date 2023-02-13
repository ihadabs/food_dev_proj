import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_4/app.dart';
import 'package:project_4/pages/orders_page.dart';
import 'package:project_4/pages/restaurant_page.dart';

import 'cart_page.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  List<Restaurant> restaurants = [];
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();

    listenToRestaurants();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  listenToRestaurants() {
    subscription ??= FirebaseFirestore.instance.collection('restaurant').snapshots().listen((collection) {
      List<Restaurant> newList = [];
      for (final doc in collection.docs) {
        final restaurant = Restaurant.fromMap(doc.data());
        newList.add(restaurant);
      }

      restaurants = newList;
      setState(() {});
    });
  }

  Future<List<Restaurant>> getRestaurants() async {
    final collection = await FirebaseFirestore.instance.collection('restaurant').get();
    List<Restaurant> newList = [];
    for (final doc in collection.docs) {
      final restaurant = Restaurant.fromMap(doc.data());
      newList.add(restaurant);
    }

    return newList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const CartPage();
                  },
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.shopping_cart_checkout, size: 30),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const OrdersPage();
                  },
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.receipt_long_outlined, size: 30),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'Home'),
        ],
      ),
      body: ListView(
        children: [
          for (final res in restaurants) RestaurantCard(restaurant: res),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              // FirebaseAuth.instance.sendPasswordResetEmail(email: 'gg@axenda.io');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RestaurantPage(restaurant: restaurant),
          ),
        );
      },
      child: Card(
        child: Column(
          children: [
            Text(
              restaurant.name,
              style: const TextStyle(fontSize: 40),
            ),
            Text(
              restaurant.address,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
