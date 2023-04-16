import 'package:flutter/material.dart';
import 'package:photo_ml/theme/pallette.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PhotoAI'),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: Column(
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
                      color: Pallete.assistantCircleColor,
                      shape: BoxShape.circle),
                ),
              ),
              Center(
                child: Container(
                    height: 132,
                    width: 132,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/virtualAssistant.png')))),
              )
            ],
          ),
// chat buble Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            margin: const EdgeInsets.symmetric(
              horizontal: 29,
            ).copyWith(top: 14),
            decoration:
                BoxDecoration(border: Border.all(color: Pallete.borderColor)),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 9.0),
              child: Text(
                'Your Personal Assistant - What Can I Do for You Today?',
                style: TextStyle(
                    fontFamily: 'Cera Pro',
                    color: Pallete.mainFontColor,
                    fontSize: 24),
              ),
            ),
          )
        ],
      ),
    );
  }
}
