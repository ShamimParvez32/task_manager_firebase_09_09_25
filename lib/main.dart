import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_firebase_09_09_25/app.dart';
import 'package:task_manager_firebase_09_09_25/data/services/fcm_message_services.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FcmMessageService().initialize();
  FcmMessageService().onTokenRefresh();
  print(await FcmMessageService().getFcmToken());

  runApp(const TaskManagerApp());
}
