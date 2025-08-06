import 'package:flutter/material.dart';
import 'package:helpy/styles/theme.dart';
import 'package:helpy/utils/constants/routes_constants.dart';
import 'package:helpy/utils/utility_methods.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  BoxShadow boxShadow = BoxShadow(
    color: Colors.black.withOpacity(0.4), // Shadow color
    spreadRadius: 0, // Spread radius
    blurRadius: 20, // Blur radius
    offset: const Offset(0, 9),
    // Offset in the x, y direction
  );

  // Demo login credentials
  final String _demoEmail = "demo@helpy.com";
  final String _demoPassword = "demo123";

  @override
  void initState() {
    super.initState();
    // Auto-fill with demo credentials
    _emailController.text = _demoEmail;
    _passwordController.text = _demoPassword;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Please enter both email and password", isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (email == _demoEmail && password == _demoPassword) {
      // Successful login
      _showSnackBar("Login successful! Welcome to Helpy!", isError: false);

      // Navigate to map screen and remove login from stack
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesConstants.map,
          (route) => false,
        );
      }
    } else {
      // Failed login
      _showSnackBar("Invalid credentials. Use demo@helpy.com / demo123",
          isError: true);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppColors.white),
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = UtilityMethods.isMobile(context);
    double screenWidth = UtilityMethods.getScreenSize(context).width;
    double headerWidth = isMobile ? screenWidth * 0.4 : 250;
    double headerHeight = isMobile ? 50 : 60;
    double headerFontSize = isMobile ? 35 : 50;
    double textFieldWidth = isMobile ? 180 : 250;
    Offset headerTextOffset =
        isMobile ? const Offset(0, 0) : const Offset(0, -5);

    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: AppTheme.loginBackgroundGradient,
            image: DecorationImage(
                image: const AssetImage(
                    'assets/images/mainpage_background.png'), // Replace with the path to your image asset
                fit: isMobile ? BoxFit.cover : BoxFit.contain,
                alignment: Alignment.topCenter)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  transformAlignment: Alignment.topCenter,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 50),
                  width: headerWidth,
                  padding: const EdgeInsets.all(0),
                  height: headerHeight,
                  decoration: BoxDecoration(
                    color: AppColors.thirdColor,
                    boxShadow: [boxShadow],
                  ),
                  child: Transform.translate(
                    offset: headerTextOffset,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Get",
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: headerFontSize,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          Text("Help",
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: headerFontSize,
                                  fontWeight: FontWeight.bold)),
                        ]),
                  ),
                ),
              ),
              Center(
                child: Container(
                  transformAlignment: Alignment.topCenter,
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(top: 20),
                  width: headerWidth + 70,
                  height: headerHeight,
                  decoration: BoxDecoration(
                    color: AppColors.thirdColor,
                    boxShadow: [boxShadow],
                  ),
                  child: Transform.translate(
                    offset: headerTextOffset,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Be",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: headerFontSize,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          Text("Helpful",
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: headerFontSize,
                                  fontWeight: FontWeight.bold)),
                        ]),
                  ),
                ),
              ),
              SizedBox(
                  height: UtilityMethods.getScreenSize(context).height * 0.45),
              SizedBox(
                height: 40,
                width: textFieldWidth,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [boxShadow],
                  ),
                  child: TextField(
                    controller: _emailController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: AppColors.thirdColor, fontSize: 18),
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !_isLoading,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        hintText: "Email",
                        hintStyle: TextStyle(color: AppColors.secondaryColor)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                width: textFieldWidth,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [boxShadow],
                  ),
                  child: TextField(
                    controller: _passwordController,
                    textAlign: TextAlign.center,
                    obscureText: true,
                    style: const TextStyle(
                        color: AppColors.thirdColor, fontSize: 18),
                    enabled: !_isLoading,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      hintText: "Password",
                      hintStyle: TextStyle(color: AppColors.secondaryColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                  width: isMobile ? 100 : 150,
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [boxShadow],
                    ),
                    child: TextButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "LOG IN",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Dubai',
                                    fontSize: 18),
                              )),
                  )),
              const SizedBox(height: 20),
              // Demo credentials info
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [boxShadow],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Demo Login Credentials:",
                      style: TextStyle(
                        color: AppColors.thirdColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Email: $_demoEmail",
                      style: const TextStyle(
                        color: AppColors.thirdColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "Password: $_demoPassword",
                      style: const TextStyle(
                        color: AppColors.thirdColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "don't have an account?",
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutesConstants.phoneVerification);
                      },
                      child: const Text(
                        " Sign up",
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5),
              const SizedBox(
                  child: InkWell(
                      onTap: null,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      ))),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
