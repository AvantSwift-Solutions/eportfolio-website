import 'package:avantswift_portfolio/models/User.dart';
import 'package:avantswift_portfolio/services/auth_state.dart';
import 'package:avantswift_portfolio/admin_pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';

class MockAuthState extends Mock implements AuthState {}

void main() {
  group('LoginPage', () {
    late AuthState authState;
    late User user;
    late Function(User) onLoginSuccess;

    setUp(() {
      authState = MockAuthState();
      user = User(
        name: 'testUser',
        uid: '123',
        email: 'test@example.com',
        creationTimestamp: Timestamp.fromDate(DateTime.now()),
      );
      onLoginSuccess = (User user) {};
    });

    testWidgets('Renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(
            onLoginSuccess: onLoginSuccess,
            authState: authState,
          ),
        ),
      );

      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Forgot your password?'), findsOneWidget);
    });

    // testWidgets('Validates email and password', (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: LoginPage(
    //         onLoginSuccess: onLoginSuccess,
    //         authState: authState,
    //       ),
    //     ),
    //   );

    //   // Tap the login button without entering any text
    //   await tester.tap(find.text('Login'));
    //   await tester.pump();

    //   // Verify that the form validation errors are displayed
    //   expect(find.text('Please enter an email'), findsOneWidget);
    //   expect(find.text('Please enter a password'), findsOneWidget);
    // });

    // testWidgets('Logs in with valid email and password',
    //     (WidgetTester tester) async {
    //   // Mock the sign in with email and password method
    //   when(authState.signInWithEmailAndPassword('test', 'test'))
    //       .thenAnswer((_) => Future.value(null));

    //   // Mock the user document snapshot
    //   final userDocument = {
    //     'name': user.name,
    //     'uid': user.uid,
    //     'email': user.email,
    //     'creationTimestamp': user.creationTimestamp
    //   };
    //   // when(authState.firestore)
    //   //     .thenAnswer((_) => MockFirestoreInstance());
    //   // when(authState.firestore.collection('User').doc(user.uid))
    //   //     .thenAnswer((_) => MockDocumentSnapshot(userDocument));

    //   // Mock the onLoginSuccess callback
    //   onLoginSuccess = (User user) {
    //     expect(user.name, equals('testUser'));
    //     expect(user.uid, equals('123'));
    //     expect(user.email, equals('test@example.com'));
    //     expect(user.creationTimestamp, Timestamp.fromDate(DateTime.now()));
    //   };

    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: LoginPage(
    //         onLoginSuccess: onLoginSuccess,
    //         authState: authState,
    //       ),
    //     ),
    //   );

    //   // Enter valid email and password
    //   await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    //   await tester.enterText(find.byType(TextFormField).last, 'password');

    //   // Tap the login button
    //   await tester.tap(find.text('Login'));
    //   await tester.pumpAndSettle();

    //   // Verify that the onLoginSuccess callback was called
    //   verify(onLoginSuccess(user)).called(1);
    // });

    // testWidgets('Shows error dialog when login fails',
    //     (WidgetTester tester) async {
    //   // Mock the sign in with email and password method to throw an error
    //   when(authState.signInWithEmailAndPassword('test', 'test'))
    //       .thenThrow('Login Error');

    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: LoginPage(
    //         onLoginSuccess: onLoginSuccess,
    //         authState: authState,
    //       ),
    //     ),
    //   );

    //   // Enter valid email and password
    //   await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    //   await tester.enterText(find.byType(TextFormField).last, 'password');

    //   // Tap the login button
    //   await tester.tap(find.text('Login'));
    //   await tester.pumpAndSettle();

    //   // Verify that the error dialog is displayed
    //   expect(find.text('Login Error'), findsOneWidget);
    //   expect(find.text('Failed to log in. Please try again.'), findsOneWidget);
    //   expect(find.text('OK'), findsOneWidget);
    // });
  });
}

class MockFirestoreInstance extends Mock implements FirebaseFirestore {}

// ignore: subtype_of_sealed_class
class MockDocumentSnapshot extends Mock implements DocumentSnapshot {

  final Map<String, dynamic> _data;

  MockDocumentSnapshot(this._data);

  @override
  dynamic operator [](Object? key) => _data[key];

  Map<String, dynamic> get mockData => _data;
  
}
