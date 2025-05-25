import 'package:elevate/screens/home_page.dart';
import 'package:elevate/screens/product_details_page.dart';
import 'package:elevate/screens/Reviews.dart';
import 'package:elevate/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/customer_cubit.dart';

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
    return BlocProvider<CustomerCubit>(
      create: (_) => CustomerCubit(),
      child: MaterialApp(
        title: 'ELEVATE',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFA51930)),
        ),
        home:  SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
