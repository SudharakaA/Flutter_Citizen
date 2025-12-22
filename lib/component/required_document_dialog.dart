import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RequiredDocumentsDialog extends StatelessWidget {
  final List<String> documents;

  const RequiredDocumentsDialog({super.key, required this.documents});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return AlertDialog(
      title: Center(
        child: Text(
          'Required Documents',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      content: SizedBox(
        height: screenHeight * 0.3, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(), 
            ...documents.map(
              (doc) => Padding(
                padding: const EdgeInsets.only(top: 8.0), 
                child: Text(
                  '• $doc',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ), 
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); 
          },
         style: TextButton.styleFrom(
            foregroundColor: Colors.red, 
          ),
          child: Text(
            'Close',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
