import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../component/custom_back_button.dart';
import '../../../component/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../../../component/request_service/action_button.dart';

class AddHeaderPage extends StatefulWidget {
  const AddHeaderPage({super.key});

  @override
  State<AddHeaderPage> createState() => _AddHeaderPageState();
}

class _AddHeaderPageState extends State<AddHeaderPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(leading: CustomBackButton()),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: screenHeight * 0.02,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          height: screenHeight,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                "Add Payment Configuration",
                style: GoogleFonts.inter(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(
                thickness: 1,
                color: Colors.black38,
                indent: 20,
                endIndent: 20,
              ),
              SizedBox(height: screenHeight * 0.02),

              // Form and fields in expanded scrollable area
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextField(
                          label: "Header Code",
                          controller: TextEditingController(),
                          validatorMsg: "Please enter header code",
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                        buildTextField(
                          label: "Header Name",
                          controller: TextEditingController(),
                          validatorMsg: "Please enter header name",
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                        buildTextField(
                          label: "Default Amount",
                          controller: TextEditingController(),
                          validatorMsg: "Please enter default amount",
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Submit button pinned to bottom of white container
              ActionButton(
                text: 'Submit',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Payment Configuration Submitted'),
                      ),
                    );
                    // Delay navigation slightly to allow the snackbar to show
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Navigator.pop(context);
                    });
                    // Add submission logic here
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable text input
  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required String validatorMsg,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: keyboardType == TextInputType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          validator: (value) =>
              value == null || value.isEmpty ? validatorMsg : null,
          decoration: inputDecoration(screenWidth, screenHeight).copyWith(
            hintText: "Enter $label".toLowerCase(),
            hintStyle: TextStyle(
              color: const Color.fromARGB(255, 5, 52, 90),
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }

  // Common input decoration
  InputDecoration inputDecoration(double screenWidth, double screenHeight) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenHeight * 0.012,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
        borderSide: const BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
        borderSide: const BorderSide(color: Colors.green),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
