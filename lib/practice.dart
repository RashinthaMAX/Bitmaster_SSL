import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  PracticePageState createState() => PracticePageState();
}

class PracticePageState extends State<PracticePage> {
  CameraController? _controller;
  String predictionResult = "ඔබ හස්ත සංඥාවක් මෙතෙක් දක්වා නොමැත"; // No prediction yet in Sinhala
  bool _isPredicting = false;
  String targetCharacter = '';
  bool isCorrect = false;

  // Sinhala character list
  final List<String> sinhalaCharacters = [
    "අ", "ආ", "බ්", "ච්", "ඩ්", "ද්", "එ", "ග්", "හ්", "ඉ", "ක්", "ල්", "ම්", "න්", "ප්", "ර්", "ස්", "ට්", "ත්", "උ", "ව්", "ය්"
  ];
  
  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _generateNewTargetCharacter();
  }

  // Function to generate a new target character randomly
  void _generateNewTargetCharacter() {
    final random = Random();
    setState(() {
      targetCharacter = sinhalaCharacters[random.nextInt(sinhalaCharacters.length)];
      isCorrect = false;
    });
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front);

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller?.initialize();
    setState(() {});

    _startRealTimePrediction();
  }

  void _startRealTimePrediction() {
    Timer.periodic(Duration(milliseconds: 500), (timer) async {
      if (_controller != null && !_isPredicting && !isCorrect) {
        _isPredicting = true;
        await captureAndPredict();
        _isPredicting = false;
      }
    });
  }

  Future<void> captureAndPredict() async {
    try {
      final XFile picture = await _controller!.takePicture();
      final imagePath = picture.path;

      final url = Uri.parse('http://192.168.42.58:5000/predict');
      final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('file', imagePath));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final result = json.decode(responseBody);
        
        setState(() {
          predictionResult = "ඔබ නිරුපණය කරන්නේ ${result['predicted_class']}, නිරවද්‍යතාවය: ${result['confidence_score']}"; // Prediction and confidence in Sinhala
        });
        
        // Check if prediction matches target
        if (result['predicted_class'] == targetCharacter) {
          setState(() {
            isCorrect = true;
            predictionResult = "නිවැරදියි! $targetCharacter සමඟ හස්ත සංඥාව සමානයි"; // Correct! You matched in Sinhala
          });
          // Wait and then show a new target
          Future.delayed(Duration(seconds: 2), () {
            _generateNewTargetCharacter();
          });
        }
      } else {
        setState(() {
          predictionResult = "ඔබ හස්ත සංඥාවක් මෙතෙක් දක්වා නොමැත"; // Error: Could not get prediction in Sinhala
        });
      }
    } catch (e) {
      setState(() {
        predictionResult = "දෝෂය: $e"; // Error message in Sinhala
        showErrorDialog("දෝෂය: $e");
      });
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("දෝෂයක් ඇත"), // Error title in Sinhala
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("සහතික කිරීම"), // OK in Sinhala
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 183, 77), // Light Orange
        title: const Text(
          'සංඥා භාෂා පුහුණුව',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Stack(
            children: [
              // Outline text for character
              Text(
                " $targetCharacter  ",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4
                    ..color = Colors.black,
                ),
              ),
              // Main fill color for character
              Text(
                " $targetCharacter  ",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          Text(
            "ට අදාල හස්ත සංඥාව පෙන්නුම් කරන්න ",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          if (_controller != null && _controller!.value.isInitialized)
            Container(
              width: 300,
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CameraPreview(_controller!),
              ),
            ),
          SizedBox(height: 20),
          Text(
            predictionResult,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
