import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../component/custom_back_button.dart';
import '../../component/custom_app_bar.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State <AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _itemList = [
    "Paper",
    "Books",
    "Pens and Pencils",
    "Computer Ribbons",
    "Electrical Items",
    "Cleaning Materials"
  ];
  String? _selectedItem;
  final TextEditingController _goodNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FocusNode _descriptionFocusNode = FocusNode();
  bool _isDescriptionFocused = false;

  @override
  void initState() {
    super.initState();
    _descriptionFocusNode.addListener(() {
      setState(() {
        _isDescriptionFocused = _descriptionFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _goodNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  int _letterCount(String text) {
    return text.replaceAll(RegExp(r'\s+'), '').length;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(
        leading: CustomBackButton(),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.89,
          ),
          child: Container(
            margin: EdgeInsets.all(screenWidth * 0.03),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.02,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Add New Good",
                      style: GoogleFonts.inter(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.black38,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.01,
                      left: screenWidth * 0.02,
                      bottom: screenHeight * 0.01,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Item Category",
                          style: GoogleFonts.inter(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.05),
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedItem,
                                  hint: Text(
                                    "Select a category",
                                    style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 5, 52, 90),
                                      fontSize: screenWidth * 0.035,
                                    ),
                                  ),
                                  items: _itemList
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() => _selectedItem = value);
                                  },
                                  validator: (value) => value == null
                                      ? "Please Select a category"
                                      : null,
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 52, 90),
                                    fontSize: screenWidth * 0.04,
                                  ),
                                  decoration: const InputDecoration(
                                      border: InputBorder.none),
                                  dropdownColor: Colors.white,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Color.fromARGB(255, 5, 52, 90),
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.04),
                              IconButton(
                                icon:
                                    const Icon(Icons.add, color: Colors.green),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          "Add New Category",
                                          style: GoogleFonts.inter(
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: TextField(
                                          decoration: InputDecoration(
                                            hintText: "Enter category name",
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: screenWidth * 0.035,
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text(
                                              "Cancel",
                                              style: GoogleFonts.inter(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              "Add",
                                              style: GoogleFonts.inter(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            onPressed: () {
                                              // Handle add logic
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Text(
                          "Good Name",
                          style: GoogleFonts.inter(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        TextFormField(
                          controller: _goodNameController,
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Good name is required'
                                  : null,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.01,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.05),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.05),
                              borderSide: const BorderSide(
                                color: Colors.green,
                                width: 2.0,
                              ),
                            ),
                            hintText: "Enter good name",
                            hintStyle: TextStyle(
                              color: const Color.fromARGB(255, 5, 52, 90),
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Text(
                          "Description",
                          style: GoogleFonts.inter(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        TextFormField(
                          focusNode: _descriptionFocusNode,
                          maxLines: 6,
                          controller: _descriptionController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Description is required';
                            }
                            if (_letterCount(value) > 200) {
                              return 'Description must be 200 letters or less';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            final letterCount = _letterCount(value);
                            if (letterCount > 200) {
                              int count = 0;
                              String trimmed = '';
                              for (int i = 0; i < value.length; i++) {
                                if (value[i].trim().isNotEmpty) {
                                  count++;
                                }
                                trimmed += value[i];
                                if (count >= 200) break;
                              }
                              setState(() {
                                _descriptionController.text = trimmed;
                                _descriptionController.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(offset: trimmed.length),
                                );
                              });
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Enter description",
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.all(screenWidth * 0.04),
                            hintStyle: TextStyle(
                              color: const Color.fromARGB(255, 5, 52, 90),
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w400,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.05),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.05),
                              borderSide: BorderSide(
                                  color: _isDescriptionFocused
                                      ? Colors.green
                                      : Colors.black,
                                  width: 2),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * 0.04,
                          ),
                          child: Text(
                            "${_letterCount(_descriptionController.text)} / 200 letters",
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromARGB(255, 5, 52, 90),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3A7D44),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.01,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.05),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Item submitted successfully!")),
                          );
                        }
                      },
                      child: Text(
                        "Submit",
                        style: GoogleFonts.inter(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
