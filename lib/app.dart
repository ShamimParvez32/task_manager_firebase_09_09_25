import 'package:flutter/material.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/add_new_task_screen.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/forgot_password_verify_email_screen.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/forgot_password_verify_otp_screen.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/reset_password_screen.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/sign_in_screen.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/sign_up_screen.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/splash_screen.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/update_profile_screen.dart';
import 'package:task_manager_firebase_09_09_25/ui/utlis/app_colors.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey=GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.w600,fontSize: 28),
          titleSmall: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500)
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,color: Colors.grey,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.themeColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            fixedSize: const Size.fromWidth(double.maxFinite),
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            textStyle: const TextStyle(fontSize: 16)
          )
        )
      ),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings setting){
        late Widget widget;
        if(setting.name=='/'){
          widget= const SplashScreen();
        } else if(setting.name== SignInScreen.name) {
          widget = const SignInScreen();
        }else if(setting.name== SignUpScreen.name){
          widget= const SignUpScreen();
        }else if(setting.name== ForgotPasswordVerifyEmailScreen.name){
          widget= const ForgotPasswordVerifyEmailScreen();
        }else if(setting.name== ForgotPasswordVerifyOtpScreen.name){
          widget= ForgotPasswordVerifyOtpScreen();
        }else if(setting.name== ResetPasswordScreen.name){
          widget= ResetPasswordScreen();
        }else if(setting.name== MainBottomNavScreen.name) {
          widget = const MainBottomNavScreen();
        }else if(setting.name== UpdateProfileScreen.name) {
          widget = const UpdateProfileScreen();
        }else if(setting.name== AddNewTaskScreen.name) {
          widget = const AddNewTaskScreen();
        }
        return MaterialPageRoute(builder: (ctx)=> widget);
      },
    );
  }
}
