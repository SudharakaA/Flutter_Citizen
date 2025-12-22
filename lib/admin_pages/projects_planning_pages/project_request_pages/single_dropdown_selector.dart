
import 'package:flutter/material.dart';

class SingleDropdownSelector<T> extends StatelessWidget {
  final String? title;
  final List<T>? options;
  final T? selectedItem;
  final String Function(T)? getDisplayText; // Function to get display text
  final String? Function(T)? getId; // Function to get ID
  final Function(String?)? onSelectionChanged;

  const SingleDropdownSelector({
    super.key,
     this.title,
     this.options,
     this.selectedItem,
     this.getDisplayText,
     this.getId,
     this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasSelection = selectedItem != null;

    return InkWell(
      onTap: () => _showSingleSelectDialog(context),
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
              hasSelection ? getDisplayText!(selectedItem!) : 'Nothing Selected',
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

  void _showSingleSelectDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => _StyledSingleSelectDialog<T>(
        title: title!,
        items: options!,
        initialSelection: selectedItem,
        getDisplayText: getDisplayText!,
        getId: getId!,
        onApply: (selected) => onSelectionChanged!(selected != null ? getId!(selected) : null),
      ),
    );
  }
}

class _StyledSingleSelectDialog<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final T? initialSelection;
  final String Function(T) getDisplayText;
  final String? Function(T) getId;
  final Function(T?) onApply;

  const _StyledSingleSelectDialog({
    required this.title,
    required this.items,
    required this.initialSelection,
    required this.getDisplayText,
    required this.getId,
    required this.onApply,
  });

  @override
  State<_StyledSingleSelectDialog<T>> createState() => _StyledSingleSelectDialogState<T>();
}

class _StyledSingleSelectDialogState<T> extends State<_StyledSingleSelectDialog<T>> {
  T? tempSelection;

  @override
  void initState() {
    super.initState();
    tempSelection = widget.initialSelection;
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
              return RadioListTile<T>(
                title: Text(widget.getDisplayText(item)),
                value: item,
                groupValue: tempSelection,
                onChanged: (T? selected) {
                  setState(() {
                    tempSelection = selected;
                  });
                },
                activeColor: const Color(0xFF3A7D44),
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
              tempSelection = null; // Clear selection
            });
          },
          child: const Text(
            'Clear',
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