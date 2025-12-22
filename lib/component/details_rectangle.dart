import 'package:flutter/material.dart';

class DetailRectangle extends StatefulWidget {
  final Widget child;

  const DetailRectangle({
    super.key,
    required this.child,
  });

  @override
  State<DetailRectangle> createState() => _DetailRectangleState();
}

class _DetailRectangleState extends State<DetailRectangle> {
  bool _isTapped = false; 

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;  

    return GestureDetector(
      onTap: () {
        setState(() {
          _isTapped = !_isTapped;  
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),  
        margin: const EdgeInsets.symmetric(vertical: 4), 
        decoration: BoxDecoration(
          color: Colors.white,  
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
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
            mainAxisAlignment: MainAxisAlignment.start,  
            children: [
              Expanded(
                child: widget.child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
