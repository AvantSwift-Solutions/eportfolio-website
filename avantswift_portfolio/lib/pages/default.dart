// ignore_for_file: use_key_in_widget_constructors

import 'package:avantswift_portfolio/models/User.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DefaultPage extends StatelessWidget {
  User user;
  DefaultPage({required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Website - ${user.name}'),
      ),
      body: const Center(
        child: Text(
          'Welcome to my website',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
