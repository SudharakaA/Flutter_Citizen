// components/user_data_table_component.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class UserDataTableComponent extends StatelessWidget {
  final List<String> columnLabels;
  final List<Map<String, dynamic>> paginatedUsers;
  final bool isLoadingUsers;
  final bool isProcessing;
  final Function(Map<String, dynamic>) onUserActions;

  const UserDataTableComponent({
    super.key,
    required this.columnLabels,
    required this.paginatedUsers,
    required this.isLoadingUsers,
    required this.isProcessing,
    required this.onUserActions,
  });

  // Skeleton Loading Row Widget
  DataRow _buildSkeletonRow() {
    return DataRow(
      cells: columnLabels.map((label) {
        if (label == 'Actions') {
          return DataCell(
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        } else {
          // Different widths for different columns to make it look more realistic
          double skeletonWidth;
          switch (label) {
            case 'Username':
              skeletonWidth = 80;
              break;
            case 'Calling name':
              skeletonWidth = 100;
              break;
            case 'Designation':
              skeletonWidth = 120;
              break;
            case 'Work Location':
              skeletonWidth = 90;
              break;
            case 'Mobile number':
              skeletonWidth = 85;
              break;
            default:
              skeletonWidth = 80;
          }

          return DataCell(
            Container(
              width: skeletonWidth,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade300),
        columns: columnLabels
            .map((label) => DataColumn(
          label: Text(
            label.tr(),
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ))
            .toList(),
        rows: isLoadingUsers
            ? List.generate(9, (index) => _buildSkeletonRow())
            : paginatedUsers
            .map((user) => DataRow(
          cells: [
            DataCell(
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: isProcessing ? null : () => onUserActions(user),
              ),
            ),
            DataCell(Text(
              user['username'] ?? '',
              style: GoogleFonts.inter(fontSize: 13),
            )),
            DataCell(Text(
              user['callingName'] ?? '',
              style: GoogleFonts.inter(fontSize: 13),
            )),
            DataCell(Text(
              user['designation'] ?? '',
              style: GoogleFonts.inter(fontSize: 13),
            )),
            DataCell(Text(
              user['workLocation'] ?? '',
              style: GoogleFonts.inter(fontSize: 13),
            )),
            DataCell(Text(
              user['mobileNumber'] ?? '',
              style: GoogleFonts.inter(fontSize: 13),
            )),
          ],
        ))
            .toList(),
      ),
    );
  }
}