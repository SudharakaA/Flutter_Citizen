import 'package:flutter/material.dart';

class DownloadDialog extends StatelessWidget {
  const DownloadDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Center(
        child: Text(
          'Download Format',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.045,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(thickness: 1),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf, color: Color(0xFF3A7D44)),
            title: const Text('PDF'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading as PDF...')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.table_chart, color: Color(0xFF3A7D44)),
            title: const Text('Excel'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading as Excel...')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description, color: Color(0xFF3A7D44)),
            title: const Text('CSV'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading as CSV...')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.print, color: Color(0xFF3A7D44)),
            title: const Text('Print'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sending to printer...')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.copy, color: Color(0xFF3A7D44)),
            title: const Text('Copy'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard...')),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.red, 
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

void showDownloadOptions(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => const DownloadDialog(),
  );
}
