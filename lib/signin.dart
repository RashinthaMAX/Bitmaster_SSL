import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ssl_project/forgetpassword.dart';
import 'dart:convert';
import 'lesson.dart'; // Import the LessonPage

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key});

  @override
  SigninPageState createState() => SigninPageState();
}

class SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    try {
      var response = await http.post(
        Uri.parse('http://192.168.42.58:3000/signin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        int userId = responseBody['userId'] ?? -1;

        if (userId != -1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(userId: userId)),
          );
        } else {
          _showErrorDialog('සේවාදායකයෙන් වලංගු නොවන ප්‍රතිචාරයක්');
        }
      } else {
        _showErrorDialog('පුරනය වීම අසාර්ථක විය: ${response.body}');
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog('දෝෂයක් ඇතිවිය: $e');
    }
  }
}

void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('දෝෂයකි'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(249, 221, 164, 1),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/interfacepng.png',
                  height: 250,
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField('පරිශීලක නම', _usernameController),
                      const SizedBox(height: 20),
                      _buildPasswordField('මුරපදය', _passwordController),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text('ඇතුලත්'),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SendOtpPage()),
                          );
                        },
                        child: const Text('මුරපදය අමතකද?'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[300],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'මෙම ක්ෂේත්‍රය හිස්ව නොහැක';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField(
      String labelText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[300],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'මෙම ක්ෂේත්‍රය හිස් විය නොහැක';
            }
            return null;
          },
        ),
      ],
    );
  }
}
