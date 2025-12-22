import 'package:flutter/material.dart';
import 'package:citizen_care_system/component/request_service/format_button.dart';
import 'package:citizen_care_system/component/request_service/action_button.dart';

class DownloadSectionWidget extends StatefulWidget {
  const DownloadSectionWidget({super.key});

  @override
  State<DownloadSectionWidget> createState() => _DownloadSectionWidgetState();
}

class _DownloadSectionWidgetState extends State<DownloadSectionWidget> {
  String selectedFormat = "CSV";

  void _downloadAllRequests(BuildContext context, String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading all requests in $format format'),
        duration: const Duration(seconds: 2),
      ),
    );
    // Call backend logic for download
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // Format selection buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FormatButtonWidget(
                format: "CSV",
                isSelected: selectedFormat == "CSV",
                onTap: () => setState(() => selectedFormat = "CSV"),
              ),
              const SizedBox(width: 10),
              FormatButtonWidget(
                format: "Excel",
                isSelected: selectedFormat == "Excel",
                onTap: () => setState(() => selectedFormat = "Excel"),
              ),
              const SizedBox(width: 10),
              FormatButtonWidget(
                format: "PDF",
                isSelected: selectedFormat == "PDF",
                onTap: () => setState(() => selectedFormat = "PDF"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Download button using ActionButton
          SizedBox(
            width: 200,
            child: ActionButton(
              text: "Download",
              icon: Icons.download,
              onPressed: () => _downloadAllRequests(context, selectedFormat),
            ),
          ),
        ],
      ),
    );
  }
}
