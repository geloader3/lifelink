import 'package:emergencyrespo3712/Features/Login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:emergencyrespo3712/Features/Response%20Screen/emergencies_screen.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'Common Widgets/Onboarding.dart';
import 'Features/User/Screens/Signup/verify_email_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: user == null ? const LoginScreen() : const VerifyEmailPage(),
      // home:const EmergenciesScreen(),
    );
  }
}
