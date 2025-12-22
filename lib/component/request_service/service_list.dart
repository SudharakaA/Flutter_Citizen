import 'package:flutter/material.dart';

class ServiceListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> requestData;
  final Function(Map<String, dynamic>)? onItemTap;

  const ServiceListWidget({
    super.key,
    required this.requestData,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: requestData.length,
      itemBuilder: (context, index) {
        final request = requestData[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(
              request['REQUEST_TYPE']?.toString() ?? 'Unknown Service',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ref: ${request['REQUEST_REFERENCE']?.toString() ?? 'N/A'}'),
                const SizedBox(height: 4),
                
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              if (onItemTap != null) {
                onItemTap!(request);
              }
            },
          ),
        );
      },
    );
  }

  
}