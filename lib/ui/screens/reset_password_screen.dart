import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_firebase_09_09_25/data/services/network_caller.dart';
import 'package:task_manager_firebase_09_09_25/data/utlis/urls.dart';
import 'package:task_manager_firebase_09_09_25/ui/controllers/auth_controller.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/sign_in_screen.dart';
import 'package:task_manager_firebase_09_09_25/ui/utlis/app_colors.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/looder.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/screen_background.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/show_snakebar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key,});

  static const String name = '/reset-password';


  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _resetPasswordScreenInProgress = false;

  

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(36),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 80),
                  Text('Set password', style: textTheme.titleLarge),
                  SizedBox(height: 8),
                  Text('Minimum length of password should be more than 8 letters', style: textTheme.titleSmall),
                  SizedBox(height: 24),
                  TextFormField(
                    obscureText: true,
                    controller: _newPasswordTEController,
                    decoration: InputDecoration(hintText: 'New Password'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your new password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    obscureText: true,
                    controller: _confirmPasswordTEController,
                    decoration: InputDecoration(hintText: 'confirm Password'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'confirm password';
                      }
                      if(value != _newPasswordTEController.text){
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  Visibility(
                    visible: _resetPasswordScreenInProgress == false,
                    replacement: CenterCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: () {
                        _onTabForgotPassBtn();
                      },
                      child: Text('Confirm',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  SizedBox(height: 48),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: 8),
                        _buildRichText(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRichText() {
    return RichText(
      text: TextSpan(
        text: "Have  account ?",
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: '  Sign In',
            style: TextStyle(color: AppColors.themeColor),
            recognizer: TapGestureRecognizer()..onTap = () {
              Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (value) => false);
            },
          ),
        ],
      ),
    );
  }

  void _onTabForgotPassBtn() {
    if (_formKey.currentState!.validate()) {
      if(_newPasswordTEController.text == _confirmPasswordTEController.text) {
        //_resetPassword();
      }
      else{
        showSnakeBarMessage(context, 'Password not match');
      }
    }
  }

  /*Future<void> _resetPassword() async {
    _resetPasswordScreenInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": AuthController.getEmail,
      "OTP": AuthController.getPinCode,
      "password": _newPasswordTEController.text,
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.resetPasswordUrl,
      body: requestBody,
    );
    _resetPasswordScreenInProgress = false;
    setState(() {});


    if (response.isSuccess) {
      print(requestBody);
      showSnakeBarMessage(context, 'password reset successful');
      Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name,(_) => false);
      _newPasswordTEController.clear();
      _confirmPasswordTEController.clear();
    }
      else{
        showSnakeBarMessage(context, response.errorMessage);
      }
  }*/

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _newPasswordTEController.dispose();
    _confirmPasswordTEController.dispose();
  }
}
