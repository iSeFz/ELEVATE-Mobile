import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_page.dart';
import '/custom_widgets/custom_text_form_field.dart';
import '/utils/validations.dart';
import '/utils/main_page.dart';
import '/models/customer.dart';
import '/cubits/customer_cubit.dart';
import '/utils/google_utils.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers if customer data is passed via arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final customerArg =
          ModalRoute.of(context)!.settings.arguments as Customer?;
      if (customerArg != null) {
        _emailController.text = customerArg.email ?? '';
        _usernameController.text = customerArg.username ?? '';
        _firstNameController.text = customerArg.firstName ?? '';
        _lastNameController.text = customerArg.lastName ?? '';
        _phoneNumberController.text = customerArg.phoneNumber ?? '';
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  // Validate the form and send the saved customer object to the main page
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create customer object from controllers
      final customerToSignUp = Customer(
        email: _emailController.text,
        username: _usernameController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNumber: _phoneNumberController.text,
      );

      context.read<CustomerCubit>().signUpUser(
        customerToSignUp,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<CustomerCubit, CustomerState>(
      listener: (context, state) {
        if (state is CustomerRegistered) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: Text(
                  'Success ✅',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                content: Text(
                  'Account created successfully!\nWelcome, ${state.customer.firstName ?? 'User'}!',
                  style: TextStyle(fontSize: 20),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  MainPage(),
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
                          transitionDuration: const Duration(seconds: 1),
                          settings: RouteSettings(arguments: state.customer),
                        ),
                      );
                    },
                    child: Text('OK', style: TextStyle(fontSize: 20)),
                  ),
                ],
              );
            },
          );
        } else if (state is CustomerLoaded) {
          // Show success dialog for Google Sign-Up before navigating
          showDialog(
            context: context,
            barrierDismissible: false, // User must tap OK
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: Text(
                  'Success ✅',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                content: Text(
                  // Assuming state.customer is available in CustomerLoaded state
                  'Account linked with Google successfully!\nWelcome, ${state.customer.firstName ?? 'User'}!',
                  style: TextStyle(fontSize: 20),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainPage(),
                        ),
                        (Route<dynamic> route) => false,
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
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: screenHeight * 0.02,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      'Sign Up',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFA51930),
                        fontSize: screenWidth * 0.1,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Arial',
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    CustomTextFormField(
                      keyboardType: TextInputType.emailAddress,
                      label: 'Email',
                      hint: 'john.doe@gmail.com',
                      controller: _emailController,
                      validationFunc: validateEmail,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextFormField(
                      keyboardType: TextInputType.text,
                      label: 'Username',
                      hint: 'john_doe',
                      controller: _usernameController,
                      validationFunc: validateUsername,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            keyboardType: TextInputType.text,
                            label: 'First Name',
                            hint: 'John',
                            controller: _firstNameController,
                            validationFunc: validateName,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: CustomTextFormField(
                            keyboardType: TextInputType.text,
                            label: 'Last Name',
                            hint: 'Doe',
                            controller: _lastNameController,
                            validationFunc: validateName,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextFormField(
                      keyboardType: TextInputType.phone,
                      label: 'Phone Number',
                      hint: '+201234567890',
                      controller: _phoneNumberController,
                      validationFunc: validatePhoneNumber,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextFormField(
                      isPassword: !_isPasswordVisible,
                      keyboardType: TextInputType.text,
                      label: 'Password',
                      hint: 'Create password',
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
                    SizedBox(height: screenHeight * 0.02),
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
                    SizedBox(height: screenHeight * 0.025),
                    ElevatedButton(
                      onPressed: () => _submitForm(),
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
                            return SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ),
                            );
                          }
                          return const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: Container(height: 1, color: Color(0xFFE6E6E6)),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'or',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Container(height: 1, color: Color(0xFFE6E6E6)),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ElevatedButton(
                      onPressed: () async {
                        final userCredential = await signUpWithGoogle();
                        if (userCredential?.user != null) {
                          final googleUser = userCredential!.user!;
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
                          // This will trigger the listener and navigate if successful
                          context.read<CustomerCubit>().updateCustomer(
                            customerFromGoogle,
                          );
                        } else {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Google Sign-Up failed or was cancelled. Please try again.',
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
                          SizedBox(width: 10),
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
                    SizedBox(height: screenHeight * 0.03),
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
                                    Navigator.pushReplacement(
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
      ),
    );
  }
}
