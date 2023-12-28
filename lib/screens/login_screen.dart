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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
              'assets/images/mainpage_background.png'), // Replace with the path to your image asset
          fit: BoxFit.cover,
        )),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                   transformAlignment: Alignment.topCenter,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 50),
                  width: UtilityMethods.getScreenSize(context).width * 0.6,
                  height: 70,
                  color: AppColors.thirdColor,
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Get",
                            style: TextStyle(
                                color: AppColors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 10),
                        Text("help",
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 50,
                                fontWeight: FontWeight.bold)),
                      ]),
                ),
              ),
              Center(
                child: Container(
                  transformAlignment: Alignment.topCenter,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 20),
                  width: UtilityMethods.getScreenSize(context).width * 0.8,
                  height: 70,
                  color: AppColors.thirdColor,
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Help",
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 50,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 10),
                        Text("others",
                            style: TextStyle(
                                color: AppColors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold)),
                      ]),
                ),
              ),
              SizedBox(
                  height: UtilityMethods.getScreenSize(context).height * 0.4),
              SizedBox(
                width: UtilityMethods.getScreenSize(context).width * 0.6,
                height: 50,
                child: TextField(
                  style: TextStyle(color: AppColors.thirdColor, fontSize: 18),
                  maxLines: 1,

                  // expands: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    // labelText: 'Email',
                    hintText: "Email",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: UtilityMethods.getScreenSize(context).width * 0.6,
                child: const TextField(
                  obscureText: true,
                  style: TextStyle(color: AppColors.thirdColor, fontSize: 18),
                  decoration: InputDecoration(
                    // labelText: 'Email',
                    contentPadding: EdgeInsets.all(8),
                    hintText: "Password",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                  width: UtilityMethods.getScreenSize(context).width * 0.3,
                  child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ))),
              const SizedBox(height: 10),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "don't have an account?",
                      style: TextStyle(color: AppColors.white, fontSize: 14),
                    ),
                   InkWell(
                     onTap: (){
                       
                     },
                     child: Text(" Sign up",style: TextStyle(color: AppColors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                   )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
