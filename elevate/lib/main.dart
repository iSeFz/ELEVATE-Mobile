import 'package:elevate/screens/Product_Details.dart';
import 'package:elevate/screens/Reviews.dart';
import 'package:elevate/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/BrandProfile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/user_provider.dart';
import 'package:provider/provider.dart';

// Main function to start the run
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

// Main app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        title: 'ELEVATE',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFA51930)),
        ),
        home:  ProductDetails(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
