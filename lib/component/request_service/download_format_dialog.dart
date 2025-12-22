import 'package:flutter/material.dart';
import '../request_service/format_button.dart';

class DownloadFormatDialog extends StatelessWidget {
  final String selectedFormat;
  final Function(String) onSelectFormat;

  const DownloadFormatDialog({
    super.key,
    required this.selectedFormat,
    required this.onSelectFormat,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Choose Format"),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Select a format to download your request details:"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ["PDF", "CSV", "Excel"].map((format) {
                return FormatButtonWidget(
                  format: format,
                  isSelected: selectedFormat == format,
                  onTap: () {
                    Navigator.pop(context);
                    onSelectFormat(format);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
