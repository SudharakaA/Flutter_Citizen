import 'package:flutter/material.dart';

class MultipleDropdownSelector<T> extends StatelessWidget {
  final String? title;
  final List<T>? options;
  final List<T>? selectedItems;
  final String Function(T)? getDisplayText; // Function to get display text
  final String? Function(T)? getId; // Function to get ID
  final Function(List<String?>?)? onSelectionChanged;
  final int? maxDisplayItems; // Maximum items to show in display text
  final String? selectAllText; // Text for "Select All" option

  const MultipleDropdownSelector({
    super.key,
    this.title,
    this.options,
    this.selectedItems,
    this.getDisplayText,
    this.getId,
    this.onSelectionChanged,
    this.maxDisplayItems = 3,
    this.selectAllText,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasSelection = selectedItems != null && selectedItems!.isNotEmpty;

    return InkWell(
      onTap: () => _showMultiSelectDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                hasSelection ? _getDisplayText() : 'Nothing Selected',
                style: TextStyle(
                  fontSize: 16,
                  color: hasSelection ? Colors.black : Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  String _getDisplayText() {
    if (selectedItems == null || selectedItems!.isEmpty) {
      return 'Nothing Selected';
    }

    final displayItems = selectedItems!.take(maxDisplayItems!).map((item) => getDisplayText!(item)).toList();
    
    if (selectedItems!.length > maxDisplayItems!) {
      return '${displayItems.join(', ')} and ${selectedItems!.length - maxDisplayItems!} more';
    } else {
      return displayItems.join(', ');
    }
  }

  void _showMultiSelectDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => _StyledMultiSelectDialog<T>(
        title: title!,
        items: options!,
        initialSelection: selectedItems ?? [],
        getDisplayText: getDisplayText!,
        getId: getId!,
        selectAllText: selectAllText,
        onApply: (selectedList) {
          final selectedIds = selectedList.map((item) => getId!(item)).toList();
          onSelectionChanged!(selectedIds);
        },
      ),
    );
  }
}

class _StyledMultiSelectDialog<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final List<T> initialSelection;
  final String Function(T) getDisplayText;
  final String? Function(T) getId;
  final String? selectAllText;
  final Function(List<T>) onApply;

  const _StyledMultiSelectDialog({
    required this.title,
    required this.items,
    required this.initialSelection,
    required this.getDisplayText,
    required this.getId,
    this.selectAllText,
    required this.onApply,
  });

  @override
  State<_StyledMultiSelectDialog<T>> createState() => _StyledMultiSelectDialogState<T>();
}

class _StyledMultiSelectDialogState<T> extends State<_StyledMultiSelectDialog<T>> {
  List<T> tempSelection = [];

  @override
  void initState() {
    super.initState();
    tempSelection = List<T>.from(widget.initialSelection);
  }

  bool get isAllSelected => tempSelection.length == widget.items.length;

  void _toggleSelectAll() {
    setState(() {
      if (isAllSelected) {
        tempSelection.clear();
      } else {
        tempSelection = List<T>.from(widget.items);
      }
    });
  }

  void _toggleItemSelection(T item) {
    setState(() {
      if (tempSelection.contains(item)) {
        tempSelection.remove(item);
      } else {
        tempSelection.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Select ${widget.title}'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            // Selection count display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '${tempSelection.length} of ${widget.items.length} selected',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Select All option (if enabled)
            if (widget.selectAllText != null) ...[
              CheckboxListTile(
                title: Text(
                  widget.selectAllText!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                value: isAllSelected,
                onChanged: (bool? value) => _toggleSelectAll(),
                activeColor: const Color(0xFF3A7D44),
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const Divider(height: 1),
            ],
            // Items list
            Expanded(
              child: Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    final isSelected = tempSelection.contains(item);
                    
                    return CheckboxListTile(
                      title: Text(widget.getDisplayText(item)),
                      value: isSelected,
                      onChanged: (bool? selected) => _toggleItemSelection(item),
                      activeColor: const Color(0xFF3A7D44),
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              tempSelection.clear(); // Clear all selections
            });
          },
          child: const Text(
            'Clear All',
            style: TextStyle(color: Color(0xFF3A7D44)),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFF3A7D44)),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onApply(tempSelection);
            Navigator.of(context).pop();
          },
          child: const Text(
            'Apply',
            style: TextStyle(color: Color(0xFF3A7D44)),
          ),
        ),
      ],
    );
  }
}

