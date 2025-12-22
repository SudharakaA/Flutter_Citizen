import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

import '../../component/custom_back_button.dart';
import '../../component/custom_app_bar.dart';
import '../../component/admin_circle_menu/fab_menu.dart';
import '../../component/admin_circle_menu/hover_tap_button.dart';
import '../../admin _component/character_admin/view_character_certificate_page.dart';
import '../../admin _component/character_admin/print_character_certificate_page.dart';
import '../../admin _component/citizen_service_task/download_dialog.dart';

class CharacterCertificatePopup extends StatefulWidget {
  const CharacterCertificatePopup({super.key});

  @override
  State<CharacterCertificatePopup> createState() => _CharacterCertificatePopupState();
}

class _CharacterCertificatePopupState extends State<CharacterCertificatePopup> {
  final _formKey = GlobalKey<FormState>();

  String? selectedFileType;
  final List<String> fileTypes = ['Colombo', 'Gampaha', 'Kalutara', 'Kandy',
    'Matale', 'Nuwara Eliya', 'Galle', 'Badulla', 'Monaragala', 'Ratnapura', 'Kegalle',
    'Matara', 'Hambantota', 'Trincomalee', 'Batticaloa', 'Ampara', 'Kurunegala', 'Puttalam',
    'Kilinochchi', 'Mannar', 'Vavuniya','Mullaitivu', 'Jaffna', 'Anuradhapura', 'Polonnaruwa',];

  String? selectedOption;
  final List<String> options = ['Male', 'Female', 'Others'];

  final TextEditingController nicController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController divisionalSecretariatController = TextEditingController();
  final TextEditingController gramaNiladariDivisionController = TextEditingController();
  final TextEditingController applicantPersonallyController = TextEditingController();
  final TextEditingController haveYouKnownController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController correctAddressController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  final TextEditingController residenceController = TextEditingController();
  final TextEditingController rollNumberAndRegistrationController = TextEditingController();
  final TextEditingController fatherController = TextEditingController();
  final TextEditingController fatherAddController = TextEditingController();
  final TextEditingController requiringCertificationController = TextEditingController();
  final TextEditingController residenceInGramaNiladhariController = TextEditingController();
  final TextEditingController proofController = TextEditingController();
  final TextEditingController courtController = TextEditingController();
  final TextEditingController interestController = TextEditingController();
  final TextEditingController characterController = TextEditingController();


  @override
  void dispose() {
    numberController.dispose();
    divisionalSecretariatController.dispose();
    gramaNiladariDivisionController.dispose();
    applicantPersonallyController.dispose();
    haveYouKnownController.dispose();
    fullNameController.dispose();
    correctAddressController.dispose();
    statusController.dispose();
    nationalityController.dispose();
    religionController.dispose();
    jobController.dispose();
    residenceController.dispose();
    rollNumberAndRegistrationController.dispose();
    nicController.dispose();
    fatherController.dispose();
    fatherAddController.dispose();
    requiringCertificationController.dispose();
    residenceInGramaNiladhariController.dispose();
    proofController.dispose();
    courtController.dispose();
    interestController.dispose();
    characterController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(leading: CustomBackButton()),
      body: Container(
        margin: EdgeInsets.all(screenWidth * 0.03),
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Character Certificate',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(thickness: 1, color: Colors.black38, indent: 20, endIndent: 20),
                const SizedBox(height: 20),


                _buildLabel("District:"),
                _buildDropdownField(
                  selectedFileType,
                  fileTypes,
                      (value) => setState(() => selectedFileType = value),
                  'Please select a district',
                  label: 'Select District',
                ),

                const SizedBox(height: 20),

                _buildLabel("Divisional Secretariat:"),
                _buildTextField(
                  controller: divisionalSecretariatController,
                  hint: 'Enter divisional secretariat',
                  validatorMessage: 'Please enter divisional secretariat',
                ),

                const SizedBox(height: 20),

                _buildLabel("Grama Niladari Division and Number:"),
                _buildTextField(
                  controller: gramaNiladariDivisionController,
                  hint: 'Division and Number',
                  validatorMessage: 'Please enter division and number',
                ),

                const SizedBox(height: 20),

                _buildLabel("Is the applicant personally known?"),
                _buildTextField(
                  controller: applicantPersonallyController,
                  hint: 'Applicant personally known?',
                  validatorMessage: 'Please enter details',
                ),

                const SizedBox(height: 20),

                // How long known
                _buildLabel("How long have you known?:"),
                _buildTextField(
                  controller: haveYouKnownController,
                  hint: 'How long have you known?',
                  validatorMessage: 'Please Enter Details',
                ),

                const SizedBox(height: 20),

                // Full Name
                _buildLabel("Name:"),
                _buildTextField(
                  controller: fullNameController,
                  hint: 'Enter the full Name',
                  validatorMessage: 'Please Enter Name',
                ),

                const SizedBox(height: 20),

                // Address
                _buildLabel("Address:"),
                _buildTextField(
                  controller: correctAddressController,
                  hint: 'Enter the Address',
                  validatorMessage: 'Please Enter Address',
                ),

                const SizedBox(height: 20),

                // Gender Dropdown
                _buildLabel("Gender:"),
                _buildDropdownField(
                  selectedOption,
                  options,
                      (value) => setState(() => selectedOption = value),
                  'Please select an option',
                  label: 'Select Gender',
                ),

                const SizedBox(height: 20),

                // Age field
                _buildLabel("Age:"),
                TextFormField(
                  controller: numberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDecoration('Enter a number'),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a number' : null,
                ),

                const SizedBox(height: 30),

                // Marital Status
                _buildLabel("Marital Status:"),
                _buildTextField(
                  controller: statusController,
                  hint: 'Enter the Status',
                  validatorMessage: 'Please Enter Marital Status',
                ),

                const SizedBox(height: 20),

                // Nationality
                _buildLabel("Nationality:"),
                _buildTextField(
                  controller: nationalityController,
                  hint: 'Enter the Nationality',
                  validatorMessage: 'Please Enter Nationality',
                ),

                const SizedBox(height: 20),

                // Religion
                _buildLabel("Religion:"),
                _buildTextField(
                  controller: religionController,
                  hint: 'Enter the Religion',
                  validatorMessage: 'Please Enter Religion',
                ),

                const SizedBox(height: 20),

                // Job
                _buildLabel("Current Job:"),
                _buildTextField(
                  controller: jobController,
                  hint: 'Enter the Job',
                  validatorMessage: 'Please Enter Job',
                ),

                const SizedBox(height: 20),

                // Residence Period
                _buildLabel("Residence Period:"),
                _buildTextField(
                  controller: residenceController,
                  hint: 'Enter the Residence Period',
                  validatorMessage: 'Please Enter Residence',
                ),

                const SizedBox(height: 20),

                _buildLabel("NIC Number (10 characters - 9 digits + V/X):"),
                TextFormField(
                  controller: nicController,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9VXvx]'))],
                  decoration: _inputDecoration('Eg: 123456789V'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter NIC number';
                    } else if (!RegExp(r'^\d{9}[VXvx]{1}\$').hasMatch(value)) {
                      return 'NIC must be 9 digits followed by V or X';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Electoral roll number and Registration detials
                _buildLabel("Roll number and Registration:"),
                _buildTextField(
                  controller: rollNumberAndRegistrationController,
                  hint: 'Enter the Roll number , Registration',
                  validatorMessage: 'Please Enter Details',
                ),

                const SizedBox(height: 20),

                // Father's Name
                _buildLabel("Father's Name:"),
                _buildTextField(
                  controller: fatherController,
                  hint: 'Enter the Father Name',
                  validatorMessage: 'Please Enter the Father Name',
                ),

                const SizedBox(height: 20),

                // Father's Address
                _buildLabel("Father's Address:"),
                _buildTextField(
                  controller: fatherAddController,
                  hint: 'Enter the Father Address',
                  validatorMessage: 'Please Enter the Father Address',
                ),

                const SizedBox(height: 20),

                // Matter requiring certification
                _buildLabel("Matter Requiring Certification:"),
                _buildTextField(
                  controller: requiringCertificationController,
                  hint: 'Enter the Requiring Certification',
                  validatorMessage: 'Please Enter the Requiring Certification',
                ),

                const SizedBox(height: 20),

                // Period of Residence in Grama Niladhari Division
                _buildLabel("Period of Residence in Grama Niladhari Division:"),
                _buildTextField(
                  controller: residenceInGramaNiladhariController,
                  hint: 'Enter the Period of Residence in Grama Niladhari',
                  validatorMessage: 'Please Enter the Details',
                ),

                const SizedBox(height: 20),

                // Proof of Residency
                _buildLabel("Proof of Residency:"),
                _buildTextField(
                  controller: proofController,
                  hint: 'Enter the Proof of Residency',
                  validatorMessage: 'Please Enter the Proof of Residency',
                ),

                const SizedBox(height: 20),

                // Whether the applicant has been convicted by a Court
                _buildLabel("Applicant has been Convicted by a Court:"),
                _buildTextField(
                  controller: courtController,
                  hint: 'Enter the Convicted by a Court',
                  validatorMessage: 'Please Enter the Convicted by a Court',
                ),

                const SizedBox(height: 20),

                // Interest in public work and social work
                _buildLabel("Interest in Public Work and Social Work:"),
                _buildTextField(
                  controller: interestController,
                  hint: 'Enter the Interest work',
                  validatorMessage: 'Please Enter the Interest work',
                ),

                const SizedBox(height: 20),

                // Character
                _buildLabel("Character:"),
                _buildTextField(
                  controller: characterController,
                  hint: 'Enter the Character detail',
                  validatorMessage: 'Please Enter the Character',
                ),

                const SizedBox(height: 20),



                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _formKey.currentState?.reset();
                      fileTypes.clear();
                      options.clear();
                      numberController.clear();
                      divisionalSecretariatController.clear();
                      gramaNiladariDivisionController.clear();
                      applicantPersonallyController.clear();
                      haveYouKnownController.clear();
                      fullNameController.clear();
                      correctAddressController.clear();
                      statusController.clear();
                      nationalityController.clear();
                      religionController.clear();
                      jobController.clear();
                      residenceController.clear();
                      rollNumberAndRegistrationController.clear();
                      nicController.clear();
                      fatherController.clear();
                      fatherAddController.clear();
                      requiringCertificationController.clear();
                      residenceInGramaNiladhariController.clear();
                      proofController.clear();
                      courtController.clear();
                      interestController.clear();
                      characterController.clear();
                      setState(() => selectedFileType = null);
                    },
                    child: const Text('Clear'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: CustomFabMenu(
        menuItems: [
          HoverTapButton(
            icon: Icons.view_list,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewCharacterCertificatePage()),
              );
            },
          ),
          HoverTapButton(
            icon: Icons.print,
            onTap: () {
              if (_formKey.currentState!.validate()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrintCharacterCertificatePage(
                      nic: nicController.text,
                      district: selectedFileType!,
                      divisionalSecretariat: divisionalSecretariatController.text,
                      gramaDivision: gramaNiladariDivisionController.text,
                      known: applicantPersonallyController.text,
                    ),
                  ),
                );
              }
            },
          ),
          HoverTapButton(
            icon: Icons.download,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const DownloadDialog(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String validatorMessage,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(hint),
      validator: (value) => value == null || value.isEmpty ? validatorMessage : null,
    );
  }

  Widget _buildDropdownField(
      String? selectedValue,
      List<String> items,
      void Function(String?) onChanged,
      String validatorMessage, {
        String? label,
      }) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      items: items.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) => value == null ? validatorMessage : null,
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
    );
  }
}
