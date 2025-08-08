import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpy/models/country_code.dart';
import 'package:helpy/styles/theme.dart';
import 'package:helpy/utils/constants/routes_constants.dart';
import 'package:helpy/utils/utility_methods.dart';
import 'package:provider/provider.dart';
import 'package:helpy/state/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  bool _isCodeSent = false;
  int _countdown = 60;
  CountryCode _selectedCountry = CountryCodesData.getDefaultCountry();

  BoxShadow boxShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.4), // Shadow color
    spreadRadius: 0, // Spread radius
    blurRadius: 20, // Blur radius
    offset: const Offset(0, 9),
    // Offset in the x, y direction
  );

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (_phoneController.text.trim().isEmpty) {
      _showSnackBar('Please enter your phone number', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _isCodeSent = true;
    });

    _showSnackBar(
        'Verification code sent to ${_selectedCountry.dialCode} ${_phoneController.text}',
        isError: false);
    _startCountdown();
  }

  void _startCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _countdown--;
        });
        return _countdown > 0;
      }
      return false;
    }).then((_) {
      if (mounted) {
        setState(() {
          _countdown = 60;
        });
      }
    });
  }

  Future<void> _verifyCode() async {
    if (_codeController.text.trim().isEmpty) {
      _showSnackBar('Please enter the verification code', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate verification
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Successful login
    _showSnackBar("Login successful! Welcome to Helpy!", isError: false);

    // Persist fake token and update global auth state
    if (!mounted) return;
    await context.read<AuthState>().signInWithFakeToken();

    // Navigate to map screen and remove login from stack
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesConstants.map,
        (route) => false,
      );
    }
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Select Country',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: CountryCodesData.countryCodes.length,
                  itemBuilder: (context, index) {
                    final country = CountryCodesData.countryCodes[index];
                    return ListTile(
                      leading: Text(
                        country.flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(country.name),
                      trailing: Text(country.dialCode),
                      onTap: () {
                        setState(() {
                          _selectedCountry = country;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
      resizeToAvoidBottomInset: true,
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
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
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
                        height: UtilityMethods.getScreenSize(context).height *
                            0.35),

                    // Title section (icon removed)

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        _isCodeSent
                            ? 'Enter Verification Code'
                            : 'Login with Phone Number',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        _isCodeSent
                            ? 'We sent a 6-digit code to ${_selectedCountry.dialCode} ${_phoneController.text}'
                            : 'Enter your phone number to receive a login code',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),

                    if (!_isCodeSent) ...[
                      // Phone number input with integrated country selector
                      Container(
                        width: textFieldWidth + 100,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          boxShadow: [boxShadow],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: const TextStyle(
                            color: AppColors.thirdColor,
                            fontSize: 16,
                          ),
                          enabled: !_isLoading,
                          decoration: InputDecoration(
                            hintText: 'Phone number',
                            hintStyle: const TextStyle(
                                color: AppColors.secondaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: AppColors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            // Integrated country code as prefix
                            prefixIcon: GestureDetector(
                              onTap: _showCountryPicker,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _selectedCountry.flag,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _selectedCountry.dialCode,
                                      style: const TextStyle(
                                        color: AppColors.thirdColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: AppColors.thirdColor,
                                      size: 20,
                                    ),
                                    Container(
                                      width: 1,
                                      height: 20,
                                      margin: const EdgeInsets.only(left: 8),
                                      color: AppColors.secondaryColor
                                          .withValues(alpha: 0.3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      // Verification code input
                      SizedBox(
                        width: textFieldWidth + 100,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [boxShadow],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _codeController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                              color: AppColors.thirdColor,
                            ),
                            enabled: !_isLoading,
                            decoration: InputDecoration(
                              hintText: '000000',
                              hintStyle: TextStyle(
                                color: AppColors.secondaryColor
                                    .withValues(alpha: 0.6),
                                letterSpacing: 4,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: AppColors.white,
                              contentPadding: const EdgeInsets.all(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Resend code button
                      if (_countdown > 0)
                        Text(
                          'Resend code in $_countdown seconds',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isCodeSent = false;
                              _codeController.clear();
                            });
                          },
                          child: const Text(
                            'Resend Code',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                    ],
                    const SizedBox(height: 30),

                    // Continue/Verify button
                    SizedBox(
                      width: isMobile ? 150 : 200,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [boxShadow],
                        ),
                        child: TextButton(
                          onPressed: _isLoading
                              ? null
                              : (_isCodeSent ? _verifyCode : _sendCode),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  _isCodeSent ? 'VERIFY CODE' : 'LOGIN',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Dubai',
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Demo credentials info
                    // Container(
                    //   margin: const EdgeInsets.symmetric(horizontal: 20),
                    //   padding: const EdgeInsets.all(12),
                    //   decoration: BoxDecoration(
                    //     color: AppColors.white.withOpacity(0.9),
                    //     borderRadius: BorderRadius.circular(8),
                    //     boxShadow: [boxShadow],
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       const Text(
                    //         "Demo Login Credentials:",
                    //         style: TextStyle(
                    //           color: AppColors.thirdColor,
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //       const SizedBox(height: 8),
                    //       Text(
                    //         "Email: $_demoEmail",
                    //         style: const TextStyle(
                    //           color: AppColors.thirdColor,
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.w400,
                    //         ),
                    //       ),
                    //       Text(
                    //         "Password: $_demoPassword",
                    //         style: const TextStyle(
                    //           color: AppColors.thirdColor,
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.w400,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 15),
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
                    // const SizedBox(
                    //     child: InkWell(
                    //         onTap: null,
                    //         child: Text(
                    //           "Forgot Password?",
                    //           style: TextStyle(
                    //               color: AppColors.white,
                    //               fontSize: 14,
                    //               fontWeight: FontWeight.w300),
                    //         ))),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
