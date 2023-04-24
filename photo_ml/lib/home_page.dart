import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:photo_ml/apis/openai_service.dart';
import 'package:photo_ml/feature_list_item.dart';
import 'package:photo_ml/message_baloon.dart';
import 'package:photo_ml/theme/pallette.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'model/ai_answer_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final OpenAIAPI openAIAPI = OpenAIAPI();
  final AIAnswerModel aiAnswer = AIAnswerModel();
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = '';
  String? generatedContent;
  String? generatedImageUrl;
  String? searchText;
  int animDelay = 129;
  List<MessageBaloon> messageList = <MessageBaloon>[];
  double screenWidth = 0;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
    screenWidth = 200; //MediaQuery.of(context).size.width;
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
    final speechRes = await openAIAPI.makeAPICall(lastWords);
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

  void getAnswer(bool isFromMic) async {
    if (isFromMic) {
      if (await speechToText.hasPermission && speechToText.isNotListening) {
        await startListening();
      } else if (speechToText.isListening) {
        final speechRes = await openAIAPI.makeAPICall(lastWords);
        if (speechRes.contains('http')) {
          generatedImageUrl = speechRes;
          generatedContent = null;
          setState(() {});
        } else {
          messageList.add(MessageBaloon(
            backgroundColor: Pallete.whiteColor,
            isAI: true,
            text: speechRes,
          ));
          Future.delayed(const Duration(milliseconds: 29), () {
            messageList.add(MessageBaloon(
                backgroundColor: Pallete.whiteColor,
                text: aiAnswer.getQuickAnswer(),
                isAI: true));

            setState(() {});
          });
          generatedContent = speechRes;
          generatedImageUrl = null;
          setState(() {});
          await setSpeak(speechRes);
          messageList.add(MessageBaloon(
            backgroundColor: Pallete.whiteColor,
            isAI: true,
            text: generatedContent!,
          ));
        }
        await stopListening();
      } else {
        initSpeechToText();
      }
    } else {
      Future.delayed(const Duration(milliseconds: 792), () {
        messageList.add(MessageBaloon(
            backgroundColor: Pallete.whiteColor,
            text: aiAnswer.getQuickAnswer(),
            isAI: true));

        setState(() {});
      });

      final searchTextRes = await openAIAPI.makeAPICall(searchText!);
      if (searchTextRes.contains('http')) {
        generatedImageUrl = searchTextRes;
        generatedContent = null;
        messageList.add(MessageBaloon(
          backgroundColor: Pallete.whiteColor,
          imageUrl: generatedImageUrl,
          isAI: true,
          text: '',
        ));
        setState(() {});
      } else {
        generatedContent = searchTextRes;
        generatedImageUrl = null;
        setState(() {});
        messageList.add(MessageBaloon(
          backgroundColor: Pallete.whiteColor,
          isAI: true,
          text: generatedContent!,
        ));
        await setSpeak(searchTextRes);
      }
    }
  }

  @override
  void dispose() {
    speechToText.stop();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(child: const Text('Your AI Assistant')),
        leading: Column(
          children: [
            // header image Stack
            Stack(
              children: [
                ZoomIn(
                  child: Center(
                    child: Container(
                      height: 44,
                      width: 44,
                      margin: const EdgeInsets.only(top: 7),
                      decoration: const BoxDecoration(
                          color: Pallete.firstAssistantCircleColor,
                          shape: BoxShape.circle),
                    ),
                  ),
                ),
                ZoomIn(
                  child: Center(
                    child: Container(
                        height: 56,
                        width: 56,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/aiAssistant.png')))),
                  ),
                )
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bakcgroundSeamless.png'),
                fit: BoxFit.cover,
                opacity: 0.5)),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 129),
              child: Column(
                children: [
                  // chat buble Container
                  FadeInRight(
                    child: Visibility(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 14,
                        ).copyWith(top: 29, right: 34),
                        decoration: BoxDecoration(
                            border: Border.all(color: Pallete.borderColor),
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(14).copyWith(
                                bottomLeft: Radius.zero,
                                topLeft: const Radius.circular(29))),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 7,
                                top: 14,
                                bottom: 0,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'What can I do for you today?',
                                  style: TextStyle(
                                      fontFamily: 'Cera Pro',
                                      color: Pallete.mainFontColor,
                                      fontSize:
                                          generatedContent == null ? 14 : 12),
                                ),
                              ),
                            ),
                            if (generatedImageUrl == null)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 7, bottom: 14, top: 0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Your Personal AI Assistant',
                                    style: TextStyle(
                                        fontFamily: 'Cera Pro',
                                        color: Pallete.mainFontColor,
                                        fontSize:
                                            generatedContent == null ? 24 : 14),
                                  ),
                                ),
                              ),
                            // image generated
                            if (generatedImageUrl != null)
                              Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network(generatedImageUrl!)),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // features list
                  SlideInRight(
                    child: Visibility(
                      visible: true,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 14),
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(
                            top: 14.0, right: 58, left: 14),
                        child: const Text(
                          'Discover your possibilities with my features!',
                          style: TextStyle(
                              fontFamily: 'Cera Pro',
                              color: Pallete.mainFontColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(top: 14.0, right: 14, left: 14),
                    child: Visibility(
                      visible: true,
                      child: Column(
                        children: [
                          FadeInRight(
                            delay: Duration(milliseconds: animDelay),
                            child: const FeatureListItem(
                              backgroundColor: Pallete.firstListItemColor,
                              titleText: 'ChatGPT Text',
                              descriptionText:
                                  'Unlock your potential with ChatGPT: The smarter way to stay organized and informed.',
                            ),
                          ),
                          FadeInRight(
                            delay: Duration(milliseconds: animDelay * 2),
                            child: const FeatureListItem(
                              backgroundColor: Pallete.secondListItemColor,
                              titleText: 'Dall-E Image',
                              descriptionText:
                                  'Unleash your creativity with Dall-E\'s personal assistant: Inspire and create effortlessly.',
                            ),
                          ),
                          Column(
                            children: messageList,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Search Box
            BounceInRight(
              delay: Duration(milliseconds: animDelay * 4),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16)
                    .copyWith(bottom: 50),
                alignment: Alignment.bottomCenter,
                child: TextFormField(
                  onChanged: (text) {
                    setState(() {
                      searchText = text;
                    });
                  },
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                    filled: true,
                    labelText: "Chat with me",
                    labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Cera Pro',
                        color: Pallete.secondAssistantCircleColor),
                    fillColor: Pallete.whiteColor,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide(
                            color: Pallete.secondAssistantCircleColor)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide(
                            color: Pallete.secondAssistantCircleColor)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
// mic button
      floatingActionButton: BounceInRight(
        delay: Duration(milliseconds: animDelay * 4),
        child: FloatingActionButton(
          onPressed: () async {
            if (searchText.toString().isNotEmpty && searchText != null) {
              messageList.add(MessageBaloon(
                  backgroundColor: Pallete.whiteColor,
                  text: searchText.toString(),
                  isAI: false));
              getAnswer(false);
            } else {
              if (await speechToText.hasPermission == false) {
                initSpeechToText();
              } else {
                getAnswer(true);
              }
            }
          },
          backgroundColor: Pallete.secondAssistantCircleColor,
          child: Icon(
              (searchText.toString().isNotEmpty && searchText != null)
                  ? Icons.send
                  : speechToText.isListening
                      ? Icons.stop_circle_rounded
                      : Icons.mic,
              color: const Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
    );
  }
}
