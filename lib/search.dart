import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'sinhala_sign_generator.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final SinhalaSignGenerator _signGenerator = SinhalaSignGenerator();
  final stt.SpeechToText _speech = stt.SpeechToText();
  
  List<String> _characterImages = [];
  int _currentIndex = 0;
  Timer? _timer;
  bool _isListening = false;
  bool _isLoadingImages = false;

  // Initialize speech recognition
  void _initializeSpeech() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {});
    } else {
      print("Speech recognition not available");
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  // Function to handle voice input
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print("Status: $status"),
        onError: (error) => print("Error: $error"),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          localeId: "si-LK", // Sinhala language code
          onResult: (result) {
            setState(() {
              _searchController.text = result.recognizedWords;
              _isListening = false;
            });
            _searchWord();
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  // Function to search and display sign language images
  void _searchWord() async {
    setState(() => _isLoadingImages = true);
    final word = _searchController.text;
    try {
      final images = await _signGenerator.fetchSignImages(word);
      setState(() {
        _characterImages = images;
        _currentIndex = 0;
        _isLoadingImages = false;
      });
      _startImageSequence();
    } catch (e) {
      print("Error fetching images: $e");
      setState(() => _isLoadingImages = false);
    }
  }

  // Start displaying images in a timed sequence
  void _startImageSequence() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (_currentIndex < _characterImages.length - 1) {
        setState(() => _currentIndex++);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 183, 77),
        title: const Text(
          'සිංහල සංඥා ශබ්දකෝෂය',
          style: TextStyle(
            fontFamily: 'Yasarath',
            fontSize: 24,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'සොයන්න',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _searchWord,
                  child: const Text('Search'),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _listen,
                ),
              ],
            ),
            const SizedBox(height: 100),
            Expanded(
              child: Center(
                child: _isLoadingImages
                    ? CircularProgressIndicator()
                    : _characterImages.isNotEmpty
                        ? Image.memory(
                            base64Decode(_characterImages[_currentIndex]),
                            width: 400,
                            height: 400,
                          )
                        : const Text(
                            'පරිච්ඡේදයක් හමු නොවීය',
                            style: TextStyle(
                              fontFamily: 'Yasarath',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
