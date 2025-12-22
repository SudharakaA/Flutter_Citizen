// admin_component/services_list_container.dart
import 'package:flutter/material.dart';
import 'services_card.dart';
import 'services_menu_item.dart';

class ServicesListContainer extends StatelessWidget {
  final List<ServicesMenuItem> items;
  final Function(ServicesMenuItem item) onItemTap;

  const ServicesListContainer({
    super.key,
    required this.items,
    required this.onItemTap, required Color backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: const Color(0xFFFFFFFF).withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ServicesCard(
              item: item,
              onTap: () => onItemTap(item),
            ),
          );
        },
      ),
    );
  }
}