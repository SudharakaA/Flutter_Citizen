import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomRoundedRectangle extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const CustomRoundedRectangle({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  State<CustomRoundedRectangle> createState() => _CustomRoundedRectangleState();
}

class _CustomRoundedRectangleState extends State<CustomRoundedRectangle> {
  bool _isTapped = false; 

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;  

    return GestureDetector(
      onTap: () {
        widget.onTap();
        setState(() {
          _isTapped = !_isTapped;  
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: _isTapped ? const Color(0xFF508D4E) : Colors.white, 
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        width: screenWidth * 0.9,  
        child: Transform.scale(
          scale: _isTapped ? 0.98 : 1.0,  
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.title,
                 style: GoogleFonts.inter(  
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: _isTapped ? Colors.white : Colors.black,  
                  ),
                  softWrap: true,  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
