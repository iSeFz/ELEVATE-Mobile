import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'sign_up_page.dart';
import '/models/customer.dart';
import '/utils/main_page.dart';
import '/utils/validations.dart';
import '/custom_widgets/custom_text_form_field.dart';

// Login Page
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Display needed fields to sign in for an existing account
class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  String jsonResponse = "";

  // Send a POST request to the server to login an existing customer
  Future<bool> loginRequest(Customer customer) async {
    final response = await http.post(
      Uri.parse('https://elevate-gp.vercel.app/api/v1/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': customer.email!,
        'password': customer.password!,
      }),
    );

    // Store the response in a variable to access it later
    jsonResponse = response.body;

    // Check if the response is successful
    if (response.statusCode == 200) {
      return jsonDecode(response.body.toString())['status'] == 'success';
    }
    return false;
  }

  // Validate the form and send the saved customer object to the main page
  Future<void> _submitForm(Customer customer) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Send a POST request to the server to sign up the customer
      bool successfulResponse = await loginRequest(customer);

      // Check if the widget is mounted before showing the dialog
      if (mounted) {
        if (successfulResponse) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Success ✅',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                content: Text(
                  'Login successful!',
                  style: TextStyle(fontSize: 20),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Navigate to the main page if logged in successfully
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => MainPage(),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            // Add fade transition to the main page
                            return FadeTransition(opacity: animation, child: child);
                          },
                          transitionDuration: const Duration(seconds: 1),
                          settings: RouteSettings(arguments: customer),
                        ),
                      );
                    },
                    child: Text('OK', style: TextStyle(fontSize: 20)),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Error ❌',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                content: Text(
                  jsonDecode(jsonResponse)['error'],
                  style: TextStyle(fontSize: 20),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK', style: TextStyle(fontSize: 20)),
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Customer customer = ModalRoute.of(context)!.settings.arguments as Customer? ?? Customer();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFA51930),
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arial',
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    keyboardType: TextInputType.text,
                    label: 'Email or Phone Number',
                    hint: 'Enter your email or phone number',
                    onSaved: (value) => customer.email = value,
                    validationFunc: validateEmailNPhoneNumber,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    isPassword: !_isPasswordVisible,
                    keyboardType: TextInputType.text,
                    label: 'Password',
                    hint: 'Enter your password',
                    onSaved: (value) => customer.password = value,
                    validationFunc: validatePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () => _submitForm(customer),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Container(height: 1, color: Color(0xFFE6E6E6)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'or',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontFamily: 'Arial',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(height: 1, color: Color(0xFFE6E6E6)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => print('Continue with Google'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/google.png', width: 24, height: 24),
                        const SizedBox(width: 10),
                        const Text(
                          'Continue with Google',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () => print('Continue with Apple'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/apple.png', width: 24, height: 24),
                        const SizedBox(width: 10),
                        const Text(
                          'Continue with Apple',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Don\'t have an account? ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => SignUpPage(),
                                      transitionsBuilder: (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                      transitionDuration: const Duration(
                                        seconds: 1,
                                      ),
                                    ),
                                  );
                                },
                        ),
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
}
