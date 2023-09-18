import 'package:flutter/material.dart';
import 'dart:math';

class TSkillsImage extends StatelessWidget {
  final Image centerImage; // Image in the center
  final List<Image> surroundingImages; // A set of at most 8 images surrounding
  final double padding;

  const TSkillsImage({
    Key? key,
    required this.centerImage,
    required this.surroundingImages,
    this.padding = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double imageSize = MediaQuery.of(context).size.width * 0.1;
    final double centerImageSize = MediaQuery.of(context).size.width * 0.2;
    final numImages = surroundingImages.length;

    // Calculate the angle between each surrounding image
    final double angleBetweenImages = 2 * pi / numImages;

    // Calculate the radius of the container to hold the surrounding circles
    final double containerRadius =
        (centerImageSize / 2 + imageSize / 2 + padding);

    return Center(
      child: SizedBox(
        width: containerRadius * 2,
        height: containerRadius * 2,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            // Surrounding Images
            for (var i = 0; i < numImages; i++)
              Positioned(
                top: containerRadius +
                    containerRadius * cos(angleBetweenImages * i) -
                    imageSize / 2,
                left: containerRadius +
                    containerRadius * sin(angleBetweenImages * i) -
                    imageSize / 2,
                child: Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 2.0, // Border width
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: ClipOval(
                      child: surroundingImages[i],
                    ),
                  ),
                ),
              ),
            // Center Image
            Container(
              width: centerImageSize,
              height: centerImageSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black, // Border color
                  width: 2.0, // Border width
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: ClipOval(
                  child: centerImage,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
