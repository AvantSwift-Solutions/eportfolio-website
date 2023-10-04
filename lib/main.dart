import 'package:avantswift_portfolio/controllers/login_controller.dart';
import 'package:avantswift_portfolio/models/User.dart';
import 'package:avantswift_portfolio/admin_pages/default.dart';
import 'package:avantswift_portfolio/services/auth_state.dart';
import 'package:avantswift_portfolio/view_pages/single_view_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'admin_pages/reset_password.dart';
import 'firebase_options.dart';
import 'package:avantswift_portfolio/admin_pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final AuthState authState = AuthState(); // Create an instance of AuthState

  runApp(MyApp(authState: authState));
}

class MyApp extends StatefulWidget {
  final AuthState authState;

  const MyApp({required this.authState, Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final LoginController loginController = LoginController();

  @override
  void initState() {
    super.initState();
    mapAuthentication(); // Map authenticated user to local user model
  }

  Future<User?> mapAuthentication() async {
    final auth.User? firebaseUser = widget.authState.getCurrentUser();
    if (firebaseUser != null) {
      final userDocument = await FirebaseFirestore.instance
          .collection('User')
          .doc(firebaseUser.uid)
          .get();
      final currentUser = User.fromDocumentSnapshot(userDocument);
      loginController.onLoginSuccess(currentUser);
      return currentUser;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steven Zhou',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.black),
      ),
      initialRoute: '',
      debugShowCheckedModeBanner: false,
      routes: {
        '': (context) => SinglePageView(),
        '/login': (context) => LoginPage(
              authState: widget.authState,
              onLoginSuccess: (user) {
                loginController.onLoginSuccess(user);
                Navigator.pushNamed(context, '/home');
              },
            ),
        '/home': (context) {
          return FutureBuilder<User?>(
            future: mapAuthentication(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); // Return a placeholder widget while waiting
              } else if (snapshot.hasError || snapshot.data == null) {
                Future.delayed(Duration.zero, () {
                  Navigator.pushNamed(context, '/login');
                });
                return Container(); // Return a fallback widget if the user is not authenticated or is a manager
              } else {
                return DefaultPage(user: snapshot.data!);
              }
            },
          );
        },
        '/forgot-password': (context) => ResetPasswordScreen()
      },
    );
  }
}
