import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:avantswift_portfolio/ui/admin_view_dialog_styles.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/reset_password_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const double largeSizedBoxHeight = 30;
  static const double smallSizedBoxHeight = 16;
  static const double formTextHorizontalPadding = 10.0;
  final ResetPasswordController controller = ResetPasswordController();

  ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _isSending = false;
  final _emailController = TextEditingController();

  Future<void> _sendEmail() async {
    setState(() {
      _isSending = true;
    });

    bool emailSent = await widget.controller
        .sendPasswordResetToMostRecentEmail(_emailController.text.trim());

    setState(() {
      _isSending = false;
    });

    if (emailSent) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(); // Close the dialog when email is sent
    } else {
      // Email sending failed, you can show an error message
      log('Password reset email sending failed');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Apply the theme to the entire AlertDialog and its contents
      data: AdminViewDialogStyles.dialogThemeData,
      child: AlertDialog(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [FittedBox(child: Text('Forgot my password')), Divider()],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding:
                  EdgeInsets.only(bottom: 10.0), // Add padding to the bottom
              child: Text(
                'Enter your email and click \'Send Email\' to reset password.\nIf the provdied email is valid, instructions will be sent to your inbox.',
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEDECEC), // Set the background color here
                borderRadius: BorderRadius.circular(
                    8), // Optionally, you can add rounded corners
              ),
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Enter your email here',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: ResetPasswordScreen
                          .formTextHorizontalPadding), // Remove the default border
                ),
                cursorColor: Colors.black,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'No email was entered';
                  }
                  return null;
                },
              ),
            )
          ],
        ),
        actions: <Widget>[
          if (MediaQuery.of(context).size.width >=
              AdminViewDialogStyles.stackOptionsThreshold)
            Padding(
              padding: AdminViewDialogStyles.deleteActionsDialogPadding,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                  onPressed: _isSending ? null : _sendEmail,
                  style: AdminViewDialogStyles.elevatedButtonStyle,
                  child: _isSending
                      ? const CircularProgressIndicator()
                      : Text(
                          'Send Email',
                          style: AdminViewDialogStyles.buttonTextStyle,
                        ),
                ),
                TextButton(
                  style: AdminViewDialogStyles.textButtonStyle,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel',
                      style: AdminViewDialogStyles.buttonTextStyle),
                ),
              ]),
            ),
          if (MediaQuery.of(context).size.width <
              AdminViewDialogStyles.stackOptionsThreshold)
            Padding(
              padding: AdminViewDialogStyles.deleteActionsDialogPadding,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                  onPressed: _isSending ? null : _sendEmail,
                  style: AdminViewDialogStyles.elevatedButtonStyle,
                  child: _isSending
                      ? const CircularProgressIndicator()
                      : Text(
                          'Send Email',
                          style: AdminViewDialogStyles.buttonTextStyle,
                        ),
                ),
                TextButton(
                  style: AdminViewDialogStyles.textButtonStyle,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel',
                      style: AdminViewDialogStyles.buttonTextStyle),
                ),
              ]),
            )
        ],
      ),
    );
  }
}
