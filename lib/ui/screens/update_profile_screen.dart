/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_firebase_09_09_25/data/services/network_caller.dart';
import 'package:task_manager_firebase_09_09_25/data/utlis/urls.dart';
import 'package:task_manager_firebase_09_09_25/ui/controllers/auth_controller.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/looder.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/screen_background.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/show_snakebar_message.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/tm_app_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String name = '/update-profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  XFile? _pickedImage;
  bool _updateProfileInProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailTEController.text = AuthController.userModel?.email ?? '';
    _firstNameTEController.text = AuthController.userModel?.firstName ?? '';
    _lastNameTEController.text = AuthController.userModel?.lastName ?? '';
    _mobileTEController.text = AuthController.userModel?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: TmAppBar(fromUpdateProfile: true),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(36),
            child: _buildForm(textTheme),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(TextTheme textTheme) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 80),
          Text('Update Profile', style: textTheme.titleLarge),
          SizedBox(height: 24),
          _buildPhotoPicker(),
          SizedBox(height: 8),
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
          ),
          SizedBox(height: 8),
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
            visible: _updateProfileInProgress == false,
            replacement: CenterCircularProgressIndicator(),
            child: ElevatedButton(
              onPressed: () {
                _onTabUpdateProfileBtn();
              },
              child: Icon(Icons.arrow_circle_right_outlined),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _pickImage,

      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                color: Colors.grey,
              ),
              child: const Text('Photo', style: TextStyle(color: Colors.white)),
              alignment: Alignment.center,
            ),
            SizedBox(width: 8),
            Text(
              _pickedImage == null ? 'No item selected' : _pickedImage!.name,
            ),
          ],
        ),
      ),
    );
  }

  void _onTabUpdateProfileBtn() {
    if (_formKey.currentState!.validate()) {
     // _updateProfile();
    }
  }

  Future<void> _pickImage() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _pickedImage = image;
      setState(() {});
    }
  }

  Future<void> _updateProfile() async {
    _updateProfileInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
    };

    if (_pickedImage != null) {
      List<int> imageBytes = await _pickedImage!.readAsBytes();
      requestBody['photo'] = base64Encode(imageBytes);
    }

    if (_passwordTEController.text.isNotEmpty) {
      requestBody['password'] = _passwordTEController.text;
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.updateProfileUrl,
      body: requestBody,
    );

    showSnakeBarMessage(context, 'updating....');
    _updateProfileInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      //Method =1 worked perfectly
        AuthController.userModel?.email= _emailTEController.text.trim();
        AuthController.userModel?.firstName= _firstNameTEController.text.trim();
        AuthController.userModel?.lastName= _lastNameTEController.text.trim();

        if (_pickedImage != null) {
          List<int> imageBytes = await _pickedImage!.readAsBytes();
          String base64Photo = base64Encode(imageBytes);
          AuthController.userModel?.photo = base64Photo;
        }

      //Method =2 worked but not instantly

      if (requestBody['photo'] == null) {
          requestBody['photo'] = AuthController.userModel?.photo;
        }

        setState(() {
          AuthController.updateUserData(UserModel.fromJson(requestBody));
        });




        showSnakeBarMessage(context, "Profile updated successfully");
        _passwordTEController.clear();
        setState(() {});

    } else {
      showSnakeBarMessage(context, response.errorMessage);
    }
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
*/
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/looder.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/screen_background.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/show_snakebar_message.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/tm_app_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String name = '/update-profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  File? _pickedImage;
  bool _updateProfileInProgress = false;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot userDoc = await _firestore
          .collection('user_data')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _userData = userDoc.data() as Map<String, dynamic>;
          _emailTEController.text = _userData?['email'] ?? '';
          _firstNameTEController.text = _userData?['firstName'] ?? '';
          _lastNameTEController.text = _userData?['lastName'] ?? '';
          _mobileTEController.text = _userData?['mobile'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: TmAppBar(fromUpdateProfile: true),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(36),
            child: _buildForm(textTheme),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(TextTheme textTheme) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 80),
          Text('Update Profile', style: textTheme.titleLarge),
          SizedBox(height: 24),
          _buildPhotoPicker(),
          SizedBox(height: 8),
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
            decoration: InputDecoration(hintText: 'First Name'),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter Your First Name';
              }
              return null;
            },
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: _lastNameTEController,
            decoration: InputDecoration(hintText: 'Last Name'),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter Your Last Name';
              }
              return null;
            },
          ),
          SizedBox(height: 8),
          TextFormField(
            keyboardType: TextInputType.phone,
            controller: _mobileTEController,
            decoration: InputDecoration(hintText: 'Mobile No'),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter Your Phone No';
              }
              return null;
            },
          ),
          SizedBox(height: 8),
          TextFormField(
            obscureText: true,
            controller: _passwordTEController,
            decoration: InputDecoration(hintText: 'Password (leave empty to keep current)'),
          ),
          SizedBox(height: 24),
          Visibility(
            visible: _updateProfileInProgress == false,
            replacement: CenterCircularProgressIndicator(),
            child: ElevatedButton(
              onPressed: _onTabUpdateProfileBtn,
              child: Icon(Icons.arrow_circle_right_outlined),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                color: Colors.grey,
              ),
              child: const Text('Photo', style: TextStyle(color: Colors.white)),
              alignment: Alignment.center,
            ),
            SizedBox(width: 8),
            Text(
              _pickedImage == null ? 'No image selected' : 'Image selected',
            ),
          ],
        ),
      ),
    );
  }

  void _onTabUpdateProfileBtn() {
    if (_formKey.currentState!.validate()) {
      _updateProfile();
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _updateProfileInProgress = true;
    });

    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        showSnakeBarMessage(context, "No user logged in");
        return;
      }

      // Update password if provided
      if (_passwordTEController.text.isNotEmpty) {
        await user.updatePassword(_passwordTEController.text);
      }

      // Upload image if selected
      String? photoUrl;
      if (_pickedImage != null) {
        final Reference storageRef = _storage
            .ref()
            .child('user_profile_images')
            .child('${user.uid}.jpg');

        final UploadTask uploadTask = storageRef.putFile(_pickedImage!);
        final TaskSnapshot snapshot = await uploadTask;
        photoUrl = await snapshot.ref.getDownloadURL();
      }

      // Prepare update data
      final Map<String, dynamic> updateData = {
        'email': _emailTEController.text.trim(),
        'firstName': _firstNameTEController.text.trim(),
        'lastName': _lastNameTEController.text.trim(),
        'mobile': _mobileTEController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Add photo URL if available
      if (photoUrl != null) {
        updateData['photoUrl'] = photoUrl;
      }

      // Update user document in Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update(updateData);

      showSnakeBarMessage(context, "Profile updated successfully");
      _passwordTEController.clear();

    } catch (e) {
      showSnakeBarMessage(context, "Error updating profile: $e");
    } finally {
      setState(() {
        _updateProfileInProgress = false;
      });
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _passwordTEController.dispose();
    _mobileTEController.dispose();
    super.dispose();
  }
}