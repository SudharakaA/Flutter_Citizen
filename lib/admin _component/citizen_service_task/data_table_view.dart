import 'package:flutter/material.dart';
import 'sortable_column_header.dart';
import 'status_chip.dart';

class DataTableView extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String sortColumn;
  final bool sortAscending;
  final Function(String) onSort;
  final int? selectedRowIndex;
  final Function(int) onRowTap;
  final ScrollController horizontalScrollController;
  final List<Map<String, dynamic>> columnDefinitions;

  const DataTableView({
    super.key,
    required this.data,
    required this.sortColumn,
    required this.sortAscending,
    required this.onSort,
    required this.selectedRowIndex,
    required this.onRowTap,
    required this.horizontalScrollController,
    required this.columnDefinitions,
  });

  @override
  Widget build(BuildContext context) {
    double totalWidth = columnDefinitions.fold(
      0.0,
      (sum, item) => sum + (item['width'] as double),
    );

    return Scrollbar(
      controller: horizontalScrollController,
      thumbVisibility: true,
      trackVisibility: true,
      child: SingleChildScrollView(
        controller: horizontalScrollController,
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: totalWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Table Header
                Container(
                  color: Colors.grey.shade100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: columnDefinitions.map((column) {
                      return SizedBox(
                        width: column['width'] as double,
                        child: SortableColumnHeader(
                          column: column['key'] as String,
                          label: column['label'] as String,
                          width: column['width'] as double,
                          currentSortColumn: sortColumn,
                          isAscending: sortAscending,
                          onSort: onSort,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const Divider(height: 1),

                // Table Body
                ...data.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;
                  final isSelected = selectedRowIndex == index;

                  return InkWell(
                    onTap: () => onRowTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue.withOpacity(0.1)
                            : (index % 2 == 0
                                ? Colors.white
                                : Colors.grey.shade50),
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200),
                          left: isSelected
                              ? const BorderSide(color: Colors.blue, width: 3)
                              : BorderSide.none,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: columnDefinitions.map((column) {
                          String key = column['key'] as String;
                          double width = column['width'] as double;

                          Widget cellContent;
                          if (key == 'serviceStatus') {
                            cellContent = Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: StatusChip(status: item[key]),
                            );
                          } else {
                            cellContent = Padding(
                              padding: key == 'reference'
                                  ? const EdgeInsets.only(left: 16)
                                  : EdgeInsets.zero,
                              child: Text(
                                item[key].toString(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }

                          return SizedBox(
                            width: width,
                            child: cellContent,
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
