import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int currentPageItems;
  final int itemsPerPage;
  final Function(int) onPageChange;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.currentPageItems,
    required this.itemsPerPage,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing ${(currentPage - 1) * itemsPerPage + currentPageItems} of $totalItems entries',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.first_page),
                visualDensity: VisualDensity.compact,
                onPressed: currentPage > 1
                    ? () => onPageChange(1)
                    : null,
                color: Colors.grey.shade700,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                visualDensity: VisualDensity.compact,
                onPressed: currentPage > 1
                    ? () => onPageChange(currentPage - 1)
                    : null,
                color: Colors.grey.shade700,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text('$currentPage of $totalPages'),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                visualDensity: VisualDensity.compact,
                onPressed: currentPage < totalPages
                    ? () => onPageChange(currentPage + 1)
                    : null,
                color: Colors.grey.shade700,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              IconButton(
                icon: const Icon(Icons.last_page),
                visualDensity: VisualDensity.compact,
                onPressed: currentPage < totalPages
                    ? () => onPageChange(totalPages)
                    : null,
                color: Colors.grey.shade700,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}