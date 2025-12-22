import 'package:flutter/material.dart';
import '../../../admin _component/citizen_service_task/status_chip.dart';
import '../../../admin _component/citizen_service_task/sortable_column_header.dart';


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
      child: SingleChildScrollView(
        controller: horizontalScrollController,
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: totalWidth,
          child: Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
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

              // Body
              ...data.asMap().entries.map((entry) {
                int index = entry.key;
                var item = entry.value;
                bool isSelected = selectedRowIndex == index;

                return InkWell(
                  onTap: () => onRowTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          // ignore: deprecated_member_use
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
                      children: columnDefinitions.map((column) {
                        String key = column['key'] as String;
                        double width = column['width'] as double;

                        Widget content;
                        if (key == 'serviceStatus') {
                          content = StatusChip(status: item[key]);
                        } else {
                          content = Text(
                            item[key]?.toString() ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          );
                        }

                        return SizedBox(
                          width: width,
                          child: Padding(
                            padding: key == 'reference'
                                ? const EdgeInsets.only(left: 16)
                                : const EdgeInsets.symmetric(horizontal: 8),
                            child: content,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              // ignore: unnecessary_to_list_in_spreads
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
