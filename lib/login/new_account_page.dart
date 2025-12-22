import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../component/request_service/action_button.dart';
import '../component/request_service/date_picker_field.dart'; // Import your custom DatePickerField

class NewAccountPage extends StatefulWidget {
  const NewAccountPage({super.key});

  @override
  NewAccountPageState createState() => NewAccountPageState();
}

class NewAccountPageState extends State<NewAccountPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  DateTime? _selectedDate;

  void _nextPage() {
    if (_currentPage == 0) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage == 1) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: AppBar(
        backgroundColor: const Color(0xFF80AF81),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: const BoxDecoration(color: Color(0xFF80AF81)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "create_accountn".tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "step_by_step".tr(),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2,
                    (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? const Color(0xFF1A5319)
                        : Colors.grey[400],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildCitizenForm(),
                  _buildHouseholdForm(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCitizenForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("citizen_info".tr(), style: _sectionTitleStyle),
          const SizedBox(height: 15),
          _buildDropdown("family_relation".tr(), [
            "house_holder".tr(),
            "husband".tr(),
            "wife".tr()
          ]),
          _buildTextField("name".tr()),
          _buildTextField("friendly_name".tr()),
          _buildTextField("address".tr()),
          _buildTextField("mobile_number".tr()),
          _buildTextField("nic".tr()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: DatePickerField(
              label: "dob".tr(),
              selectedDate: _selectedDate,
              onDateSelected: (DateTime selected) {
                setState(() {
                  _selectedDate = selected;
                });
              },
            ),
          ),
          _buildStyledDropdown("gender".tr(), [
            "male".tr(),
            "female".tr(),
          ]),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ActionButton(
              text: "next".tr(),
              icon: Icons.arrow_forward,
              onPressed: _nextPage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHouseholdForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("household_info".tr(), style: _sectionTitleStyle),
          const SizedBox(height: 15),
          _buildStyledDropdown("ds_division".tr(), [
            "thamankaduwa".tr(),
            "welikanda".tr()
          ]),
          _buildTextField("village".tr()),
          _buildTextField("house_number".tr()),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ActionButton(
                  text: "back".tr(),
                  icon: Icons.arrow_back,
                  onPressed: _previousPage,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActionButton(
                  text: "signup".tr(),
                  onPressed: () {
                    // Submit logic
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _fieldLabelStyle),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items.map((item) {
          return DropdownMenuItem(value: item, child: Text(item));
        }).toList(),
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildStyledDropdown(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _fieldLabelStyle),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Text("select_option".tr(), style: const TextStyle(color: Colors.grey)),
                items: items.map((item) {
                  return DropdownMenuItem(value: item, child: Text(item));
                }).toList(),
                onChanged: (value) {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const _sectionTitleStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Color(0xFF0C3B2E),
);

const _fieldLabelStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);
