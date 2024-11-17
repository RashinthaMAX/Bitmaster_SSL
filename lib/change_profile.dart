import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ssl_project/signin.dart';

class ChangeProfilePage extends StatefulWidget {
  final int userId;

  const ChangeProfilePage({super.key, required this.userId});

  @override
  _ChangeProfilePageState createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.put(
        Uri.parse('http://192.168.42.58:3000/update-profile'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': widget.userId,
          'username': _usernameController.text,
          'email': _emailController.text,
          'currentPassword': _currentPasswordController.text,
          'newPassword': _newPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ගිණුම සාර්ථකව යාවත්කාලීන කරන ලදී')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SigninPage()),
        );
      } else {
        _showErrorDialog("ගිණුම යාවත්කාලීන කිරීමට අසමත් විය", response.body);
      }
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('සහතික කරන්න'), // OK in Sinhala
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 183, 77),
        title: const Text(
          'ගිණුම වෙනස් කරන්න',
          style: TextStyle(
            fontFamily: 'Yasarath',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 248, 246, 246),
            shadows: [
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 3.0,
                color: Color.fromARGB(96, 0, 0, 0),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'නව පරිශීලක නාමය'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'කරුණාකර ඔබගේ නව පරිශීලක නාමය ඇතුලත් කරන්න';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'නව විද්යුත් තැපෑල'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'කරුණාකර ඔබගේ නව විද්‍යුත් තැපෑල ඇතුලත් කරන්න';
                      }
                      if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
                        return 'කරුණාකර වලංගු විද්‍යුත් තැපෑලක් ඇතුළු කරන්න';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _currentPasswordController,
                    decoration: const InputDecoration(labelText: 'වත්මන් මුර පදය'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'කරුණාකර ඔබගේ වත්මන් මුරපදය ඇතුලත් කරන්න';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _newPasswordController,
                    decoration: const InputDecoration(labelText: 'නව මුරපදය'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'කරුණාකර ඔබගේ නව මුරපදය ඇතුලත් කරන්න';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text('ගිණුම යාවත්කාලීන කරන්න'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
