import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/common/splash_screen.dart';
import 'core/utils/size_config.dart';
import 'firebase_options.dart'; // <-- Add this

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // <-- Important fix
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      title: 'ELEVATE',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Color(0xFFA51930),
          secondary: Colors.black,
          tertiary: Color(0xFFE8BBC2),
        ),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
