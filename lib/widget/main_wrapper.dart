import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_drawer.dart';
import '../bloc/bottom_nav_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

import '../pages/pages.dart';

class MainWrapper extends StatefulWidget {
  final String accessToken;
  final String citizenCode;

  const MainWrapper({
    super.key,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  //top level pages
  late final List<Widget> topLevelPages = [
    ProfilePage(
      accessToken: widget.accessToken,
      citizenCode: widget.citizenCode,
    ),
    RequestPage(
      accessToken: widget.accessToken,
      citizenCode: widget.citizenCode,
    ),
    ServicePage(
      accessToken: widget.accessToken,
      citizenCode: widget.citizenCode,
    ),
    NoticePage(
      accessToken: widget.accessToken,
      citizenCode: widget.citizenCode,
    ),

    ProjectPage(
      accessToken: widget.accessToken,
      citizenCode: widget.citizenCode,
    ),
  ];

  //on page changed
  void onPageChanged(int page) {
    BlocProvider.of<BottomNavCubit>(context).changeSelectedIndex(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: _mainWrapperAppBar(),
      drawer:  CustomDrawer(accessToken: widget.accessToken,citizenCode: widget.citizenCode,),
      body: _mainWrapperBody(),
      bottomNavigationBar: _mainWrapperBottomNavBar(context),
    );
  }

  //bottom navigation bar - MainWrapper Widget
  BottomAppBar _mainWrapperBottomNavBar(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        height: screenHeight * 0.1,
        width: screenWidth,
        child: Container(
          height: screenHeight * 0.1,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(screenWidth * 0.05),
              topRight: Radius.circular(screenWidth * 0.05),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: screenHeight * 0.001),
                SizedBox(
                  width: screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _bottomAppBarItem(
                              context,
                              defaultIcon: IconlyLight.profile,
                              page: 0,
                              label: "Profile",
                              filledIcon: IconlyBold.profile,
                            ),
                            _bottomAppBarItem(
                              context,
                              defaultIcon: IconlyLight.send,
                              page: 1,
                              label: "Request",
                              filledIcon: IconlyBold.send,
                            ),
                            _bottomAppBarItem(
                              context,
                              defaultIcon: IconlyLight.setting,
                              page: 2,
                              label: "Service",
                              filledIcon: IconlyBold.setting,
                            ),
                            _bottomAppBarItem(
                              context,
                              defaultIcon: IconlyLight.notification,
                              page: 3,
                              label: "Notice",
                              filledIcon: IconlyBold.notification,
                            ),
                            _bottomAppBarItem(
                              context,
                              defaultIcon: IconlyLight.chart,
                              page: 4,
                              label: "Project",
                              filledIcon: IconlyBold.chart,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // App Bar - MainWrapper Widget
  CustomAppBarWidget _mainWrapperAppBar() {
    return const CustomAppBarWidget();
  }

  // Body - MainWrapper Widget
  PageView _mainWrapperBody() {
    return PageView(
      onPageChanged: onPageChanged,
      controller: pageController,
      children: topLevelPages,
    );
  }

  //Bottom Navigation Bar Single item - MainWrapper Widget
  Widget _bottomAppBarItem(
      BuildContext context, {
        required defaultIcon,
        required page,
        required label,
        required filledIcon,
      }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          BlocProvider.of<BottomNavCubit>(context).changeSelectedIndex(page);
          pageController.animateToPage(
            page,
            duration: const Duration(milliseconds: 10),
            curve: Curves.fastLinearToSlowEaseIn,
          );
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Icon(
                context.watch<BottomNavCubit>().state == page
                    ? filledIcon
                    : defaultIcon,
                color: context.watch<BottomNavCubit>().state == page
                    ? const Color(0xFF3A7D44)
                    : Colors.black,
                size: 24,
              ),
              const SizedBox(height: 0),
              Text(
                label,
                style: GoogleFonts.aBeeZee(
                  color: context.watch<BottomNavCubit>().state == page
                      ? const Color(0xFF3A7D44)
                      : Colors.black,
                  fontSize: 13,
                  fontWeight: context.watch<BottomNavCubit>().state == page
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
