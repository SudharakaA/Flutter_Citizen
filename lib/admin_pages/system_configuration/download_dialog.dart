import 'package:flutter/material.dart';

class DownloadDialog extends StatelessWidget {
  const DownloadDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Download Format'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: const Text('PDF'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading as PDF...')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.table_chart),
            title: const Text('Excel'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading as Excel...')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('CSV'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading as CSV...')),
              );
            },
          ),
        ],
      ),
    );
  }
}

void showDownloadOptions(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => const DownloadDialog(),
  );
}