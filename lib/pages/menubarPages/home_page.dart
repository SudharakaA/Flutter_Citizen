import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_drawer.dart';
import 'package:flutter/material.dart';
// Import the CustomAppBar

class HomePage extends StatefulWidget {
  final String accessToken; // Required Bearer token
  final String citizenCode; // Required citizen code

  const HomePage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBarWidget(),
        drawer: CustomDrawer(
          accessToken: widget.accessToken,
          citizenCode: widget.citizenCode,
        ),
        body: Container());
  }
}
