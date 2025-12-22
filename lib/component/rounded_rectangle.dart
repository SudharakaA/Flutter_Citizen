import 'package:flutter/material.dart';

class RoundedRectangle extends StatelessWidget {
  
  final Widget child;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color color;
  final double? width;
  final double? height;
  final String? imagePath;
  final double? imageWidth;
  final double? imageHeight;
  final VoidCallback? onTap;

  const RoundedRectangle({
    super.key,
    required this.child,
    this.borderRadius = 10.0,
    this.elevation = 4.0,
    this.padding = const EdgeInsets.all(5),
    this.margin = const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
    this.color = Colors.white,
    this.width,
    this.height,
    this.imagePath,
    this.imageWidth,
    this.imageHeight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,  
      child: Material(
        color: Colors.transparent, 
        child: Container(
          margin: margin,
          padding: padding,
          width: width ?? screenWidth * 0.4,
          height: height ?? screenHeight * 0.2,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: elevation,
                spreadRadius: 1,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imagePath != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 0), 
                  child: Image.asset(
                    imagePath!,
                    width: imageWidth ?? screenWidth * 0.26, 
                    height: imageHeight ?? screenWidth * 0.22,
                    fit: BoxFit.cover,
                  ),
                ),
              child, 
            ],
          ),
        ),
      ),
    );
  }
}
