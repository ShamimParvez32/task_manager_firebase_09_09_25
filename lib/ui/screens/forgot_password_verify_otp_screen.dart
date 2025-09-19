import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_firebase_09_09_25/data/services/network_caller.dart';
import 'package:task_manager_firebase_09_09_25/data/utlis/urls.dart';
import 'package:task_manager_firebase_09_09_25/ui/controllers/auth_controller.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/reset_password_screen.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/sign_in_screen.dart';
import 'package:task_manager_firebase_09_09_25/ui/utlis/app_colors.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/looder.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/screen_background.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/show_snakebar_message.dart';

class ForgotPasswordVerifyOtpScreen extends StatefulWidget {
  const ForgotPasswordVerifyOtpScreen({super.key,});

  static const String name = '/forgot-password/verify-otp';

  @override
  State<ForgotPasswordVerifyOtpScreen> createState() =>
      _ForgotPasswordVerifyOtpScreenState();
}

class _ForgotPasswordVerifyOtpScreenState
    extends State<ForgotPasswordVerifyOtpScreen> {
  final TextEditingController _pinCodeTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _forgotPasswordVerifyOtpScreenInProgress = false;


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
                  Text('Pin Varification', style: textTheme.titleLarge),
                  SizedBox(height: 8),
                  Text(
                    'A 6 digits of OTP will be sent to your email address',
                    style: textTheme.titleSmall,
                  ),
                  SizedBox(height: 24),
                  _buildPinCodeTextField(context),
                  SizedBox(height: 24),
                  Visibility(
                    visible: _forgotPasswordVerifyOtpScreenInProgress == false,
                    replacement: CenterCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: () {
                        //_onTabForgotPassBtn();
                        Navigator.pushNamed(context, ResetPasswordScreen.name);
                      },
                      child: Text(
                        'Verify',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 48),
                  Center(
                    child: Column(
                      children: [SizedBox(height: 8), _buildRichText()],
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

  Widget _buildPinCodeTextField(BuildContext context) {
    return PinCodeTextField(
      length: 6,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: Colors.white,
        selectedFillColor: Colors.white,
        inactiveFillColor: Colors.white,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      controller: _pinCodeTEController,
      appContext: context,
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
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  SignInScreen.name,
                  (value) => false,
                );
              },
          ),
        ],
      ),
    );
  }

  /*void _onTabForgotPassBtn() {
    if (_formKey.currentState!.validate()) {
      _verifyOtp(AuthController.getEmail, _pinCodeTEController.text);
    }
  }

  Future<void> _verifyOtp(String email, String pinCode) async {
    _forgotPasswordVerifyOtpScreenInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.recoveryOtpUrl(email, pinCode),
    );

    _forgotPasswordVerifyOtpScreenInProgress = false;
    setState(() {});



    if (response.isSuccess) {
      showSnakeBarMessage(context, 'Otp verification successful');
      AuthController.setPinCode=pinCode;
      Navigator.pushNamed(context, ResetPasswordScreen.name,);
      _pinCodeTEController.clear();
    } else {
      showSnakeBarMessage(context, response.errorMessage);
    }
  }*/

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pinCodeTEController.dispose();
  }
}
