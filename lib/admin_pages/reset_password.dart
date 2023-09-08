import 'package:avantswift_portfolio/controllers/admin_controllers/reset_password_controller.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  final ResetPasswordController controller = ResetPasswordController();

  ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _isSending = false;

  Future<void> _sendEmail() async {
    setState(() {
      _isSending = true;
    });

    bool emailSent =
        await widget.controller.sendPasswordResetToMostRecentEmail();

    setState(() {
      _isSending = false;
    });

    if (emailSent) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/login');
      // Email sent successfully, you can show a success message or navigate to another screen
      print("Password reset email sent successfully");
    } else {
      // Email sending failed, you can show an error message
      print("Password reset email sending failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Click the button to send a password reset email to the most recent user.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSending ? null : _sendEmail,
              child:
                  _isSending ? CircularProgressIndicator() : Text('Send Email'),
            ),
          ],
        ),
      ),
    );
  }
}
