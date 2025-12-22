import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import '../component/rounded_rectangle.dart';
import 'noticesPages/farm_support_page.dart';
import 'noticesPages/government_news_page.dart';
import 'noticesPages/job_opportunities_page.dart';
import 'noticesPages/business_support_page.dart';

class NoticePage extends StatelessWidget {
  final String accessToken;
  final String citizenCode;

  const NoticePage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Container(
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
            "notice_title".tr(),
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: RoundedRectangle(
                          imagePath:
                          'assets/images/noticeImages/Farm_Support.png',
                          child: Center(
                            child: Text(
                              "farm_support".tr(),
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
                              MaterialPageRoute(
                                builder: (context) => FarmSupportPage(
                                  accessToken: accessToken,
                                  citizenCode: citizenCode,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: RoundedRectangle(
                          imagePath:
                          'assets/images/noticeImages/Government_News.png',
                          child: Center(
                            child: Text(
                              "government_news".tr(),
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
                              MaterialPageRoute(
                                builder: (context) => GovernmentNewsPage(
                                  accessToken: accessToken,
                                  citizenCode: citizenCode,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: RoundedRectangle(
                          imagePath:
                          'assets/images/noticeImages/Job_Opportunities.png',
                          child: Center(
                            child: Text(
                              "career_opportunities".tr(),
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
                              MaterialPageRoute(
                                builder: (context) => JobOpportunitiesPage(
                                  accessToken: accessToken,
                                  citizenCode: citizenCode,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: RoundedRectangle(
                          imagePath:
                          'assets/images/noticeImages/Business_Support.png',
                          child: Center(
                            child: Text(
                              "business_support".tr(),
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
                              MaterialPageRoute(
                                builder: (context) => BusinessSupportPage(
                                  accessToken: accessToken,
                                  citizenCode: citizenCode,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
