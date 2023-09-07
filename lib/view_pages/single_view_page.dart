import 'package:flutter/material.dart';
import 'landing_page.dart';

class SinglePageView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _contactKey = GlobalKey();

  void _scrollToContact() {
    final context = _contactKey.currentContext;
    if (context != null) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height -
            kToolbarHeight -
            kBottomNavigationBarHeight, // Adjust height as needed
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              LandingPage(
                scrollToBottom: _scrollToContact, // Scroll to contact
              ),
              const SizedBox(height: 500), // Add some spacing
              ContactSection(
                  key: _contactKey), // Placeholder for contact section
            ],
          ),
        ),
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  ContactSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300], // Placeholder color
      padding: EdgeInsets.all(32.0), // Adjust padding as needed
      child: Column(
        children: [
          const Text(
            'Contact Me',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'This is the contact section content. Add your contact details here.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Handle contact button press
            },
            child: Text('Contact'),
          ),
        ],
      ),
    );
  }
}
