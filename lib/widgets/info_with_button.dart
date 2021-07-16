import 'package:flutter/material.dart';
import 'package:superheroes/widgets/action_button.dart';

class InfoWithButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final String assetImage;
  final double imageHeight;
  final double imageWidth;
  final double imageTopPadding;

  const InfoWithButton(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.buttonText,
      required this.assetImage,
      required this.imageHeight,
      required this.imageWidth,
      required this.imageTopPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
                width: 108,
                height: 108,
                decoration: BoxDecoration(
                    color: const Color(0xFF00BCD4), shape: BoxShape.circle)),
            Padding(
              padding: EdgeInsets.only(top: imageTopPadding),
              child: Image(
                width: imageWidth,
                height: imageHeight,
                image: AssetImage(assetImage),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: Text(
            title,
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: Text(
            subtitle.toUpperCase(),
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        ActionButton(text: buttonText.toUpperCase(), onTap: () {})
      ],
    );
  }
}
