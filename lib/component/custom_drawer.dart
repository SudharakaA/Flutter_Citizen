import 'package:citizen_care_system/login/login_screen.dart';
import 'package:citizen_care_system/pages/menubarPages/grievances_page.dart';
import 'package:citizen_care_system/pages/menubarPages/info_request_page.dart';
import 'package:citizen_care_system/pages/menubarPages/password_reset_page.dart';
import 'package:citizen_care_system/pages/menubarPages/sme_bussiness_page_1.dart';
import 'package:citizen_care_system/pages/menubarPages/edit_profile_page.dart';
import 'package:citizen_care_system/widget/main_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../bloc/bottom_nav_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawer extends StatefulWidget {
  final String accessToken;
  final String citizenCode;

  const CustomDrawer({
    super.key,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = _getResponsiveDrawerFontSize(screenWidth);
    final double iconSize = _getResponsiveDrawerIconSize(screenWidth);

    return Drawer(
      width: screenWidth < 600 ? screenWidth * 0.7 : 300,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xFF80AF81)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.account_circle, size: 60, color: Colors.white),
                      const SizedBox(height: 10),
                      Text('drawer.welcome'.tr(), style: const TextStyle(color: Colors.white, fontSize: 18)),
                      Text(
                        '${'drawer.citizen_id'.tr()}: ${widget.citizenCode}',
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.home),
                  title: Text('drawer.home'.tr(), style: TextStyle(fontSize: fontSize)),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (_) => BottomNavCubit(),
                          child: MainWrapper(
                            accessToken: widget.accessToken,
                            citizenCode: widget.citizenCode,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(CupertinoIcons.doc_text_fill, size: iconSize),
                  title: Text('drawer.grievances'.tr(), style: TextStyle(fontSize: fontSize)),
                  onTap: () => _navigateTo(context, GrievancesPage(
                      accessToken: widget.accessToken, citizenCode: widget.citizenCode)),
                ),
                ListTile(
                  leading: Icon(CupertinoIcons.doc_text_fill, size: iconSize),
                  title: Text('drawer.information_request'.tr(), style: TextStyle(fontSize: fontSize)),
                  onTap: () => _navigateTo(context, IFRPage(
                      accessToken: widget.accessToken, citizenCode: widget.citizenCode)),
                ),
                ListTile(
                  leading: Icon(Icons.person, size: iconSize),
                  title: Text('drawer.edit_profile'.tr(), style: TextStyle(fontSize: fontSize)),
                  onTap: () => _navigateTo(context, EPPPage(
                      accessToken: widget.accessToken, citizenCode: widget.citizenCode)),
                ),
                ListTile(
                  leading: Icon(CupertinoIcons.briefcase_fill, size: iconSize),
                  title: Text('drawer.sme_business'.tr(), style: TextStyle(fontSize: fontSize)),
                  onTap: () => _navigateTo(context, SMEBPage1(
                      accessToken: widget.accessToken, citizenCode: widget.citizenCode)),
                ),
                ListTile(
                  leading: Icon(CupertinoIcons.lock_fill, size: iconSize),
                  title: Text('drawer.change_password'.tr(), style: TextStyle(fontSize: fontSize)),
                  onTap: () => _navigateTo(context, PSRPage(
                      accessToken: widget.accessToken, citizenCode: widget.citizenCode)),
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red, size: iconSize),
                  title: Text('drawer.logout'.tr(), style: TextStyle(color: Colors.red, fontSize: fontSize)),
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
          ),

          // Persistent Footer
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.white70, blurRadius: 8, offset: Offset(0, 2))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'drawer.footer'.tr(), // e.g., "@2025 Powered by"
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'SLT ',
                        style: TextStyle(
                          color: Colors.lightBlue[700],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      TextSpan(
                        text: 'MOBITEL',
                        style: TextStyle(
                          color: Colors.lightGreen[700],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context); // Close the drawer
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('drawer.logout_confirm_title'.tr()),
        content: Text('drawer.logout_confirm_message'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('drawer.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: Text('drawer.logout'.tr()),
          ),
        ],
      ),
    );
  }

  double _getResponsiveDrawerFontSize(double screenWidth) {
    if (screenWidth < 300) return 12;
    if (screenWidth < 400) return 14;
    return 16;
  }

  double _getResponsiveDrawerIconSize(double screenWidth) {
    if (screenWidth < 300) return 18;
    if (screenWidth < 400) return 20;
    return 24;
  }
}
