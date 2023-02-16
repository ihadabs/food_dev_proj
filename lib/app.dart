import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_4/pages/login_page.dart';
import 'package:project_4/pages/nav_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      isLoggedIn = user != null;
      setState(() {});
    });

    for (final res in restaurantList) {
      FirebaseFirestore.instance.collection('restaurant').doc(res.id).set(res.toMap());
    }

    for (final meal in meals) {
      FirebaseFirestore.instance.collection('meal').doc(meal.id).set(meal.toMap());
    }

    // tryStorageUpload();
  }

  tryStorageUpload() async {
    try {
      // Create a reference to the file to delete
      final appDocDir = await getApplicationDocumentsDirectory();
      final file = File('${appDocDir.absolute}/assets/bills/book_1.jpeg');

      final ref = FirebaseStorage.instance.ref().child("bills/1/1.jpeg");
      ref.putFile(file);
    } catch (e) {
      print('GG Upload error: $e');
    }
  }

  tryStorageDelete() async {
    try {
      // Create a reference to the file to delete
      final desertRef = FirebaseStorage.instance.ref().child("books_covers/yellow/yellow.avif");

      // Delete the file
      await desertRef.delete();
    } catch (e) {
      // print('Some error gg: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLoggedIn ? const NavPage() : const LoginPage(),
    );
  }
}

class Restaurant {
  final String id;
  final String name;
  final String address;

  const Restaurant({
    required this.id,
    required this.name,
    required this.address,
  });

  @override
  String toString() {
    return 'Restaurant $id $name $address';
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'],
      name: map['name'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
    };
  }
}

class Meal {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String restaurantId;

  const Meal({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.restaurantId,
  });

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'],
      name: map['name'],
      imageUrl: map['image_url'],
      price: map['price'],
      restaurantId: map['restaurant_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'price': price,
      'restaurant_id': restaurantId,
    };
  }
}

const restaurantList = [
  Restaurant(
    id: '1',
    name: 'شاورمر',
    address: 'الرياض، طريق الثمامة',
  ),
  Restaurant(
    id: '2',
    name: 'الطازج',
    address: 'الرياض، طريق الملك عبدالله',
  ),
  Restaurant(
    id: '3',
    name: 'كودو',
    address: 'الشرقية، شارع الكورنيش',
  ),
];

const meals = [
  Meal(
    id: '1',
    name: 'شاورما',
    imageUrl:
        'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2676&q=80',
    price: 5,
    restaurantId: '1',
  ),
  Meal(
    id: '2',
    name: 'شبرجر',
    imageUrl:
        'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2676&q=80',
    price: 7,
    restaurantId: '1',
  ),
  Meal(
    id: '3',
    name: 'فروج',
    imageUrl:
        'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2676&q=80',
    price: 7,
    restaurantId: '2',
  ),
  Meal(
    id: '4',
    name: 'بروستد',
    imageUrl:
        'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2676&q=80',
    price: 7,
    restaurantId: '2',
  ),
  Meal(
    id: '5',
    name: 'بسبوسة',
    imageUrl:
        'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2676&q=80',
    price: 7,
    restaurantId: '2',
  ),
  Meal(
    id: '6',
    name: 'كبسة',
    imageUrl:
        'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2676&q=80',
    price: 7,
    restaurantId: '2',
  ),
];
