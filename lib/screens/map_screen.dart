import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpy/styles/theme.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: locationIsGranted
            ? Container(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    MyMap(),
                    //add a rounded button on the bottom center
                    Container(
                        alignment: Alignment.bottomCenter,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(5),
                              backgroundColor: AppColors.primaryColor,
                              shape: CircleBorder()),
                          child: Image.asset(
                              "assets/images/map_button_image.png",
                              width: 50,
                              height: 50),
                        )),
                    //add a topBar full width with primary color as background
                    Container(
                      width: UtilityMethods.getScreenSize(context).width,
                      height: 60,
                      color: AppColors.primaryColor,
                      child: Row(
                        children: [],
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
                    Text(
                      "Our app requires your location :(",
                    ),
                    Text(
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
                        child: Text(
                          "Grant Permission",
                        ))
                  ],
                )));
  }
}
