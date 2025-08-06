import 'package:flutter/material.dart';
import 'package:helpy/models/user/user.dart';
import 'package:helpy/styles/theme.dart';

class UserProfile extends StatefulWidget {
  User user;
   UserProfile({super.key, required this.user});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: Container(
              color: AppColors.primaryColor,
              height: 150,
              padding: const EdgeInsets.all( 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.secondaryColor,
                  ),
                  const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.user.name.toUpperCase() ?? 'John Doe', textAlign: TextAlign.start,style: const TextStyle( color: Colors.black,fontWeight: FontWeight.bold),),
                        Text(widget.user.helpWay ?? 'I can help with this tas asda dasd', overflow: TextOverflow.ellipsis, maxLines: 2),
                        Text(widget.user.phone ?? '1234567890'),
                      ]
                    )
                ]
              )
            ),
          )
        ]
      )
    );
  }
}