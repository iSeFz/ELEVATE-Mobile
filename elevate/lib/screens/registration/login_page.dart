import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/customer_cubit.dart';
import 'sign_up_page.dart';
import '/models/customer.dart';
import '/utils/main_page.dart';
import '/utils/validations.dart';
import '/utils/google_utils.dart';
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

  // Validate the form and trigger login via CustomerCubit
  Future<void> _submitForm(Customer customer) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Call CustomerCubit to login
      context.read<CustomerCubit>().loginUser(
        customer.email!,
        customer.password!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Customer customer =
        ModalRoute.of(context)!.settings.arguments as Customer? ?? Customer();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: BlocListener<CustomerCubit, CustomerState>(
          listener: (context, state) {
            if (state is CustomerLoggedIn) {
              // Show success dialog for email/password login
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: Text(
                      'Success ✅',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      'Login successful!\nWelcome back, ${state.customer.firstName ?? 'User'}!',
                      style: TextStyle(fontSize: 20),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // Dismiss dialog
                          Navigator.pushAndRemoveUntil(
                            context, // Use the original context for navigation
                            MaterialPageRoute(
                              builder: (context) => const MainPage(),
                            ),
                            (Route<dynamic> route) =>
                                false, // Clears the navigation stack
                          );
                        },
                        child: Text('OK', style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  );
                },
              );
            } else if (state is CustomerLoaded) {
              // Handle Google Sign-In success (after updateCustomer)
              // This state is triggered after updateCustomer for Google Sign-In
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: Text(
                      'Success ✅',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      'Signed in with Google successfully!\nWelcome back, ${state.customer.firstName ?? 'User'}!',
                      style: TextStyle(fontSize: 20),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // Dismiss dialog
                          Navigator.pushAndRemoveUntil(
                            context, // Use the original context for navigation
                            MaterialPageRoute(
                              builder: (context) => const MainPage(),
                            ),
                            (Route<dynamic> route) =>
                                false, // Clears the navigation stack
                          );
                        },
                        child: Text('OK', style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  );
                },
              );
            } else if (state is CustomerError) {
              if (mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            }
          },
          child: Center(
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
                      // validationFunc: validatePassword,
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
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: BlocBuilder<CustomerCubit, CustomerState>(
                        builder: (context, state) {
                          if (state is CustomerLoading) {
                            return const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            );
                          }
                          return const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
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
                        final userCredential = await signUpWithGoogle();
                        // Ensure userCredential and user are not null
                        if (userCredential?.user != null) {
                          final googleUser = userCredential!.user!;
                          // Create a Customer object from Google user info
                          final customerFromGoogle = Customer(
                            id: googleUser.uid,
                            email: googleUser.email,
                            firstName:
                                googleUser.displayName?.split(' ').first ?? '',
                            lastName:
                                googleUser.displayName != null &&
                                        googleUser.displayName!
                                                .split(' ')
                                                .length >
                                            1
                                    ? googleUser.displayName!
                                        .split(' ')
                                        .sublist(1)
                                        .join(' ')
                                    : '',
                            username:
                                googleUser.email?.split('@').first ??
                                googleUser.uid,
                          );

                          if (!mounted) return;
                          // Update the CustomerCubit with the Google user info
                          context.read<CustomerCubit>().updateCustomer(
                            customerFromGoogle,
                          );
                        } else {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Google Sign-In failed or was cancelled. Please try again.',
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/google.png',
                            width: 24,
                            height: 24,
                          ),
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
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const SignUpPage(),
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
      ),
    );
  }
}
