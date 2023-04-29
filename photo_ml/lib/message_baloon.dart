import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_ml/theme/pallette.dart';

class MessageBaloon extends StatelessWidget {
  final Color backgroundColor;
  final String text;
  final String? imageUrl;
  final bool isAI;

  const MessageBaloon(
      {super.key,
      required this.backgroundColor,
      required this.text,
      required this.isAI,
      this.imageUrl});

  double getBaloonWidth() {
    if (imageUrl != null) {
      return 372;
    } else if (text.length < 29) {
      return 192;
    } else if (text.length < 92) {
      return 329;
    } else {
      return 372;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Visibility(
        child: Align(
          child: Row(children: [
            if (!isAI) const Spacer(),
            Container(
              constraints: BoxConstraints.loose(Size.infinite),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              margin: const EdgeInsets.only(bottom: 7),
              width: getBaloonWidth(),
              decoration: BoxDecoration(
                  border: Border.all(color: Pallete.borderColor),
                  color: isAI
                      ? const Color.fromARGB(255, 229, 229, 233)
                      : const Color.fromARGB(255, 0, 122, 255),
                  borderRadius: BorderRadius.circular(14).copyWith(
                      bottomLeft:
                          isAI ? Radius.zero : const Radius.circular(14),
                      bottomRight:
                          !isAI ? Radius.zero : const Radius.circular(14),
                      topRight: !isAI
                          ? const Radius.circular(29)
                          : const Radius.circular(14),
                      topLeft: isAI
                          ? const Radius.circular(29)
                          : const Radius.circular(14))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 7,
                      top: 7,
                      bottom: 0,
                    ),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        isAI ? 'AI' : 'You',
                        style: TextStyle(
                            fontFamily: 'Cera Pro',
                            color: isAI
                                ? Pallete.mainFontColor
                                : Pallete.whiteColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 7,
                      top: 7,
                      bottom: 7,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        text,
                        style: TextStyle(
                            fontFamily: 'Cera Pro',
                            color: isAI
                                ? Pallete.mainFontColor
                                : Pallete.whiteColor,
                            fontSize: 15),
                      ),
                    ),
                  ),

                  // image generated
                  if (imageUrl != null)
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(imageUrl!)),
                    ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
