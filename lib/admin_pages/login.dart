import 'package:avantswift_portfolio/ui/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avantswift_portfolio/models/User.dart' as model;
import 'package:avantswift_portfolio/services/auth_state.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../ui/custom_texts/public_view_text_styles.dart';

class LoginPage extends StatefulWidget {
  final Function(model.User) onLoginSuccess;
  final AuthState authState;

  const LoginPage(
      {super.key, required this.onLoginSuccess, required this.authState});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double titleFontSize = screenWidth * 0.05;

    return Scaffold(
      body: Center(
        child: Row(
          children: [
            // Left Column
            Expanded(
              flex: 4,
              child: Container(
                color: const Color(0xFFF6F7F9),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: FractionallySizedBox(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Welcome Back!',
                                style: PublicViewTextStyles.generalHeading.copyWith(
                                  fontSize: titleFontSize * 0.8,
                                ),
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/login_graphic.svg',
                              width: 450,
                              height: 450,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Right Column
            Expanded(
              flex: 6,
              child: Container(
                margin: const EdgeInsets.only(bottom: 30.0),
                color: Colors.white, // White background color
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(115.0, 0, 100.0, 0), // 50px padding on left and right
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sign in to start editing\nyour portfolio.',
                          style: PublicViewTextStyles.generalHeading.copyWith(
                            fontSize: titleFontSize * 0.8,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Powered by',
                              style: PublicViewTextStyles.generalHeading.copyWith(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8), // Add some spacing between text and image
                          Image.asset(
                            'assets/logo-no-background.png',
                            width: 90, // Adjust the width as needed
                            height: 90, // Adjust the height as needed
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 650.0,
                          height: 60.0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
                              color: const Color(0xFFEDECEC), // Set the background color
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Container(
                                  width: 50, // Adjust the width as needed
                                  height: 50, // Adjust the height as needed
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Set the background color to white
                                    borderRadius: BorderRadius.circular(5), // Adjust the radius as needed
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/email_icon.svg', // Replace with the path to your email SVG icon
                                    width: 25, // Adjust the width as needed
                                    height: 25, // Adjust the height as needed
                                  ),
                                ), 
                                Expanded(
                                  child: TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      labelText: 'Enter your email here',
                                      border: InputBorder.none, // Remove the default border
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0), // Optional padding
                                    ),
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Please enter an email';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 650.0,
                          height: 60.0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
                              color: const Color(0xFFEDECEC), // Set the background color
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Container(
                                  width: 50, // Adjust the width as needed
                                  height: 50, // Adjust the height as needed
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Set the background color to white
                                    borderRadius: BorderRadius.circular(5), // Adjust the radius as needed
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/password_icon.svg', 
                                    width: 25, // Adjust the width as needed
                                    height: 25, // Adjust the height as needed
                                  ),
                                ), 
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _passwordController,
                                          decoration: const InputDecoration(
                                            labelText: 'Enter your password here',
                                            border: InputBorder.none, // Remove the default border
                                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0), // Optional padding
                                          ),
                                          obscureText: _obscureText, // Use a boolean variable to toggle obscureText
                                          validator: (value) {
                                            if (value?.isEmpty ?? true) {
                                              return 'Please enter your password';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50, // Adjust the width as needed
                                        height: 50, // Adjust the height as needed
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _obscureText = !_obscureText; // Toggle the obscureText property
                                            });
                                          },
                                          style: ButtonStyle(
                                                overlayColor: MaterialStateProperty.all(Colors.transparent), // Remove hover effect
                                          ),
                                          child: Icon(
                                            _obscureText ? Icons.visibility : Icons.visibility_off,
                                            size: 24,
                                            color: _obscureText ? const Color(0xFF0074D9) : const Color(0xFF0074D9),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight, // Align to the right
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0), // Add padding around the text
                            child: Text(
                              'Forgot my password',
                              style: PublicViewTextStyles.buttonText.copyWith(
                                fontSize: 15, 
                                color: const Color(0xFF0074D9),
                                fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 650.0,
                          height: 60.0,
                          child: CustomButton(
                            text: Text(
                              'Login',
                              style: PublicViewTextStyles.buttonText,
                            ),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _loginWithEmailAndPassword();
                              }
                            },
                          ),
                        ),
                      ),                     
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }




  Future<void> _loginWithEmailAndPassword() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final UserCredential? userCredential =
          await widget.authState.signInWithEmailAndPassword(email, password);

      if (userCredential != null) {
        final User? firebaseUser = userCredential.user;

        if (firebaseUser != null) {
          final uid = firebaseUser.uid;

          final DocumentSnapshot userDocument = await FirebaseFirestore.instance
              .collection('User')
              .doc(uid)
              .get();

          final currentUser = model.User.fromDocumentSnapshot(userDocument);

          widget.onLoginSuccess(currentUser);
        }
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Error'),
            content: const Text('Failed to log in. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // print('Login Error: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Error'),
          content: const Text('Failed to log in. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
