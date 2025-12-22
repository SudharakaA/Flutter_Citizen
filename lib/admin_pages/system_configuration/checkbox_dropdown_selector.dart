import 'package:flutter/material.dart';

class CheckboxDropdownSelector extends StatelessWidget {
  final String title;
  final List<String> options;
  final List<String> selectedItems;
  final Function(List<String>) onSelectionChanged;

  const CheckboxDropdownSelector({
    super.key,
    required this.title,
    required this.options,
    required this.selectedItems,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasSelection = selectedItems.isNotEmpty;

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
            Text(
              hasSelection
                  ? '${selectedItems.length} selected'
                  : 'Nothing Selected',
              style: TextStyle(
                fontSize: 16,
                color: hasSelection ? Colors.black : Colors.grey,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showMultiSelectDialog(BuildContext context) async {
    final List<String> tempSelection = List.from(selectedItems);

    await showDialog(
      context: context,
      builder: (_) => _StyledMultiSelectDialog(
        title: title,
        items: options,
        initialSelection: tempSelection,
        onApply: (selected) => onSelectionChanged(selected),
      ),
    );
  }
}

class _StyledMultiSelectDialog extends StatefulWidget {
  final String title;
  final List<String> items;
  final List<String> initialSelection;
  final Function(List<String>) onApply;

  const _StyledMultiSelectDialog({
    required this.title,
    required this.items,
    required this.initialSelection,
    required this.onApply,
  });

  @override
  State<_StyledMultiSelectDialog> createState() =>
      _StyledMultiSelectDialogState();
}

class _StyledMultiSelectDialogState extends State<_StyledMultiSelectDialog> {
  late List<String> tempSelection;

  @override
  void initState() {
    super.initState();
    tempSelection = List.from(widget.initialSelection);
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
        child: Scrollbar(
          controller: scrollController,
          thumbVisibility: true,
          child: ListView.builder(
            controller: scrollController,
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return CheckboxListTile(
                title: Text(item),
                value: tempSelection.contains(item),
                onChanged: (bool? selected) {
                  setState(() {
                    if (selected == true) {
                      tempSelection.add(item);
                    } else {
                      tempSelection.remove(item);
                    }
                  });
                },
                activeColor: const Color(0xFF3A7D44),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              tempSelection.clear();
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
