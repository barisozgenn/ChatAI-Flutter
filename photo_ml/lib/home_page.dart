import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:photo_ml/apis/openai_service.dart';
import 'package:photo_ml/feature_list_item.dart';
import 'package:photo_ml/theme/pallette.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final OpenAIAPI openAIAPI = OpenAIAPI();
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = '';
  String? generatedContent;
  String? generatedImageUrl;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

// Each time to start a speech recognition session
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    final speechRes = await openAIAPI.isImagePromptAPI(lastWords);
    print(speechRes);
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> setSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PhotoAI'),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bakcgroundSeamless.png'),
                fit: BoxFit.cover,
                opacity: 0.5)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // header image Stack
              Stack(
                children: [
                  Center(
                    child: Container(
                      height: 129,
                      width: 129,
                      margin: const EdgeInsets.only(top: 7),
                      decoration: const BoxDecoration(
                          color: Pallete.firstAssistantCircleColor,
                          shape: BoxShape.circle),
                    ),
                  ),
                  Center(
                    child: Container(
                        height: 158,
                        width: 158,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/aiAssistant.png')))),
                  )
                ],
              ),
              // chat buble Container
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                margin: const EdgeInsets.symmetric(
                  horizontal: 29,
                ).copyWith(top: 14),
                decoration: BoxDecoration(
                    border: Border.all(color: Pallete.borderColor),
                    borderRadius: BorderRadius.circular(14)
                        .copyWith(topLeft: Radius.zero)),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 7, top: 14, bottom: 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          generatedContent == null
                              ? 'What can I do for you today?'
                              : 'Your Personal AI Assistant',
                          style: const TextStyle(
                              fontFamily: 'Cera Pro',
                              color: Pallete.mainFontColor,
                              fontSize: 14),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 7, bottom: 14, top: 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          generatedContent == null
                              ? 'Your Personal AI Assistant'
                              : generatedContent!,
                          style: TextStyle(
                              fontFamily: 'Cera Pro',
                              color: Pallete.mainFontColor,
                              fontSize: generatedContent == null ? 24 : 17),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // features list
              Container(
                padding: const EdgeInsets.all(14),
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 14.0, left: 14, right: 14),
                child: const Text(
                  'Discover Your Possibilities with Our Features!',
                  style: TextStyle(
                      fontFamily: 'Cera Pro',
                      color: Pallete.mainFontColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: const [
                  FeatureListItem(
                    backgroundColor: Pallete.firstListItemColor,
                    titleText: 'ChatGPT Text',
                    descriptionText:
                        'Unlock your potential with ChatGPT: The smarter way to stay organized and informed.',
                  ),
                  FeatureListItem(
                    backgroundColor: Pallete.secondListItemColor,
                    titleText: 'Dall-E Image',
                    descriptionText:
                        'Unleash your creativity with Dall-E\'s personal assistant: Inspire and create effortlessly.',
                  ),
                  FeatureListItem(
                    backgroundColor: Pallete.thirdListItemColor,
                    titleText: 'Future of Voice Assistance',
                    descriptionText:
                        'Experience the perfect blend of intelligence and imagination with Dall-E and ChatGPT.',
                  )
                ],
              )
            ],
          ),
        ),
      ),
// mic button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (kDebugMode) {
            print('status:${speechToText.isListening.toString()}');
          }
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
            final speechRes = await openAIAPI.isImagePromptAPI(lastWords);
            if (speechRes.contains('http')) {
              generatedImageUrl = speechRes;
              generatedContent = null;
              setState(() {});
            } else {
              generatedContent = speechRes;
              generatedImageUrl = null;
              setState(() {});
              await setSpeak(speechRes);
            }
            await stopListening();
          } else {
            initSpeechToText();
          }
        },
        backgroundColor: Pallete.secondAssistantCircleColor,
        child: const Icon(Icons.mic, color: Color.fromARGB(255, 255, 255, 255)),
      ),
    );
  }
}
