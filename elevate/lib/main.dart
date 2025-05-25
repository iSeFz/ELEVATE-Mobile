import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/customer_cubit.dart';
import 'utils/size_config.dart';

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
        colorScheme: ColorScheme.light(
        primary: Color(0xFFA51930), secondary: Colors.black, tertiary: Color(0xFFE8BBC2),// your exact color
        ),),
        home:  SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
