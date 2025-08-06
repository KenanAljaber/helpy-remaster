import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpy/models/user/reputation.dart';
import 'package:helpy/models/user/user.dart';
import 'package:helpy/styles/theme.dart';
import 'package:helpy/utils/constants/routes_constants.dart';
import 'package:helpy/utils/utility_methods.dart';
import 'package:helpy/widgets/map/my_map.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool locationIsGranted = true;

  @override
  void initState() {
    super.initState();
    // if the platform is android then hide the status bar
    UtilityMethods.hideStatusBar();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bool result =
          await UtilityMethods.isServiceEnabled(Permission.locationWhenInUse);
      if (!result) {
        bool result = await UtilityMethods.requestPermission(
            Permission.locationWhenInUse);
        setState(() {
          locationIsGranted = result;
        });
      }
    });
  }
  // lets try to code anything, wow it is so fucking clear

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: locationIsGranted || kIsWeb
            ? SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    const MyMap(),
                    //add a rounded button on the bottom center
                    Container(
                        alignment: Alignment.bottomCenter,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          // profile button
                          onPressed: () {
                             Navigator.pushNamed(
                                              context, RoutesConstants.profile, arguments: 
                                            User(
                                                reputation: Reputation.empty(),
                                                name: 'kenan',
                                                email: 'keno12333@hotmail2.com',
                                                helpWay: "Help translating papers from English to Spanish"),
                                          );
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(kIsWeb ? 15 : 5),
                              backgroundColor: AppColors.primaryColor,
                              shape: const CircleBorder()),
                          child: Image.asset(
                              "assets/images/map_button_image.png",
                              width: 50,
                              height: 50),
                        )),
                    //add a topBar full width with primary color as background
                    Container(
                      width: UtilityMethods.getScreenSize(context).width,
                      height: 60,
                      padding:
                          kIsWeb ? const EdgeInsets.only(left: 50, right: 50) : null,
                      color: AppColors.primaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  iconSize: 40,
                                  color: AppColors.almostBlack,
                                  icon: const Icon(Icons.notifications)),
                              IconButton(
                                  onPressed: () {},
                                  iconSize: 40,
                                  color: AppColors.almostBlack,
                                  icon: const Icon(Icons.people)),
                            ],
                          ),
                          const Spacer(),
                          Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.end,
                              spacing: 10,
                              children: [
                                SizedBox(
                                  width: kIsWeb ? 400 : 150,
                                  height: 40,
                                  child: const TextField(),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    // color: AppColors.almostBlack,
                                    decoration: BoxDecoration(
                                      color: AppColors.almostBlack,
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    //search button
                                    child: IconButton(
                                        onPressed: () {},
                                        color: AppColors.white,
                                        icon: const Icon(Icons.search)),
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Container(
                width: double.infinity,
                height: double.infinity,
                color: AppColors.primaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Our app requires your location :(",
                    ),
                    const Text(
                      "Please grant permission to access your location",
                      // style: TextStyle(color: AppColors.white),
                    ),
                    TextButton(
                        onPressed: () async {
                          bool result = await UtilityMethods.requestPermission(
                              Permission.locationWhenInUse);

                          setState(() {
                            locationIsGranted = result;
                          });
                        },
                        child: const Text(
                          "Grant Permission",
                        ))
                  ],
                )));
  }
}
