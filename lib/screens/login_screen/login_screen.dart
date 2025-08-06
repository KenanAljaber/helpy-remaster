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
  BoxShadow boxShadow = BoxShadow(
    color: Colors.black.withOpacity(0.4), // Shadow color
    spreadRadius: 0, // Spread radius
    blurRadius: 20, // Blur radius
    offset: const Offset(0, 9),
    // Offset in the x, y direction
  );

  @override
  Widget build(BuildContext context) {
    bool isMobile = UtilityMethods.isMobile(context);
    double screenWidth = UtilityMethods.getScreenSize(context).width;
    double headerWidth= isMobile ? screenWidth * 0.4 : 250;
    double headerHeight= isMobile? 50 : 60;
    double headerFontSize=    isMobile ? 35 : 50;
    double textFieldWidth= isMobile ? 180 : 250;
    Offset headerTextOffset = isMobile ? const Offset(0, 0) : const Offset(0, -5);

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
                  height: headerHeight ,
                  decoration: BoxDecoration(
                    color: AppColors.thirdColor,
                    boxShadow: [boxShadow],
                  ),
                  child: Transform.translate(
                    offset: headerTextOffset,
                    child:  Row(
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
                  width: headerWidth+70,
                  height: headerHeight,
                  decoration: BoxDecoration(
                    color: AppColors.thirdColor,
                    boxShadow: [boxShadow],
                  ),
                  child: Transform.translate(
                    offset: headerTextOffset,
                    child:  Row(
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
                  child: const TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.thirdColor, fontSize: 18),
                    maxLines: 1,

                    // expands: true,
                    decoration: InputDecoration(
                        //add shadow
                        contentPadding: EdgeInsets.all(8),
                        // labelText: 'Email',
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
                  child: const TextField(
                    //center the text
                    textAlign: TextAlign.center,
                    obscureText: true,
                    style: TextStyle(color: AppColors.thirdColor, fontSize: 18),
                    decoration: InputDecoration(
                      // labelText: 'Email',
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
                        onPressed: () {},
                        child: const Text(
                          "LOG IN",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Dubai',
                              fontSize: 18),
                        )),
                  )),
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
                      onTap: () {},
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
