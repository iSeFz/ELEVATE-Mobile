import 'package:flutter/material.dart';
import 'sign_up_page.dart';
import '/custom_widgets/custom_text_form_field.dart';
import '/utils/validations.dart';
import '/utils/google_sign_in_util.dart';
import '/utils/main_page.dart';
import '/models/customer.dart';

// Create Account Page
class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

// Display different ways to create an account
// Using email, Google, or Apple
class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final Customer customer = Customer();

  // Validate the form and send the saved customer object to the main page
  Future<void> _submitForm(Customer customer) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (mounted) {
        // Navigate to the sign up form
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => SignUpPage(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              // Add fade transition to the SignUp screen
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(seconds: 1),
            settings: RouteSettings(arguments: customer),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    'ELEVATE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFA51930),
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arial',
                    ),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    'Create an account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Arial',
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    keyboardType: TextInputType.emailAddress,
                    label: 'Enter your email',
                    hint: 'john.doe@gmail.com',
                    onSaved: (value) => customer.email = value,
                    validationFunc: validateEmail,
                  ),
                  const SizedBox(height: 20),
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
                      'Continue',
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
                    onPressed: () async {
                      // Sign in with Google and save the returned credentials
                      final userCredential = await signInWithGoogle();
                      // Set customer info based on the returned user credentials
                      setCustomerInfo(userCredential, customer);
                      // Show a success message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Success ✅',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              'Account created successfuly!\nWelcome, ${customer.firstName}!',
                              style: TextStyle(fontSize: 20),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Navigate to the main page if signed up successfully
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => MainPage(),
                                      transitionsBuilder: (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        // Add fade transition to the main page
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                      transitionDuration: const Duration(
                                        seconds: 1,
                                      ),
                                      settings: RouteSettings(
                                        arguments: customer,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'OK',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
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
                          text: 'By clicking continue, you agree to our ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: ' and ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
