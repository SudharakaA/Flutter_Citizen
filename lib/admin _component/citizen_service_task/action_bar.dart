import 'package:flutter/material.dart';
import 'action_button.dart';
import 'view_service_popup.dart'; // new file you'll create

class ActionBar extends StatelessWidget {
  final String title;
  final TextEditingController searchController;
  final Function(String) onSearch;

  const ActionBar({
    super.key,
    required this.title,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(thickness: 1, color: Colors.grey),
          const SizedBox(height: 8),
          Row(
            children: [
              // View Button (opens popup)
              
              // Search bar
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    onChanged: onSearch,
                  ),
                ),
              ),
               const SizedBox(width: 5),
              ActionButton(
                //icon: Icons.remove_red_eye,
                text: 'View',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const ViewServicePopup(),
                  );
                },
              ),
              //const SizedBox(width: 8),

            ],
          ),
        ],
      ),
    );
  }
}
