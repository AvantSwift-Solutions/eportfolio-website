import 'package:flutter/material.dart';
import 'dart:math';

class TSkillsImage extends StatefulWidget {
  final Image centerImage; // Image in the center
  final List<Image> allSurroundingImages; // All surrounding images
  final double padding;

  const TSkillsImage({
    Key? key,
    required this.centerImage,
    required this.allSurroundingImages,
    this.padding = 10.0,
  }) : super(key: key);

  @override
  _TSkillsImageState createState() => _TSkillsImageState();
}

class _TSkillsImageState extends State<TSkillsImage> {
  final int imagesPerPage = 8;
  int currentPage = 0;

  List<Image> get currentPageImages {
    final startIndex = currentPage * imagesPerPage;
    final endIndex = (startIndex + imagesPerPage)
        .clamp(0, widget.allSurroundingImages.length);
    return widget.allSurroundingImages.sublist(startIndex, endIndex);
  }

  void nextPage() {
    setState(() {
      currentPage++;
    });
  }

  void previousPage() {
    setState(() {
      currentPage--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double imageSize = MediaQuery.of(context).size.width * 0.06;
    final double centerImageSize = MediaQuery.of(context).size.width * 0.1;

    // Calculate the angle between each surrounding image
    final double angleBetweenImages = 2 * pi / currentPageImages.length;

    // Calculate the radius of the container to hold the surrounding circles
    final double containerRadius =
        (centerImageSize / 2 + imageSize / 2 + widget.padding);

    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            width: containerRadius * 2,
            height: containerRadius * 2,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                // Surrounding Images
                for (var i = 0; i < currentPageImages.length; i++)
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
                        padding: EdgeInsets.all(widget.padding),
                        child: ClipOval(
                          child: currentPageImages[i],
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
                    padding: EdgeInsets.only(
                        top: widget.padding,
                        left: widget.padding,
                        right: widget.padding),
                    child: ClipOval(
                      child: widget.centerImage,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
