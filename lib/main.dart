import 'package:flutter/material.dart';
import 'package:secure_vault_app/core/messaging/firebase_messaging_service.dart';
import 'package:secure_vault_app/firebase_options.dart';
import 'app/app.dart';
import 'app/di/injector.dart' as di;
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessagingService.config();

  await di.initDependencies();
  runApp(const App());
}
