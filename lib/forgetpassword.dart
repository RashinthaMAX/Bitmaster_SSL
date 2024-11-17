import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'verify_otp_page.dart'; // Import VerifyOtpPage

class SendOtpPage extends StatefulWidget {
  const SendOtpPage({super.key});

  @override
  SendOtpPageState createState() => SendOtpPageState();
}

class SendOtpPageState extends State<SendOtpPage> {
  TextEditingController emailController = TextEditingController();

  Future<void> sendOtp() async {
    String url = 'http://192.168.42.58:3000/send-otp';
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode({'email': emailController.text}),
      headers: {'Content-Type': 'application/json'},
    );

    if (!mounted) return; // Check if the widget is still mounted

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('සාර්ථකයි'),
            content: Text('OTP යවන ලදී ${emailController.text}'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerifyOtpPage(email: emailController.text),
                    ),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (response.statusCode == 404) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('ඇතුල් කළ විද්‍යුත් තැපෑල හමු නොවීය'),
            content: const Text('ඔබ ආදාන ඊමේල් ලිපිනයට පරිශීලක ගිණුමක් නොමැත'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('හරි'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('දෝෂයකි'),
            content: const Text('OTP යැවීමට අසමත් විය. කරුණාකර නැවත උත්සාහ කරන්න.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 183, 77), // Light Orange
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
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'ඔබගේ විද්‍යුත් තැපෑල ඇතුලත් කරන්න',
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 252, 164, 106), // Blue color for the button
                ),
                child: const Text('OTP යවන්න'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
