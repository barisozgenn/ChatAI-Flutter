import 'package:flutter/material.dart';
import 'package:photo_ml/theme/pallette.dart';

class FeatureListItem extends StatelessWidget {
  final Color backgroundColor;
  final String titleText;
  final String descriptionText;
  const FeatureListItem(
      {super.key,
      required this.backgroundColor,
      required this.titleText,
      required this.descriptionText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 29.0, vertical: 7),
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14).copyWith(top: 14),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                titleText,
                style: const TextStyle(
                    fontFamily: 'Cera Pro',
                    color: Pallete.blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          Padding(
            padding: const EdgeInsets.all(14.0).copyWith(top: 0),
            child: Text(descriptionText,
                style: const TextStyle(
                    fontFamily: 'Cera Pro',
                    color: Pallete.blackColor,
                    fontWeight: FontWeight.w500)),
          )
        ],
      ),
    );
  }
}
