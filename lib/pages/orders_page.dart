import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter/material.dart';
import 'package:project_4/pages/cart_page.dart';
import 'package:project_4/pages/restaurant_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance.collection('order').get().then((collection) {
      final docs = collection.docs;

      for (final doc in docs) {
        final data = doc.data();
        final orderFromData = Order.fromMap(data);
        orders.add(orderFromData);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: ListView(
        children: [
          for (final order in orders) OrderCard(order: order),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return OrderPage(order: order);
        }));
      },
      child: Card(
        child: Text(
          order.meals.length.toString(),
          style: const TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}

class OrderPage extends StatelessWidget {
  const OrderPage({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          for (final meal in order.meals) MealCard(meal: meal),
        ],
      ),
    );
  }
}
