import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyOtpPage extends StatefulWidget {
  final String email;
  const VerifyOtpPage({required this.email, super.key});

  @override
  VerifyOtpPageState createState() => VerifyOtpPageState();
}

class VerifyOtpPageState extends State<VerifyOtpPage> {
  TextEditingController otpController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  String message = '';

  Future<void> verifyOtpAndResetPassword() async {
  String url = 'http://192.168.42.58:3000/verify-otp';
  var response = await http.post(
    Uri.parse(url),
    body: jsonEncode({
      'email': widget.email,
      'otp': otpController.text,
      'newPassword': newPasswordController.text,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (!mounted) return; // Check if the widget is still mounted

  if (response.statusCode == 200) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('සාර්ථකයි'),
        content: const Text('මුරපදය යළි පිහිටුවීම සාර්ථකයි'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pop(context); // Go back to the previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('අසාර්ථකයි'),
        content:
            const Text('මුරපදය යළි පිහිටුවීම අසාර්ථක විය. කරුණාකර නැවත උත්සාහ කරන්න.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('හරි'),
          ),
        ],
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 255, 183, 77), // Light Orange
        title: const Text(
          'මුරපදය නැවත සකසන්න',
          style: TextStyle(
            fontFamily: 'Yasarath',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 248, 246, 246),
            shadows: [
              Shadow(
                offset: Offset(2.0, 1.0),
                blurRadius: 10.0,
                color: Color.fromARGB(255, 5, 5, 5),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: otpController,
                decoration: const InputDecoration(
                  labelText: 'OTP',
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'නව මුරපදය',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: verifyOtpAndResetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 255, 166, 94), // Blue color for the button
                ),
                child: const Text('OTP තහවුරු කර මුරපදය යළි පිහිටුවන්න'),
              ),
              const SizedBox(height: 20.0),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}
