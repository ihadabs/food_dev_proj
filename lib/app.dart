import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_4/pages/home_page.dart';
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
      final restaurantCollection = FirebaseFirestore.instance.collection('restaurant');
      final resDoc = restaurantCollection.doc(res.id);
      resDoc.set(res.toMap());
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
