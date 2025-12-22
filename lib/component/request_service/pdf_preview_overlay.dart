import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../request_service/action_button.dart';

class PdfPreviewOverlay extends StatelessWidget {
  final Future<Uint8List> Function() onBuildPdf;
  final VoidCallback onDownload;
  final VoidCallback onClose;

  const PdfPreviewOverlay({
    super.key,
    required this.onBuildPdf,
    required this.onDownload,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PDF Preview',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 180,
                      child: ActionButton(
                        text: 'Download',
                        icon: Icons.download,
                        onPressed: onDownload,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onClose,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: PdfPreview(
              build: (format) => onBuildPdf(),
              canChangeOrientation: false,
              canChangePageFormat: false,
              canDebug: false,
              allowPrinting: false,
              allowSharing: false,
              initialPageFormat: PdfPageFormat.a4,
            ),
          ),
        ],
      ),
    );
  }
}
