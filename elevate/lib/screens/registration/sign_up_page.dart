import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';
import '/custom_widgets/custom_text_form_field.dart';
import '/utils/validations.dart';
import '/utils/main_page.dart';
import '/models/customer.dart';

// Sign Up Page
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

// Display needed fields to sign up for a new account
class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String jsonResponse = "";

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  // Send a POST request to the server to sign up a new customer
  Future<bool> signUpRequest(Customer customer) async {
    final response = await http.post(
      Uri.parse('https://elevate-gp.vercel.app/api/v1/customers/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': customer.username!,
        'email': customer.email!,
        'firstName': customer.firstName!,
        'lastName': customer.lastName!,
        'phoneNumber': customer.phoneNumber!,
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
      bool successfulResponse = await signUpRequest(customer);

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
                  'Account created successfuly!\nWelcome, ${jsonDecode(jsonResponse)['data']['firstName']}!',
                  style: TextStyle(fontSize: 20),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Navigate to the main page if signed up successfully
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
                    'Sign Up',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFA51930),
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arial',
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomTextFormField(
                    keyboardType: TextInputType.emailAddress,
                    label: 'Email',
                    hint: 'john.doe@gmail.com',
                    initialValue: customer.email,
                    onChanged: (value) => customer.email = value,
                    validationFunc: validateEmail,
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    keyboardType: TextInputType.text,
                    label: 'First Name',
                    hint: 'John',
                    onSaved: (value) => customer.firstName = value,
                    validationFunc: validateName,
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    keyboardType: TextInputType.text,
                    label: 'Last Name',
                    hint: 'Doe',
                    onSaved: (value) => customer.lastName = value,
                    validationFunc: validateName,
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    keyboardType: TextInputType.text,
                    label: 'Username',
                    hint: 'john_doe',
                    onSaved: (value) => customer.username = value,
                    validationFunc: validateUsername,
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    keyboardType: TextInputType.phone,
                    label: 'Phone Number',
                    hint: '+201234567890',
                    onSaved: (value) => customer.phoneNumber = value,
                    validationFunc: validatePhoneNumber,
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    isPassword: !_isPasswordVisible,
                    keyboardType: TextInputType.text,
                    label: 'Password',
                    hint: 'Create password',
                    onSaved: (value) => customer.password = value,
                    validationFunc: validatePassword,
                    controller: _passwordController,
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
                  CustomTextFormField(
                    isPassword: !_isConfirmPasswordVisible,
                    keyboardType: TextInputType.text,
                    label: 'Confirm Password',
                    hint: 'Confirm Password',
                    validationFunc: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      } else if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      } else {
                        return null;
                      }
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
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
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: 'Login',
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
                                          ) => LoginPage(),
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
