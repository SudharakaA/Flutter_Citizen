import 'package:flutter/material.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  static const String title = "CITIZEN CARE SYSTEM";
  static const String subtitle = "DIVISION SECRETARIAT - POLONNARUWA";

  final Widget? leading;

  const CustomAppBarWidget({super.key, this.leading});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double emblemHeight = _getResponsiveEmblemHeight(screenWidth);
    final double titleFontSize = _getResponsiveTitleFontSize(screenWidth);
    final double subtitleFontSize = _getResponsiveSubtitleFontSize(screenWidth);

    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: screenWidth < 360 ? 50 : null,
      leading: leading,
      title: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              screenWidth < 300 ? "CCS" : " $title",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                height: 1.2,
                fontSize: titleFontSize,
                color: Colors.black,
              ),
              overflow: TextOverflow.fade,
            ),
            Text(
              screenWidth < 300 ? "DS - POLONNARUWA" : subtitle,
              style: TextStyle(
                fontSize: subtitleFontSize,
                color: Colors.black,
              ),
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 25.0),
          child: Image.asset(
            'assets/images/emblem.png',
            height: emblemHeight,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  double _getResponsiveEmblemHeight(double screenWidth) {
    if (screenWidth < 300) return 30;
    if (screenWidth < 400) return 40;
    return 50;
  }

  double _getResponsiveTitleFontSize(double screenWidth) {
    if (screenWidth < 300) return 14;
    if (screenWidth < 400) return 16;
    if (screenWidth < 600) return 18;
    return 20;
  }

  double _getResponsiveSubtitleFontSize(double screenWidth) {
    if (screenWidth < 300) return 8;
    if (screenWidth < 400) return 9;
    return 10;
  }

  /*double _getResponsiveIconSize(double screenWidth) {
    if (screenWidth < 300) return 12;
    if (screenWidth < 400) return 13;
    return 15;
  }*/
}
