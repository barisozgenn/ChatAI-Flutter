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

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Visibility(
        child: Container(
          constraints: const BoxConstraints(minWidth: 129, maxWidth: 129),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          margin: const EdgeInsets.only(bottom: 7),
          alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
          decoration: BoxDecoration(
              border: Border.all(color: Pallete.borderColor),
              color: isAI
                  ? const Color.fromARGB(255, 255, 255, 255)
                  : const Color.fromARGB(255, 233, 233, 233),
              borderRadius: BorderRadius.circular(14).copyWith(
                  bottomLeft: isAI ? Radius.zero : const Radius.circular(14),
                  bottomRight: !isAI ? Radius.zero : const Radius.circular(14),
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
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    isAI ? 'AI' : 'You',
                    style: const TextStyle(
                        fontFamily: 'Cera Pro',
                        color: Pallete.mainFontColor,
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
                    style: const TextStyle(
                        fontFamily: 'Cera Pro',
                        color: Pallete.mainFontColor,
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
      ),
    );
  }
}
