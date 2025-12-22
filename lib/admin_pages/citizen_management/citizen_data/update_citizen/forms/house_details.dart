import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HouseDetails extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool validateOnSubmit;
  final VoidCallback clearValidation;

  const HouseDetails({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.validateOnSubmit,
    required this.clearValidation,
  });

  @override
  State<HouseDetails> createState() => _HouseDetailsPageState();
}

class _HouseDetailsPageState extends State<HouseDetails> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedHousetype;
  String? _selectedWalltype;
  String? _selectedFloortype;
  String? _selectedCeilingtype;
  String? _selectedwatersourcetype;
  String? _selectedWashroomtype;
  String? _selectedPowersourcetype;
  String? _selectedCookingsourcetype;
  final TextEditingController _houseDescriptionController = TextEditingController();

  // Dropdown options
  final List<String> houseTypes = ['Single floor', '2 floors', 'More than 2 floors', 'Sub house', 'Other'];
  final List<String> wallTypes = ['Brick', 'Cement block', 'Metal stone', 'Stone', 'Other'];
  final List<String> floorTypes = ['Cement', 'Tile', 'Clay', 'Sand', 'Other'];
  final List<String> ceilingTypes = ['Tiles', 'Concrete', 'Tin', 'Straw', 'Other'];
  final List<String> waterSourceTypes = ['Safe well', 'Protected well', 'Tubewell', 'Tap water', 'Other'];
  final List<String> washroomTypes = ['Water Seal', 'Pit toilet', 'Public toilet', 'No toilet', 'Other'];
  final List<String> powerSourceTypes = ['Electricity', 'Solar power', 'Kerosene', 'Other'];
  final List<String> cookingSourceTypes = ['Firewood', 'Gas', 'Electric', 'Other'];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      String? houseType = prefs.getString('houseType');
      _selectedHousetype = houseTypes.contains(houseType) ? houseType : null;

      String? wallType = prefs.getString('wallType');
      _selectedWalltype = wallTypes.contains(wallType) ? wallType : null;

      String? floorType = prefs.getString('floorType');
      _selectedFloortype = floorTypes.contains(floorType) ? floorType : null;

      String? ceilingType = prefs.getString('ceilingType');
      _selectedCeilingtype = ceilingTypes.contains(ceilingType) ? ceilingType : null;

      String? waterSourceType = prefs.getString('waterSourceType');
      _selectedwatersourcetype = waterSourceTypes.contains(waterSourceType) ? waterSourceType : null;

      String? washroomType = prefs.getString('washroomType');
      _selectedWashroomtype = washroomTypes.contains(washroomType) ? washroomType : null;

      String? powerSourceType = prefs.getString('powerSourceType');
      _selectedPowersourcetype = powerSourceTypes.contains(powerSourceType) ? powerSourceType : null;

      String? cookingSourceType = prefs.getString('cookingSourceType');
      _selectedCookingsourcetype = cookingSourceTypes.contains(cookingSourceType) ? cookingSourceType : null;

      _houseDescriptionController.text = prefs.getString('houseDescription') ?? '';
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_selectedHousetype != null) {
      prefs.setString('houseType', _selectedHousetype!);
    }
    if (_selectedWalltype != null) {
      prefs.setString('wallType', _selectedWalltype!);
    }
    if (_selectedFloortype != null) {
      prefs.setString('floorType', _selectedFloortype!);
    }
    if (_selectedCeilingtype != null) {
      prefs.setString('ceilingType', _selectedCeilingtype!);
    }
    if (_selectedwatersourcetype != null) {
      prefs.setString('waterSourceType', _selectedwatersourcetype!);
    }
    if (_selectedWashroomtype != null) {
      prefs.setString('washroomType', _selectedWashroomtype!);
    }
    if (_selectedPowersourcetype != null) {
      prefs.setString('powerSourceType', _selectedPowersourcetype!);
    }
    if (_selectedCookingsourcetype != null) {
      prefs.setString('cookingSourceType', _selectedCookingsourcetype!);
    }
    prefs.setString('houseDescription', _houseDescriptionController.text);
  }

  @override
  void dispose() {
    _houseDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'House Details',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Divider(color: Colors.black,thickness: 1.2),
                  const SizedBox(height: 10),
                  _buildDropdownField(
                    "House Type",
                    _selectedHousetype,
                    houseTypes,
                    (value) {
                      setState(() => _selectedHousetype = value);
                      _saveData();
                      widget.clearValidation();
                    },
                    widget.validateOnSubmit && (_selectedHousetype == null),
                  ),
                  const SizedBox(height: 10),
                  _buildDropdownField(
                    "Wall Type",
                    _selectedWalltype,
                    wallTypes,
                    (value) {
                      setState(() => _selectedWalltype = value);
                      _saveData();
                      widget.clearValidation();
                    },
                    widget.validateOnSubmit && _selectedWalltype == null,
                  ),
                  const SizedBox(height: 10),
                  _buildDropdownField(
                    "Floor Type",
                    _selectedFloortype,
                    floorTypes,
                    (value) {
                      setState(() => _selectedFloortype = value);
                      _saveData();
                      widget.clearValidation();
                    },
                    widget.validateOnSubmit && (_selectedFloortype == null),
                  ),
                  const SizedBox(height: 10),
                  _buildDropdownField(
                    "Ceiling Type",
                    _selectedCeilingtype,
                    ceilingTypes,
                    (value) {
                      setState(() => _selectedCeilingtype = value);
                      _saveData();
                      widget.clearValidation();
                    },
                    widget.validateOnSubmit && (_selectedCeilingtype == null),
                  ),
                  const SizedBox(height: 10),
                  _buildDropdownField(
                    "Water Source Type",
                    _selectedwatersourcetype,
                    waterSourceTypes,
                    (value) {
                      setState(() => _selectedwatersourcetype = value);
                      _saveData();
                      widget.clearValidation();
                    },
                    widget.validateOnSubmit && (_selectedwatersourcetype == null),
                  ),
                  const SizedBox(height: 10),
                  _buildDropdownField(
                    "Washroom Type",
                    _selectedWashroomtype,
                    washroomTypes,
                    (value) {
                      setState(() => _selectedWashroomtype = value);
                      _saveData();
                      widget.clearValidation();
                    },
                    widget.validateOnSubmit && (_selectedWashroomtype == null),
                  ),
                  const SizedBox(height: 10),
                  _buildDropdownField(
                    "Power Source Type",
                    _selectedPowersourcetype,
                    powerSourceTypes,
                    (value) {
                      setState(() => _selectedPowersourcetype = value);
                      _saveData();
                      widget.clearValidation();
                    },
                    widget.validateOnSubmit && (_selectedPowersourcetype == null),
                  ),
                  const SizedBox(height: 10),
                  _buildDropdownField(
                    "Cooking Source Type",
                    _selectedCookingsourcetype,
                    cookingSourceTypes,
                    (value) {
                      setState(() => _selectedCookingsourcetype = value);
                      _saveData();
                      widget.clearValidation();
                    },
                    widget.validateOnSubmit && (_selectedCookingsourcetype == null),
                  ),
                  const SizedBox(height: 10),
                  _buildFormField(
                    "House Description",
                    _houseDescriptionController,
                    widget.validateOnSubmit && _houseDescriptionController.text.isEmpty,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(
      String label, TextEditingController controller, bool showError) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        errorText: showError ? 'This field is required' : null,
      ),
      onChanged: (value) {
        _saveData();
        widget.clearValidation();
      },
    );
  }

  Widget _buildDropdownField(
    String label,
    String? selectedValue,
    List<String> items,
    Function(String?) onChanged,
    bool showError,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        errorText: showError ? 'Please select an option' : null,
      ),
      value: items.contains(selectedValue) ? selectedValue : null,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }
}