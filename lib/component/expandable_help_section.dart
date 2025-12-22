import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_rounded_rectangle.dart';

class ExpandableHelpSection extends StatefulWidget {
  final String title;
  final List<String> items;
  final Function(String)? onItemTap; 

  const ExpandableHelpSection({
    super.key,
    required this.title,
    required this.items,
    this.onItemTap, 
  });

  @override
  State<ExpandableHelpSection> createState() => _ExpandableHelpSectionState();
}

class _ExpandableHelpSectionState extends State<ExpandableHelpSection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomRoundedRectangle(
          title: widget.title,
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        ),
        if (isExpanded)
          Column(
            children: widget.items.map((item) {
              return GestureDetector(
                onTap: () {
                  if (widget.onItemTap != null) {
                    widget.onItemTap!(item); 
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    item,
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
