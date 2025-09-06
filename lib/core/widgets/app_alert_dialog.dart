import 'package:flutter/material.dart';

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final String buttonText;

  const AppAlertDialog(
      {super.key,
      required this.title,
      required this.message,
      required this.icon,
      required this.iconColor,
      this.buttonText = 'OK'});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(color: iconColor),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(color: Colors.black, fontSize: 13),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            buttonText,
            style: const TextStyle(color: Colors.blue),
          ),
        ),
      ],
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

/// Generic alert dialog
Future<void> showAppAlert(
  BuildContext context, {
  required String title,
  required String message,
  required IconData icon,
  required Color iconColor,
  String buttonText = 'OK',
}) {
  return showDialog(
      context: context,
      builder: (_) => AppAlertDialog(
            title: title,
            message: message,
            icon: icon,
            iconColor: iconColor,
            buttonText: buttonText,
          ));
}

/// Optional alert dialogs
Future<void> showSuccess(BuildContext context, String message,
    {String title = 'Success'}) {
  return showAppAlert(context,
      title: title,
      message: message,
      icon: Icons.check_circle,
      iconColor: Colors.green);
}

Future<void> showError(BuildContext context, String message,
    {String title = 'Error'}) {
  return showAppAlert(context,
      title: title, message: message, icon: Icons.error, iconColor: Colors.red);
}
