import 'package:citizen_care_system/admin_pages/projects_planning_pages/project_request_pages/gnoffice.dart';
import 'package:citizen_care_system/admin_pages/projects_planning_pages/project_request_pages/multiple_dropdown_selector.dart';
import 'package:citizen_care_system/admin_pages/projects_planning_pages/project_request_pages/services/gnoffice_service.dart';
import 'package:citizen_care_system/admin_pages/projects_planning_pages/project_request_pages/location.dart';
import 'package:citizen_care_system/admin_pages/projects_planning_pages/project_request_pages/services/location_service.dart';
import 'package:citizen_care_system/admin_pages/projects_planning_pages/project_request_pages/sector.dart';
import 'package:citizen_care_system/admin_pages/projects_planning_pages/project_request_pages/sdggoals.dart';
import 'package:citizen_care_system/admin_pages/projects_planning_pages/project_request_pages/services/project_delete_service.dart';
import 'package:citizen_care_system/admin_pages/projects_planning_pages/project_request_pages/services/sdggoal_service.dart';
import 'package:citizen_care_system/admin_pages/projects_planning_pages/project_request_pages/services/sector_service.dart';
import 'package:citizen_care_system/admin_pages/projects_planning_pages/project_request_pages/services/project_service.dart'; // Add this import
import 'package:citizen_care_system/admin%20_component/citizen_service_task/action_button.dart';
import 'package:citizen_care_system/admin%20_component/project_planning/checkbox_dropdown_selector.dart';
import 'package:citizen_care_system/admin%20_component/project_planning/text_input_field.dart';
import 'package:citizen_care_system/admin_pages/projects_planning_pages/project_request_pages/single_dropdown_selector.dart';
import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_back_button.dart';
import 'package:flutter/material.dart';

class AddNewProjectPage extends StatefulWidget {
  final String accessToken;

  final String username; // Add username parameter
  final String callingName; // Add calling name parameter

  const AddNewProjectPage({
    super.key,
    required this.accessToken,
    required this.username,
    this.callingName = 'Sandun', // Make it required
  });

  @override
  State<AddNewProjectPage> createState() => _AddNewProjectPageState();
}

class _AddNewProjectPageState extends State<AddNewProjectPage> {
  List<Sector> sectors = [];
  Sector? selectedSector;
  List<String> selectedSectors = [];
  bool isLoadingSectors = false;

  List<Location> locations = [];
  Location? selectedLocation;
  List<String> selectedLocations = [];
  bool isLoadingLocations = false;

  List<Gnoffice> gnoffices = [];
  Gnoffice? selectedGnoffice;
  List<String> selectedGnoffices = [];
  bool isLoadingGnoffices = false;

  List<Sdggoal> sdgGoals = [];
  List<String> selectedsdgGoals = [];
  bool isLoadingsdgGoals = false;

  List<String> selectedRelatedOffices = [];
  List<String> selectedGNOffices = [];
  List<String> selectedProjectTypes = [];
  List<String> selectedPriorities = [];

  bool isSubmitting = false; // Add loading state for submission

  // Text controllers
  final TextEditingController _projectTitleController = TextEditingController();
  final TextEditingController _estimatedCostController =
      TextEditingController();
  final TextEditingController _expectedOutputController =
      TextEditingController();
  final TextEditingController _planDescriptionController =
      TextEditingController(); // Add this controller

  final List<String> relatedOffices = [];

  final List<String> projectTypes = [
    'Construction',
    'Purchasing',
  ];

  final List<String> priorities = [
    'Must Required',
    'Required',
    'Not Urgent',
    'Not Required',
  ];

  @override
  void initState() {
    super.initState();
    _loadSectors();
    _loadlocations();
    _loadSdggoals();
  }

  @override
  void dispose() {
    _projectTitleController.dispose();
    _estimatedCostController.dispose();
    _expectedOutputController.dispose();
    _planDescriptionController.dispose(); // Dispose the new controller
    super.dispose();
  }

  Future<void> _loadSectors() async {
    setState(() => isLoadingSectors = true);
    try {
      final sectorList = await SectorService.getSectors(widget.accessToken);
      setState(() {
        sectors = sectorList;
        isLoadingSectors = false;
      });
    } catch (e) {
      _showValidationError(e.toString());
      setState(() => isLoadingSectors = false);
    }
  }

  Future<void> _loadlocations() async {
    setState(() => isLoadingLocations = true);
    try {
      final locationList =
          await LocationService.getLocations(widget.accessToken);
      setState(() {
        locations = locationList;
        isLoadingLocations = false;
      });
    } catch (e) {
      _showValidationError(e.toString());
      setState(() => isLoadingLocations = false);
    }
  }

  Future<void> _loadGnOffices(String divisionId) async {
    setState(() => isLoadingGnoffices = true);
    try {
      final GnofficeList =
          await GnofficeService.getGnOffices(widget.accessToken, divisionId);
      setState(() {
        gnoffices = GnofficeList;
        isLoadingGnoffices = false;
      });
    } catch (e) {
      _showValidationError(e.toString());
      setState(() => isLoadingGnoffices = false);
    }
  }

  Future<void> _loadSdggoals() async {
    setState(() => isLoadingsdgGoals = true);
    try {
      final sdggoalsList = await SdggoalService.getSdggoals(widget.accessToken);
      setState(() {
        sdgGoals = sdggoalsList;
        isLoadingsdgGoals = false;
      });
    } catch (e) {
      _showValidationError(e.toString());
      setState(() => isLoadingsdgGoals = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(
        leading: CustomBackButton(),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Add New Project',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Project Title
              TextInputField(
                controller: _projectTitleController,
                label: 'Project Title',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),

              // Sector Selection
              const Center(
                child: Text(
                  'Select Sector',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              isLoadingSectors
                  ? const Center(child: CircularProgressIndicator())
                  : SingleDropdownSelector<Sector>(
                      title: 'Sectors',
                      options: sectors,
                      selectedItem: selectedSector,
                      getDisplayText: (sector) => sector.name,
                      getId: (sector) => sector.id,
                      onSelectionChanged: (String? sectorId) {
                        setState(() {
                          selectedSectors = sectorId != null ? [sectorId] : [];
                          selectedSector = sectorId != null
                              ? sectors
                                  .firstWhere((sector) => sector.id == sectorId)
                              : null;
                        });
                      },
                    ),
              const SizedBox(height: 16),

              // Location Selection
              const Center(
                child: Text(
                  'Select Location(s)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              isLoadingLocations
                  ? const Center(child: CircularProgressIndicator())
                  : SingleDropdownSelector<Location>(
                      title: 'Locations',
                      options: locations,
                      selectedItem: selectedLocation,
                      getDisplayText: (location) => location.name,
                      getId: (location) => location.id,
                      onSelectionChanged: (String? locationId) {
                        setState(() {
                          selectedLocations =
                              locationId != null ? [locationId] : [];
                          selectedLocation = locationId != null
                              ? locations.firstWhere(
                                  (location) => location.id == locationId)
                              : null;
                          selectedGnoffice = null;
                          selectedGNOffices = [];
                          isLoadingGnoffices = false;
                        });
                        if (locationId != null) {
                          _loadGnOffices(locationId);
                        } else {
                          setState(() {
                            gnoffices = [];
                            isLoadingGnoffices = false;
                          });
                        }
                      },
                    ),
              const SizedBox(height: 16),

              // GN Office Selection
              const Center(
                child: Text(
                  'Select GN Office(s)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              isLoadingGnoffices
                  ? const Center(child: CircularProgressIndicator())
                  : SingleDropdownSelector<Gnoffice>(
                      title: 'Gn Offices',
                      options: gnoffices,
                      selectedItem: selectedGnoffice,
                      getDisplayText: (gnoffice) => gnoffice.name,
                      getId: (gnoffice) => gnoffice.id,
                      onSelectionChanged: (String? gnOfficeId) {
                        setState(() {
                          selectedGnoffices =
                              gnOfficeId != null ? [gnOfficeId] : [];
                          selectedGnoffice = gnOfficeId != null
                              ? gnoffices.firstWhere(
                                  (gnoffice) => gnoffice.id == gnOfficeId)
                              : null;
                        });
                      },
                    ),
              const SizedBox(height: 16),

              // Project Type Selection
              const Center(
                child: Text(
                  'Select Project Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              CheckboxDropdownSelector(
                title: 'Project Types',
                options: projectTypes,
                selectedItems: selectedProjectTypes,
                onSelectionChanged: (newSelection) {
                  setState(() {
                    selectedProjectTypes = newSelection;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Estimated Cost
              TextInputField(
                controller: _estimatedCostController,
                label: 'Estimated Cost',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Expected Output
              TextInputField(
                controller: _expectedOutputController,
                label: 'Expected Output',
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Add Plan Description field
              TextInputField(
                controller: _planDescriptionController,
                label: 'Plan Description',
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Priority Selection
              const Center(
                child: Text(
                  'Select Priority',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              CheckboxDropdownSelector(
                title: 'Priority',
                options: priorities,
                selectedItems: selectedPriorities,
                onSelectionChanged: (newSelection) {
                  setState(() {
                    selectedPriorities = newSelection;
                  });
                },
              ),
              const SizedBox(height: 16),

              // SDG Goals Selection
              const Center(
                child: Text(
                  'Select Related SDG Goal(s)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              isLoadingsdgGoals
                  ? const Center(child: CircularProgressIndicator())
                  : MultipleDropdownSelector<Sdggoal>(
                      title: 'SDG goals',
                      options: sdgGoals,
                      selectedItems: selectedsdgGoals
                          .map((id) => sdgGoals
                              .firstWhere((sdggoal) => sdggoal.id == id))
                          .toList(),
                      getDisplayText: (sdggoal) => sdggoal.name,
                      getId: (sdggoal) => sdggoal.id,
                      maxDisplayItems: 2,
                      selectAllText: 'Select All Goals',
                      onSelectionChanged: (List<String?>? selectedIds) {
                        setState(() {
                          selectedsdgGoals = selectedIds?.cast<String>() ?? [];
                        });
                      },
                    ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ActionButton(
                      text: 'Cancel',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: isSubmitting
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : ActionButton(
                            text: 'Submit',
                            onPressed: _validateAndSubmit,
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _validateAndSubmit() async {
    // Validation
    if (_projectTitleController.text.isEmpty) {
      _showValidationError('Please enter a project title.');
      return;
    }
    if (selectedSectors.isEmpty) {
      _showValidationError('Please select a sector.');
      return;
    }
    if (selectedLocations.isEmpty) {
      _showValidationError('Please select at least one location.');
      return;
    }
    if (selectedGnoffices.isEmpty) {
      _showValidationError('Please select at least one GN office.');
      return;
    }
    if (selectedProjectTypes.isEmpty) {
      _showValidationError('Please select at least one project type.');
      return;
    }
    if (_estimatedCostController.text.isEmpty) {
      _showValidationError('Please enter estimated cost.');
      return;
    }
    if (_expectedOutputController.text.isEmpty) {
      _showValidationError('Please enter expected output.');
      return;
    }
    if (_planDescriptionController.text.isEmpty) {
      _showValidationError('Please enter plan description.');
      return;
    }
    if (selectedPriorities.isEmpty) {
      _showValidationError('Please select a priority level.');
      return;
    }
    if (selectedsdgGoals.isEmpty) {
      _showValidationError('Please select at least one SDG goal.');
      return;
    }

    // Start submission
    setState(() {
      isSubmitting = true;
    });

    try {
      final response = await ProjectService.submitProject(
        accessToken: widget.accessToken,
        dsLocationId: selectedLocations.first,
        gnLocationId: selectedGnoffices.first,
        sectorLocationId: selectedSectors.first,
        projectType: selectedProjectTypes.first,
        planPriority: selectedPriorities.first,
        projectTitle: _projectTitleController.text.trim(),
        estimatedCost: _estimatedCostController.text.trim(),
        estimatedOutput: _expectedOutputController.text.trim(),
        planDescription: _planDescriptionController.text.trim(),
        username: widget.username,
        callingName: widget.callingName,
        sgdGoalList: selectedsdgGoals,
      );

      if (response['isSuccess'] == true) {
        _showSuccessMessage('Project added successfully!');

        // Navigate back after successful submission
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      } else {
        _showValidationError(response['errorMessage'] ??
            'Failed to submit project. Please try again.');
      }
    } catch (e) {
      _showValidationError('Error submitting project: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
