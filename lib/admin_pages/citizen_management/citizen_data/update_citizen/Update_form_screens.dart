// form_screens.dart

import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/update_citizen/forms/agrarian.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/update_citizen/forms/citizen_information.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/update_citizen/forms/disaster_details.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/update_citizen/forms/education_information.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/update_citizen/forms/health_status.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/update_citizen/forms/house_details.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/update_citizen/forms/household_information.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/update_citizen/forms/livestock_details.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/update_citizen/forms/property_information.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/update_citizen/forms/source_of_income.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/update_citizen/forms/subsidies.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/update_citizen/forms/vechicle_information.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Update_form_navigation.dart';

class UpdateFormScreens extends StatefulWidget {
  const UpdateFormScreens({super.key});

  @override
  State<UpdateFormScreens> createState() => _UpdateFormScreensState();
}

class _UpdateFormScreensState extends State<UpdateFormScreens> {
  int _currentFormIndex = 0;
  bool _attemptedSubmit = false;

  void _navigateToNext() {
    setState(() {
      _currentFormIndex++;
    });
  }

  void _navigateToPrevious() {
    setState(() {
      if (_currentFormIndex > 0) _currentFormIndex--;
    });
  }

  void _resetValidation() {
    if (_attemptedSubmit) {
      setState(() {
        _attemptedSubmit = false;
      });
    }
  }

  // validation for CitizenInformationForm
  Future<bool> _isCitizenInformationFormValid() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');
    final address = prefs.getString('address');
    final mobileNumber = prefs.getString('mobileNumber');
    final nic = prefs.getString('nic');
    final familyRelation = prefs.getString('familyRelation');
    final gender = prefs.getString('gender');
    final maritalStatus = prefs.getString('maritalStatus');
    final nationality = prefs.getString('nationality');
    final religion = prefs.getString('religion');
    final bloodGroup = prefs.getString('bloodGroup');
    final dateOfBirth = prefs.getString('dateOfBirth');

    return name != null &&
        name.isNotEmpty &&
        address != null &&
        address.isNotEmpty &&
        mobileNumber != null &&
        mobileNumber.isNotEmpty &&
        nic != null &&
        nic.isNotEmpty &&
        familyRelation != null &&
        familyRelation.isNotEmpty &&
        gender != null &&
        gender.isNotEmpty &&
        maritalStatus != null &&
        maritalStatus.isNotEmpty &&
        nationality != null &&
        nationality.isNotEmpty &&
        religion != null &&
        religion.isNotEmpty &&
        bloodGroup != null &&
        bloodGroup.isNotEmpty &&
        dateOfBirth != null &&
        dateOfBirth.isNotEmpty;
  }

// validation for HouseholdInformationForm 
Future<bool> _isHouseholdInformationValid() async {
    final prefs = await SharedPreferences.getInstance();
    final DivisionalSecretariatDivision = prefs.getString('DivisionalSecretariatDivision');
    final GramaNiladariDivision= prefs.getString('GramaNiladariDivision');
    final Village = prefs.getString('Village');
    final HouseNumber = prefs.getString('HouseNumber');

    return DivisionalSecretariatDivision != null &&
        DivisionalSecretariatDivision.isNotEmpty &&
        GramaNiladariDivision != null &&
        GramaNiladariDivision.isNotEmpty &&
        Village != null &&
        Village.isNotEmpty &&
        HouseNumber  != null &&
        HouseNumber.isNotEmpty;
  }

// validation for EducationInformationForm  
Future<bool> _isEducationInformationValid() async {
    final prefs = await SharedPreferences.getInstance();
    final EducationLevel = prefs.getString('EducationLevel');
    final Institution = prefs.getString('Institution');
    final EducatedYear = prefs.getString('EducatedYear');
    final QualificationType = prefs.getString('QualificationType');
    final EducationDescription= prefs.getString('EducationDescription');

    return EducationLevel != null &&
        EducationLevel.isNotEmpty &&
        Institution != null &&
        Institution.isNotEmpty &&
        EducatedYear != null &&
        EducatedYear.isNotEmpty &&
        QualificationType  != null &&
        QualificationType.isNotEmpty &&
        EducationDescription  != null &&
        EducationDescription.isNotEmpty;
  }

// validation for SourceOfIncomeForm
  Future<bool> _isSourceOfIncomeFormValid() async {
    final prefs = await SharedPreferences.getInstance();
    final incomeType = prefs.getString('incomeType');
    final designation = prefs.getString('designation');
    final jobLocation = prefs.getString('jobLocation');
    final jobField = prefs.getString('jobField');
    final averageIncome = prefs.getString('averageIncome');
    final incomeDescription = prefs.getString('incomeDescription');

    return incomeType != null &&
        incomeType.isNotEmpty &&
        designation != null &&
        designation.isNotEmpty &&
        jobLocation != null &&
        jobLocation.isNotEmpty &&
        jobField != null &&
        jobField.isNotEmpty &&
        averageIncome != null &&
        averageIncome.isNotEmpty &&
        incomeDescription != null &&
        incomeDescription.isNotEmpty;
  }

  // validation for HealthStatusForm
  Future<bool> _isHealthStatusValid() async {
    final prefs = await SharedPreferences.getInstance();
    final IllnessType = prefs.getString('IllnessType');
    final IllnessName = prefs.getString('IllnessName');
    final HospitalName = prefs.getString('HospitalName');
    final IllnessDescription = prefs.getString('IllnessDescription');

    return IllnessType != null &&
        IllnessType.isNotEmpty &&
        IllnessName != null &&
        IllnessName.isNotEmpty &&
        HospitalName != null &&
        HospitalName.isNotEmpty &&
        IllnessDescription != null &&
        IllnessDescription.isNotEmpty;
  }

  // validation for SubsidiesForm
  Future<bool> _isSubsidiesFormValid() async {
    final prefs = await SharedPreferences.getInstance();
    final subsidieType = prefs.getString('subsidieType');
    final subsidieAmount = prefs.getString('subsidieAmount');
    final subsidieReference = prefs.getString('subsidieReference');
    final subsidieDescription = prefs.getString('subsidieDescription');

    return subsidieType != null &&
        subsidieAmount != null &&
        subsidieAmount.isNotEmpty &&
        subsidieReference != null &&
        subsidieReference.isNotEmpty &&
        subsidieDescription != null &&
        subsidieDescription.isNotEmpty;
  }

  // validation for PropertyInformationForm
  Future<bool> _isPropertyInformationValid() async {
    final prefs = await SharedPreferences.getInstance();
    final PropertyType = prefs.getString('PropertyType');
    final PropertySize = prefs.getString('PropertySize');
    final RegistrationNumber = prefs.getString('RegistrationNumber');
    final PropertyDescription = prefs.getString('PropertyDescription');

    return PropertyType != null &&
        PropertyType.isNotEmpty &&
        PropertySize != null &&
        PropertySize.isNotEmpty &&
        RegistrationNumber != null &&
        RegistrationNumber.isNotEmpty &&
        PropertyDescription != null &&
        PropertyDescription.isNotEmpty;
  }

// validation for AgrarianForm
  Future<bool> _isAgrarianValid() async {
    final prefs = await SharedPreferences.getInstance();
    final AgrarianDivision = prefs.getString('AgrarianDivision');
    final AgrarianOrganization = prefs.getString('AgrarianOrganization');
    final AgrarianName = prefs.getString(' AgrarianName');
    final PaddyRegistrationNumber = prefs.getString('PaddyRegistrationNumber');
    final AgrarianDescription  = prefs.getString('AgrarianDescription');

    return AgrarianDivision != null &&
        AgrarianDivision.isNotEmpty &&
        AgrarianOrganization != null &&
        AgrarianOrganization.isNotEmpty &&
        AgrarianName != null &&
        AgrarianName.isNotEmpty &&
        PaddyRegistrationNumber != null &&
        PaddyRegistrationNumber.isNotEmpty &&
        AgrarianDescription != null &&
        AgrarianDescription .isNotEmpty;
  }

// validation for HouseDetailsForm
  Future<bool> _isHouseDetailsValid() async {
    final prefs = await SharedPreferences.getInstance();
    final HouseType = prefs.getString('HouseType');
    final WallType = prefs.getString('WallType');
    final FloorType = prefs.getString('FloorType');
    final CeilingType = prefs.getString('CeilingType');
    final WaterSourceType  = prefs.getString('WaterSourceType');
    final WashroomType  = prefs.getString('WashroomType');
    final PowerSourceType  = prefs.getString('PowerSourceType');
    final CookingSourceType  = prefs.getString('CookingSourceType');
    final HouseDescription  = prefs.getString('HouseDescription');
    
    return HouseType != null &&
        HouseType.isNotEmpty &&
        WallType != null &&
        WallType.isNotEmpty &&
        FloorType != null &&
        FloorType.isNotEmpty &&
        CeilingType != null &&
        CeilingType.isNotEmpty &&
        WaterSourceType != null &&
        WaterSourceType.isNotEmpty &&
        WashroomType != null &&
        WashroomType.isNotEmpty &&
        PowerSourceType  != null &&
        PowerSourceType .isNotEmpty &&
        CookingSourceType != null &&
        CookingSourceType.isNotEmpty &&
        HouseDescription != null &&
        HouseDescription .isNotEmpty;
  }
  
// validation for LivestockDetailsForm
  Future<bool> _isLivestockDetailsValid() async {
    final prefs = await SharedPreferences.getInstance();
    final AnimalType = prefs.getString('AnimalType');
    final ProductionCategory = prefs.getString('ProductionCategory');
    final ProductionAmount = prefs.getString('ProductionAmount');
    final AnimalCount = prefs.getString('AnimalCount');
    final LivestockDescription  = prefs.getString('LivestockDescription');

    return AnimalType != null &&
        AnimalType.isNotEmpty &&
        ProductionCategory != null &&
        ProductionCategory.isNotEmpty &&
        ProductionAmount != null &&
        ProductionAmount.isNotEmpty &&
        AnimalCount != null &&
        AnimalCount.isNotEmpty &&
        LivestockDescription != null &&
        LivestockDescription .isNotEmpty;
  }

  // validation for VehicleInformationForm
  Future<bool> _isVehicleFormValid() async {
    final prefs = await SharedPreferences.getInstance();
    final vehicleType = prefs.getString('vehicleType');
    final vehicleNumber = prefs.getString('vehicleNumber');
    final vehicleDescription = prefs.getString('vehicleDescription');

    return vehicleType != null &&
        vehicleType.isNotEmpty &&
        vehicleNumber != null &&
        vehicleNumber.isNotEmpty &&
        vehicleDescription != null &&
        vehicleDescription.isNotEmpty;
  }

  // validation for DisasterDetailsForm
  Future<bool> _isDisasterDetailsFormValid() async {
    final prefs = await SharedPreferences.getInstance();
    final disasterType = prefs.getString('disasterType');
    final disasterDescription = prefs.getString('disasterDescription');
    return disasterType != null &&
        disasterType.isNotEmpty &&
        disasterDescription != null &&
        disasterDescription.isNotEmpty;
  }

  // validation for all forms
  // Submit all forms
  Future<void> _submitForms() async {
    setState(() {
      _attemptedSubmit = true;
    });

    final isCitizenInformationFormValid = 
        await _isCitizenInformationFormValid();
    final isHouseholdInformationValid= await _isHouseholdInformationValid();
    final isEducationInformationValid = await _isEducationInformationValid();
    final isSourceOfIncomeFormValid = await _isSourceOfIncomeFormValid();
    final isHealthStatusValid= await _isHealthStatusValid();
    final isSubSidesFormValid = await _isSubsidiesFormValid();
    final isPropertyInformationValid = await _isPropertyInformationValid();
    final isAgrarianValid = await _isAgrarianValid();
    final isHouseDetailsValid = await _isHouseDetailsValid();
    final isLivestockDetailsValid = await _isLivestockDetailsValid();
    final isVehicleFormValid = await _isVehicleFormValid();
    final isDisasterDetailsFormValid = await _isDisasterDetailsFormValid();

    if (isCitizenInformationFormValid &&
        isHouseholdInformationValid &&
        isEducationInformationValid &&
        isSourceOfIncomeFormValid &&
        isHealthStatusValid &&
        isSubSidesFormValid &&
        isPropertyInformationValid &&
        isAgrarianValid &&
        isHouseDetailsValid &&
        isLivestockDetailsValid &&
        isVehicleFormValid &&
        isDisasterDetailsFormValid) {
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Forms submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      // Reset to first form
      if (mounted) {
        setState(() {
          _currentFormIndex = 0;
          _attemptedSubmit = false;
        });
      }
    } else {
      String errorMessage;
      if (!isCitizenInformationFormValid) {
        errorMessage =
            'Please fill all fields in Citizen Information form correctly.';
        setState(() {
          _currentFormIndex = 0;
        });
        } else if (!isHouseholdInformationValid) {
        errorMessage =
            'Please fill all fields in Household form correctly.';
        setState(() {
          _currentFormIndex = 1;
        });  
      } else if (!isEducationInformationValid) {
        errorMessage =
            'Please fill all fields in Education Education form correctly.';
        setState(() {
          _currentFormIndex = 2;
        });  
      } else if (!isSourceOfIncomeFormValid) {
        errorMessage =
            'Please fill all fields in Source of Income form correctly.';
        setState(() {
          _currentFormIndex = 3;
        });
        
      } else if (!isHealthStatusValid) {
        errorMessage =
            'Please fill all fields in is Health Status form correctly.';
        setState(() {
          _currentFormIndex = 4;
        });
      } else if (!isSubSidesFormValid) {
        errorMessage = 'Please fill all fields in Subsidies form correctly.';
        setState(() {
          _currentFormIndex = 5;
        });
      } else if (!isPropertyInformationValid) {
        errorMessage = 'Please fill all fields in Property Information form correctly.';
        setState(() {
          _currentFormIndex = 6;
        });
      } else if (!isAgrarianValid) {
        errorMessage =
            'Please fill all fields in Agrarian Information form correctly.';
        setState(() {
          _currentFormIndex = 7;
        });
      } else if (!isHouseDetailsValid) {
        errorMessage =
            'Please fill all fields in House Details form correctly.';
        setState(() {
          _currentFormIndex = 8;
        });
      } else if (!isLivestockDetailsValid) {
        errorMessage =
            'Please fill all fields in Livestock Details form correctly.';
        setState(() {
          _currentFormIndex = 9;
        });
      } else if (!isVehicleFormValid) {
        errorMessage =
            'Please fill all fields in Vehicle Information form correctly.';
        setState(() {
          _currentFormIndex = 10;
        });
      } else {
        errorMessage =
            'Please fill all fields in Disaster Details form correctly.';
        setState(() {
          _currentFormIndex = 11;
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      body: MultiPageFormNavigator(
        pages: [
          CitizenInformationForm(
            onNext: _navigateToNext,
            validateOnSubmit: _attemptedSubmit,
            clearValidation: _resetValidation,
          ),
          HouseholdInformation(
            onPrevious: _navigateToPrevious,
            onNext: _navigateToNext,
            validateOnSubmit: _attemptedSubmit,
            clearValidation: _resetValidation,
            formKey: GlobalKey<FormState>(),
          ),
          EducationInformation(
            onPrevious: _navigateToPrevious,
            onNext: _navigateToNext,
            validateOnSubmit: _attemptedSubmit,
            clearValidation: _resetValidation,
          ),
          SourceOfIncomeForm(
            onPrevious: _navigateToPrevious,
            onNext: _navigateToNext,
            validateOnSubmit: _attemptedSubmit,
            clearValidation: _resetValidation,
          ),
          HealthStatus(
            onPrevious: _navigateToPrevious,
            onNext: _navigateToNext,
            validateOnSubmit: _attemptedSubmit,
            clearValidation: _resetValidation,
          ),
          SubsidiesForm(
            onPrevious: _navigateToPrevious,
            onNext: _navigateToNext,
            validateOnSubmit: _attemptedSubmit,
            clearValidation: _resetValidation,
          ),
          PropertyInformation(
            onPrevious: _navigateToPrevious,
            onNext: _navigateToNext,
            validateOnSubmit: _attemptedSubmit,
            clearValidation: _resetValidation,
          ),
          Agrarian(
            onPrevious: _navigateToPrevious,
            onNext: _navigateToNext,
            validateOnSubmit: _attemptedSubmit,
            clearValidation: _resetValidation,
          ),
          HouseDetails(
            onPrevious: _navigateToPrevious,
            onNext: _navigateToNext,
            validateOnSubmit: _attemptedSubmit,
            clearValidation: _resetValidation,
          ),
          LivestockDetails(
            onPrevious: _navigateToPrevious,
            onNext: _navigateToNext,
            validateOnSubmit: _attemptedSubmit,
            clearValidation: _resetValidation,
          ),
          VehicleInformationForm(
            onPrevious: _navigateToPrevious,
            onNext: _navigateToNext,
            validateOnSubmit: _attemptedSubmit,
            clearValidation: _resetValidation,
          ),
          DisasterDetailsForm(
            onPrevious: _navigateToPrevious,
            onSubmit: _submitForms,
            validateOnSubmit: _attemptedSubmit,
            clearValidation: _resetValidation,
          ),
        ],
        totalPages: 12, // Update this if you have more pages
        onSubmit: _submitForms,
      ),
    );
  }
}
