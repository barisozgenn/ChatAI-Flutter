import 'package:animate_do/animate_do.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
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
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  margin: EdgeInsets.only(left: 14),
                  width: 372,
                  color: Color.fromARGB(255, 229, 229, 233),
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(imageUrl!)),
                  ),
                ),
              ),
            if (imageUrl == null)
              Container(
                margin: EdgeInsets.only(bottom: 7),
                child: BubbleSpecialThree(
                  text: text,
                  color: isAI
                      ? Color.fromARGB(255, 229, 229, 233)
                      : Color.fromARGB(255, 0, 122, 255),
                  tail: true,
                  isSender: isAI ? false : true,
                  textStyle: TextStyle(
                    color: isAI ? Pallete.blackColor : Pallete.whiteColor,
                    fontSize: 16,
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
/**image generated
                  if (imageUrl != null)
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(imageUrl!)),
                    ), */