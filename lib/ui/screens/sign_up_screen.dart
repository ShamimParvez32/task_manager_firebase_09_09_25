import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_firebase_09_09_25/data/services/network_caller.dart';
import 'package:task_manager_firebase_09_09_25/data/utlis/urls.dart';
import 'package:task_manager_firebase_09_09_25/ui/utlis/app_colors.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/looder.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/screen_background.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/show_snakebar_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String name = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _signUpInProgress = false;

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
                  Text('Join with us', style: textTheme.titleLarge),
                  SizedBox(height: 24),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTEController,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your Email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: InputDecoration(hintText: 'firstName'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your firstName';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: InputDecoration(hintText: 'lastName'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your lastName';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _mobileTEController,
                    decoration: InputDecoration(hintText: 'Mobile no'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your phone no';
                      }
                      return null;
                    },
                  ), SizedBox(height: 8),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordTEController,
                    decoration: InputDecoration(hintText: 'Password'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  Visibility(
                    visible: _signUpInProgress == false,
                    replacement: CenterCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: () {
                        _onTabSignUpBtn();
                      },
                      child: Icon(Icons.arrow_circle_right_outlined),
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
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _onTabSignUpBtn() {
    if (_formKey.currentState!.validate()) {
      _signUp();
    }
  }


  Future<void> _signUp() async {
    _signUpInProgress = true;
    setState(() {});

    try {
      // 1. Create user in Firebase Auth
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailTEController.text.trim(),
        password: _passwordTEController.text.trim(),
      );

      // 2. Save user data to Firestore
      await FirebaseFirestore.instance
          .collection('user_data')
          .doc(credential.user!.uid)
          .set({
        'email': _emailTEController.text.trim(),
        'firstName': _firstNameTEController.text.trim(),
        'lastName': _lastNameTEController.text.trim(),
        'mobile': _mobileTEController.text.trim(),
        'photo': " ",
        'createdAt': FieldValue.serverTimestamp(),

      });

      _clearTextField();
      showSnakeBarMessage(context, 'Registration successful');
    } on FirebaseAuthException catch (e) {
      showSnakeBarMessage(context, e.message ?? 'Registration failed');
    } catch (e) {
      showSnakeBarMessage(context, 'An error occurred');
    } finally {
      _signUpInProgress = false;
      setState(() {});
    }
  }

  /*Future<void> _signUp() async {
    _signUpInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text.trim(),
      "photo": ""
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.signUpUrl,
      body: requestBody,
    );
    _signUpInProgress=false;
    setState(() {
    });
    if (response.isSuccess) {
      _clearTextField();
      showSnakeBarMessage(context, 'registration successful');
    }
    else{
      showSnakeBarMessage(context, response.errorMessage);
    }
  }
*/


  void _clearTextField(){
    _emailTEController.clear();
    _passwordTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _passwordTEController.dispose();
    _mobileTEController.dispose();
  }
}
