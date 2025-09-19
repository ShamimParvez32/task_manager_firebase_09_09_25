/*
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_firebase_09_09_25/ui/controllers/auth_controller.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/sign_in_screen.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/update_profile_screen.dart';
import 'package:task_manager_firebase_09_09_25/ui/utlis/app_colors.dart';
class TmAppBar extends StatelessWidget implements PreferredSizeWidget{
  const TmAppBar({
    super.key,  this.fromUpdateProfile=false,
  });
final bool fromUpdateProfile;
  @override
  Widget build(BuildContext context) {
   final  textTheme=Theme.of(context).textTheme;

    return AppBar(
      backgroundColor: AppColors.themeColor,
      title: Row(
        children: [
              CircleAvatar(
                radius: 16,
                //backgroundImage: MemoryImage(base64Decode(AuthController.userModel!.photo!))
              ),
          SizedBox(width: 8,),
          Expanded(
            child: GestureDetector(
              onTap: (){
                if(fromUpdateProfile==false){
                  Navigator.pushNamed(context, UpdateProfileScreen.name);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AuthController.userModel?.fullName?? '',style: textTheme.titleSmall?.copyWith(color: Colors.white)),
                  Text(AuthController.userModel?.email?? '',style: textTheme.bodySmall?.copyWith(color: Colors.white),)
                ],
              ),
            ),
          ),
          IconButton(onPressed: ()async{
            await AuthController.clearUserData();
            Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (predicate)=> false);
          }, icon: Icon(Icons.login_outlined))
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/sign_in_screen.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/update_profile_screen.dart';
import 'package:task_manager_firebase_09_09_25/ui/utlis/app_colors.dart';

class TmAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TmAppBar({super.key, this.fromUpdateProfile = false});

  final bool fromUpdateProfile;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return AppBar(
      backgroundColor: AppColors.themeColor,
      title: uid == null
          ? const Text("Guest User", style: TextStyle(color: Colors.white))
          : StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("user_data")
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...",
                style: TextStyle(color: Colors.white,fontSize: 12),);
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text("No user data",
                style: TextStyle(color: Colors.white));
          }

          final userData =
              snapshot.data!.data() as Map<String, dynamic>? ?? {};

          return Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: userData['photo'] != null &&
                    userData['photo'].toString().isNotEmpty
                    ? NetworkImage(userData['photo'])
                    : null,
                child: userData['photo'] == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!fromUpdateProfile) {
                      Navigator.pushNamed(
                          context, UpdateProfileScreen.name);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(
                          userData['firstName'] ?? "Unknown User",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: 5,),
                        Text(
                          userData['lastName'] ?? "Unknown User",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]

                      ),

                      Text(
                        userData['email'] ??
                            FirebaseAuth.instance.currentUser?.email ??
                            "",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    SignInScreen.name,
                        (predicate) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

