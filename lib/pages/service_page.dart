import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../component/rounded_rectangle.dart';
import 'servicesPages/mainServicesPages/nic_service_page.dart';
import 'servicesPages/mainServicesPages/public_grievance_service_page.dart';
import 'servicesPages/mainServicesPages/certificate_permit_service_page.dart';
import 'servicesPages/mainServicesPages/business_registration_service_page.dart';
import 'servicesPages/mainServicesPages/land_property_service_page.dart';
import 'servicesPages/mainServicesPages/compensation_service_page.dart';
import 'servicesPages/mainServicesPages/welfare_service_page.dart';
import 'servicesPages/mainServicesPages/traning_service_page.dart';
import 'package:easy_localization/easy_localization.dart';

class ServicePage extends StatelessWidget {
  final String accessToken;
  final String citizenCode;

  const ServicePage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
          top: screenHeight * 0.02,
          left: screenWidth * 0.03,
          right: screenWidth * 0.03,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "our_services".tr(),
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              thickness: 1,
              color: Colors.black38,
              indent: 20,
              endIndent: 20,
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: RoundedRectangle(
                        imagePath: 'assets/images/servicesImages/National_Identity_Card_Services.png',
                        child: Center(
                          child: Text(
                            "nic_services".tr(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NicServicePage(
                              accessToken: accessToken,
                              citizenCode: citizenCode,
                            )),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RoundedRectangle(
                        imagePath: 'assets/images/servicesImages/Public_Grievance_And _Assistance .png',
                        child: Center(
                          child: Text(
                            "public_grievance".tr(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  PublicGrievanceServicePage(
                              accessToken: accessToken,
                              citizenCode: citizenCode,
                            )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: RoundedRectangle(
                        imagePath: 'assets/images/servicesImages/Certificate_and_Permit_Issuance.png',
                        child: Center(
                          child: Text(
                            "certificate_permit".tr(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  CertificatePermitServicePage(
                              accessToken: accessToken,
                              citizenCode: citizenCode,
                            )),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RoundedRectangle(
                        imagePath: 'assets/images/servicesImages/Business_Registration_Services.png',
                        child: Center(
                          child: Text(
                            "business_registration".tr(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  BusinessRegistrationServicePage(
                              accessToken: accessToken,
                              citizenCode: citizenCode,
                            )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: RoundedRectangle(
                        imagePath: 'assets/images/servicesImages/Land_And_Property_Services.png',
                        child: Center(
                          child: Text(
                            "land_property".tr(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  LandServicePage(
                              accessToken: accessToken,
                              citizenCode: citizenCode,
                            )),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RoundedRectangle(
                        imagePath: 'assets/images/servicesImages/Compensation_And_Claims.png',
                        child: Center(
                          child: Text(
                            "compensation".tr(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  CompensationServicePage(
                              accessToken: accessToken,
                              citizenCode: citizenCode,
                            )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: RoundedRectangle(
                        imagePath: 'assets/images/servicesImages/Welfare_And_Social_Assistance.png',
                        child: Center(
                          child: Text(
                            "welfare".tr(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WelfareServicePage(
                              accessToken: accessToken,
                              citizenCode: citizenCode,
                            )),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RoundedRectangle(
                        imagePath: 'assets/images/servicesImages/Training_And_Development.png',
                        child: Center(
                          child: Text(
                            "training".tr(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TrainingServicePage(
                              accessToken: accessToken,
                              citizenCode: citizenCode,
                            )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
