// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class DefaultPageNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Website 2'),
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
