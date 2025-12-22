// components/pagination_component.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaginationComponent extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final Function(int) onPageChanged;

  const PaginationComponent({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    int startItem = (currentPage - 1) * itemsPerPage + 1;
    int endItem = currentPage * itemsPerPage;
    if (endItem > totalItems) endItem = totalItems;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          // Info text - centered and responsive
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Showing $startItem-$endItem of $totalItems users',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Pagination controls - only Previous/Next
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous button with text
              Expanded(
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.only(right: 8),
                  child: ElevatedButton.icon(
                    onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
                    icon: Icon(
                      Icons.chevron_left,
                      size: 18,
                      color: currentPage > 1 ? Colors.white : Colors.grey.shade400,
                    ),
                    label: Text(
                      'Previous',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentPage > 1 ? Colors.green.shade400 : Colors.grey.shade300,
                      foregroundColor: currentPage > 1 ? Colors.white : Colors.grey.shade500,
                      elevation: currentPage > 1 ? 2 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ),

              // Current page indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  '$currentPage / $totalPages',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),

              // Next button with text
              Expanded(
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 8),
                  child: ElevatedButton.icon(
                    onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
                    icon: Text(
                      'Next',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    label: Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: currentPage < totalPages ? Colors.white : Colors.grey.shade400,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentPage < totalPages ? Colors.green.shade400 : Colors.grey.shade300,
                      foregroundColor: currentPage < totalPages ? Colors.white : Colors.grey.shade500,
                      elevation: currentPage < totalPages ? 2 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}