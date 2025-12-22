import 'package:flutter/material.dart';

class MultiSelectDialog extends StatefulWidget {
  final List<String> items;
  final List<String> initialSelection;
  final Function(List<String>) onSelectionChanged;
  final String title;

  const MultiSelectDialog({
    super.key,
    required this.items,
    required this.initialSelection,
    required this.onSelectionChanged,
    this.title = 'Select Services', //Default title
  });

  @override
  State<MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> tempSelection;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    tempSelection = List.from(widget.initialSelection);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      title: Text(widget.title),

      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    return CheckboxListTile(
                      title: Text(item),
                      value: tempSelection.contains(item),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            if (!tempSelection.contains(item)) {
                              tempSelection.add(item);
                            }
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
          ],
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
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFF3A7D44)),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onSelectionChanged(tempSelection);
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
