import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KPICard extends StatelessWidget {
  final String title;
  final int value;
  final Color color;
  final IconData icon;

  const KPICard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Icon(
            icon,
            size: screenWidth * 0.06,
            color: color.withOpacity(0.8),
          ),
          
          SizedBox(height: screenWidth * 0.015),

          // Title
          Flexible(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: screenWidth * 0.032,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          SizedBox(height: screenWidth * 0.01),

          // Value
          Text(
            value.toString(),
            style: GoogleFonts.inter(
              fontSize: screenWidth * 0.08,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
