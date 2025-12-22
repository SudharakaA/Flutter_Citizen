import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailRectangleWithNumber extends StatefulWidget {
  final String text;
  final int number;
  final double? fontSize;

  const DetailRectangleWithNumber({
    super.key,
    required this.text,
    required this.number,
    this.fontSize,
  });

  @override
  State<DetailRectangleWithNumber> createState() => _DetailRectangleWithNumberState();
}

class _DetailRectangleWithNumberState extends State<DetailRectangleWithNumber> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final containerWidth = screenWidth * 0.9;
    final circleDiameter = screenWidth * 0.08;
    final padding = screenWidth * 0.025;
    final spacing = screenWidth * 0.03;

    final defaultFontSize = screenWidth * 0.04;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isTapped = !_isTapped;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          vertical: padding,
          horizontal: padding,
        ),
        margin: EdgeInsets.symmetric(vertical: padding / 1.5),
        width: containerWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.025),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: screenWidth * 0.02,
              spreadRadius: screenWidth * 0.005,
              offset: Offset(0, screenHeight * 0.002),
            ),
          ],
        ),
        child: Transform.scale(
          scale: _isTapped ? 0.98 : 1.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: circleDiameter,
                height: circleDiameter,
                decoration: const BoxDecoration(
                  color:  Color(0xFF508D4E),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.number.toString(),
                  style: GoogleFonts.inter(
                    fontSize: widget.fontSize ?? defaultFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Text(
                  widget.text,  
                  style: GoogleFonts.inter(
                    fontSize: widget.fontSize ?? defaultFontSize,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
