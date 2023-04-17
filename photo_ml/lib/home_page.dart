import 'package:flutter/material.dart';
import 'package:photo_ml/feature_list_item.dart';
import 'package:photo_ml/theme/pallette.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              margin: const EdgeInsets.symmetric(
                horizontal: 29,
              ).copyWith(top: 14),
              decoration: BoxDecoration(
                  border: Border.all(color: Pallete.borderColor),
                  borderRadius:
                      BorderRadius.circular(14).copyWith(topLeft: Radius.zero)),
              child: Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 7, top: 14, bottom: 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'What can I do for you today?',
                        style: TextStyle(
                            fontFamily: 'Cera Pro',
                            color: Pallete.mainFontColor,
                            fontSize: 14),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 7, bottom: 14, top: 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Your Personal AI Assistant',
                        style: TextStyle(
                            fontFamily: 'Cera Pro',
                            color: Pallete.mainFontColor,
                            fontSize: 24),
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
// mic button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Pallete.secondAssistantCircleColor,
        child: const Icon(Icons.mic, color: Color.fromARGB(255, 255, 255, 255)),
      ),
    );
  }
}
