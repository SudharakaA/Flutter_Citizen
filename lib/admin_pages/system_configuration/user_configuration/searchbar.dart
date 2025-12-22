// components/user_search_component.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserSearchComponent extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final VoidCallback onClear;

  const UserSearchComponent({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search users by name, username, designation, location, or mobile...',
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.grey.shade600,
            ),
            onPressed: onClear,
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: GoogleFonts.inter(fontSize: 14),
      ),
    );
  }
}