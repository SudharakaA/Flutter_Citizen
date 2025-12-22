import 'package:flutter/material.dart';

class SortableColumnHeader extends StatelessWidget {
  final String column;
  final String label;
  final double width;
  final String currentSortColumn;
  final bool isAscending;
  final Function(String) onSort;

  const SortableColumnHeader({
    super.key,
    required this.column,
    required this.label,
    required this.width,
    required this.currentSortColumn,
    required this.isAscending,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentSortColumn = currentSortColumn == column;

    return InkWell(
      onTap: () => onSort(column),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (isCurrentSortColumn) ...[
              const SizedBox(width: 4),
              Icon(
                isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
              ),
            ],
          ],
        ),
      ),
    );
  }
}