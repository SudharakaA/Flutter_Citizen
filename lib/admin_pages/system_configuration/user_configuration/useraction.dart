// components/user_actions_component.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserActionsComponent {
  static void showUserActions({
    required BuildContext context,
    required Map<String, dynamic> user,
    required String accessToken,
    required Function() onViewDetails,
    required Function() onEditUser,
    required Function() onPrivilegeDetails,
    required Function() onResetPassword,
    required Function() onDeleteUser,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 10),

              Text(
                'Actions for ${user['callingName']}',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              _buildActionTile(
                icon: Icons.visibility,
                iconColor: Colors.blue.shade600,
                backgroundColor: Colors.blue.shade50,
                title: 'View Details',
                subtitle: 'View complete user information',
                onTap: onViewDetails,
              ),

              _buildActionTile(
                icon: Icons.edit,
                iconColor: Colors.green.shade600,
                backgroundColor: Colors.green.shade50,
                title: 'Edit User',
                subtitle: 'Modify user information',
                onTap: onEditUser,
              ),

              _buildActionTile(
                icon: Icons.note_alt_outlined,
                iconColor: Colors.orange.shade600,
                backgroundColor: Colors.blue.shade50,
                title: 'Privilege Details',
                subtitle: 'View Privilege Details',
                onTap: onPrivilegeDetails,
              ),

              _buildActionTile(
                icon: Icons.key,
                iconColor: Colors.orange.shade600,
                backgroundColor: Colors.orange.shade50,
                title: 'Reset Password',
                subtitle: 'User Password Reset from system',
                onTap: onResetPassword,
              ),

              _buildActionTile(
                icon: Icons.delete,
                iconColor: Colors.red.shade600,
                backgroundColor: Colors.red.shade50,
                title: 'Delete User',
                subtitle: 'Remove user from system',
                onTap: onDeleteUser,
              ),

              const SizedBox(height: 6),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildActionTile({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 18,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      onTap: onTap,
    );
  }

  // Confirmation Dialogs
  static void showPasswordResetConfirmation({
    required BuildContext context,
    required Map<String, dynamic> user,
    required bool isProcessing,
    required Function() onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(
                Icons.key,
                color: Colors.orange,
                size: 30,
              ),
              const SizedBox(width: 10),
              Text(
                'Reset Password',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to reset the password for ${user['callingName']}?\n\nThis action will generate a new password for the user.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            TextButton(
              onPressed: isProcessing ? null : onConfirm,
              style: TextButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isProcessing
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text('Reset Password'),
            ),
          ],
        );
      },
    );
  }

  static void showDeleteConfirmation({
    required BuildContext context,
    required Map<String, dynamic> user,
    required bool isProcessing,
    required Function() onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.red,
                size: 30,
              ),
              const SizedBox(width: 10),
              Text(
                'Delete User',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete user ${user['callingName']}?\n\nThis action cannot be undone.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            TextButton(
              onPressed: isProcessing ? null : onConfirm,
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isProcessing
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}