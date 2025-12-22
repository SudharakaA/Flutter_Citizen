import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemSearchDialog extends StatelessWidget {
  final Function(String) onSearch;

  const ItemSearchDialog({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    String searchQuery = '';

    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Search Items",
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Divider(
            color: Colors.black38,
            thickness: 1,
          ),
        ],
      ),
      content: SizedBox(
        width: screenWidth * 0.6,
        height: screenHeight * 0.1,
        child: TextField(
          textAlign: TextAlign.center,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Enter good name",
            hintStyle: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.black54,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.green),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
          ),
          onChanged: (value) {
            searchQuery = value.toLowerCase();
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
         style: TextButton.styleFrom(
            foregroundColor: Colors.red, 
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3A7D44),
          ),
          onPressed: () {
            onSearch(searchQuery);
            Navigator.pop(context);
          },
          child: Text(
            "Search",
            style: GoogleFonts.inter(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
