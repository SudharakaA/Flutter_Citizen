import 'package:flutter/material.dart';
import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';
import '../action_button.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPage();
}

class _ChangePasswordPage extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(
        leading: CustomBackButton(),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF).withOpacity(0.8),
          borderRadius: BorderRadius.circular(25),
        ),
        child: ListView(
          children: [
            const Center(
              child: Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
              height: 30,
            ),
            const SizedBox(height: 32),
            buildTextField('Old password', _oldPasswordController),
            const SizedBox(height: 16),
            buildTextField('New password', _newPasswordController),
            const SizedBox(height: 16),
            buildTextField('Confirm new password', _confirmPasswordController),
            const SizedBox(height: 32),
            Center(
              child: ActionButton(
                text: 'Change',
                onPressed: () {
                  // Add your change password logic here
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
