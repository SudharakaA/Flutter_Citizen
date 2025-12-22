import 'package:citizen_care_system/admin_pages/home_page.dart';
import 'package:citizen_care_system/widget/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'forgot_password_page.dart';
import 'new_account_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bottom_nav_cubit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'action_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<String> imgList = [
    'assets/images/image-1.jpg',
    'assets/images/image-2.jpg',
    'assets/images/image-3.jpg',
  ];

  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isLoading = false; // Added missing variable

  void _handleLogin() async {
    String userId = _userIdController.text.trim();
    String password = _passwordController.text.trim();
    final String baseUrl = dotenv.env['GetAuthentication'] ?? '';

    if (userId.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("login_empty_fields".tr())),
      );
      return;
    }

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    String userType;
    if (userId.length == 6) {
      userType = '0'; // Citizen
    } else if (userId.length >= 9 && userId.length <= 12) {
      userType = '1'; // Admin
    } else {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("login_invalid_user_id".tr())),
      );
      return;
    }

    final url = Uri.parse(baseUrl);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': userId,
          'password': password,
          'usertype': userType,
        }),
      );

      final json = jsonDecode(response.body);

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      if (response.statusCode == 200 && json['isSuccess'] == true) {
        String accessToken = json['dataBundle']['accessToken'];

        if (userType == '0') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (_) => BottomNavCubit(),
                child: MainWrapper(
                  accessToken: accessToken,
                  citizenCode: userId,
                ),
              ),
            ),
          );
        } else if (userType == '1') {
          List<String> authRoleList = List<String>.from(
              json['dataBundle']['dynUser']['authorizedRoleList']
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  HomePage(accessToken: accessToken, citizenCode: userId, authorizedRoleList: authRoleList,)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("login_auth_failed".tr() +
                  ": ${json['message'] ?? 'Unknown error'}")),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("login_error".tr() + ": ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // Changed to Stack to properly overlay loading indicator
        children: [
          SingleChildScrollView(
            child: Stack(
              children: [
                ClipPath(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CarouselSlider(
                              items: imgList
                                  .map((item) => Image.asset(item,
                                  fit: BoxFit.cover, width: double.infinity))
                                  .toList(),
                              options: CarouselOptions(
                                height: 400,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 5),
                                viewportFraction: 1.0,
                                enlargeCenterPage: false,
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withAlpha(100),
                                      Colors.black.withAlpha(100),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/images/gov_logo.png',
                                      width: 70,
                                      height: 70,
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'CITIZEN CARE SYSTEM',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 70),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 380),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        /// Language Dropdown
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              DropdownButton<Locale>(
                                value: context.locale,
                                icon:
                                const Icon(Icons.language, color: Colors.green),
                                underline: const SizedBox(),
                                items: const [
                                  DropdownMenuItem(
                                    value: Locale('en'),
                                    child: Text('EN'),
                                  ),
                                  DropdownMenuItem(
                                    value: Locale('si'),
                                    child: Text('සිං'),
                                  ),
                                  DropdownMenuItem(
                                    value: Locale('ta'),
                                    child: Text('தமிழ்'),
                                  ),
                                ],
                                onChanged: (Locale? locale) {
                                  if (locale != null) {
                                    context.setLocale(locale);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('username'.tr(),
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                                child: TextField(
                                  controller: _userIdController,
                                  decoration: InputDecoration(
                                    hintText: 'username'.tr(),
                                    prefixIcon: const Icon(Icons.person,
                                        color: Colors.grey),
                                    border: InputBorder.none,
                                    contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('password'.tr(),
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: !_passwordVisible,
                                  decoration: InputDecoration(
                                    hintText: 'password'.tr(),
                                    prefixIcon:
                                    const Icon(Icons.lock, color: Colors.grey),
                                    border: InputBorder.none,
                                    contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ForgotPasswordPage()),
                                );
                              },
                              child: Text('forgot_password'.tr(),
                                  style: const TextStyle(
                                    color: Color(0xFF508D4E),
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ActionButton(
                            text: _isLoading ? 'Login In...' : 'login'.tr(),
                            overflow: TextOverflow.ellipsis,
                            onPressed: _isLoading ? null : _handleLogin,
                            width: 260,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                'no_account'.tr(),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Flexible(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const NewAccountPage()),
                                  );
                                },
                                child: Text(
                                  'create_account'.tr(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF508D4E),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Loading overlay - properly positioned
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3A7D44)),
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Login In...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}