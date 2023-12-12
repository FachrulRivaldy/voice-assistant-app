import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:victoria/feature_box.dart';
import 'package:victoria/openai_service.dart';
import 'package:victoria/pallete.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();

  @override
  void initState() {
    initSpeechToText();
    super.initState();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Victoria'),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          //Virtual Assistant Picture
          Stack(
            children: [
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: const BoxDecoration(
                      color: Pallete.assistantCircleColor,
                      shape: BoxShape.circle),
                ),
              ),
              Container(
                height: 125,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('assets/images/virtualAssistant.png')),
                ),
              )
            ],
          ),

          // Chat Bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin:
                const EdgeInsets.symmetric(horizontal: 40).copyWith(top: 30),
            decoration: BoxDecoration(
                border: Border.all(color: Pallete.borderColor),
                borderRadius:
                    BorderRadius.circular(20).copyWith(topLeft: Radius.zero)),
            child: const Text(
              "Good Morning, what task can I do for you?",
              style: TextStyle(
                  color: Pallete.mainFontColor,
                  fontSize: 25,
                  fontFamily: 'Cera Pro'),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 10, left: 20),
            child: const Text(
              "Here are few features:",
              style: TextStyle(
                  fontFamily: 'Cera Pro',
                  fontSize: 20,
                  color: Pallete.mainFontColor,
                  fontWeight: FontWeight.bold),
            ),
          ),

          //Features List
          const Column(
            children: [
              FeatureBox(
                color: Pallete.firstSuggestionBoxColor,
                headerText: "ChatGPT",
                descriptionText:
                    "A smarter way to stay organized and informed with ChatGPT.",
              ),
              FeatureBox(
                color: Pallete.secondSuggestionBoxColor,
                headerText: "Dall-E",
                descriptionText:
                    "Get inspired and stay creative with your personal assistant powered by Dall-E.",
              ),
              FeatureBox(
                color: Pallete.thirdSuggestionBoxColor,
                headerText: "Smart Voice Assistant",
                descriptionText:
                    "Get the best of both worlds with a voice assistant powered by ChatGPT and Dall-E.",
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
            openAIService.isArtPromptAPI(lastWords);
            await stopListening();
          } else {
            initSpeechToText();
          }
        },
        backgroundColor: Pallete.firstSuggestionBoxColor,
        child: Icon(speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
