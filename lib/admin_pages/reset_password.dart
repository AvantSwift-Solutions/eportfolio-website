import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:avantswift_portfolio/ui/admin_view_dialog_styles.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/reset_password_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const double largeSizedBoxHeight = 30;
  static const double smallSizedBoxHeight = 16;
  final ResetPasswordController controller = ResetPasswordController();

  ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
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
      Navigator.of(context).pop(); // Close the dialog when email is sent
    } else {
      // Email sending failed, you can show an error message
      log('Password reset email sending failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Apply the theme to the entire AlertDialog and its contents
      data: AdminViewDialogStyles.dialogThemeData,
      child: AlertDialog(
        titlePadding: AdminViewDialogStyles.titleDialogPadding,
        contentPadding: AdminViewDialogStyles.contentDialogPadding,
        actionsPadding: AdminViewDialogStyles.actionsDialogPadding,
        title: Container(
          padding: AdminViewDialogStyles.titleContPadding,
          color: AdminViewDialogStyles.bgColor,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Forgot My Password.'),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      iconSize: AdminViewDialogStyles.closeIconSize,
                      hoverColor: Colors.transparent,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: ResetPasswordScreen
                      .smallSizedBoxHeight), // Add some spacing
              const Divider(),
              const SizedBox(
                  height: ResetPasswordScreen
                      .smallSizedBoxHeight), // Add more spacing
            ],
          ),
        ),
        content: SizedBox(
            height: AdminViewDialogStyles.forgotPasswordDialogHeight,
            width: AdminViewDialogStyles.forgotPasswordDialogWidth,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Align text to the left
                    children: [
                      Flexible(
                        child: Text(
                          "Click 'Send Email' to reset password.\nInstructions will be sent via email.",
                          style: AdminViewDialogStyles.buttonTextStyle,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: ResetPasswordScreen.largeSizedBoxHeight),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end, // Align button to the right
                    children: [
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
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
