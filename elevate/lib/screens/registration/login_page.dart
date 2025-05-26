import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/cubits/login/login_cubit.dart';
import '/cubits/login/login_state.dart';
import '/custom_widgets/custom_text_form_field.dart';
import '/utils/main_page.dart';
import '/utils/validations.dart';
import 'sign_up_page.dart';

// Login Page
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(),
      child: Builder(
        builder: (context) {
          final loginCubit = context.read<LoginCubit>();
          return BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess || state is LoginWithGoogleSuccess) {
                String successMessage =
                    state is LoginSuccess
                        ? 'Login successful!\nWelcome back, ${loginCubit.customer?.firstName ?? 'User'}!'
                        : 'Signed in with Google successfully!\nWelcome back, ${loginCubit.customer?.firstName ?? 'User'}!';

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text(
                        'Success ✅',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text(
                        successMessage,
                        style: const TextStyle(fontSize: 20),
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
                                settings: RouteSettings(
                                  arguments: loginCubit.customer,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'OK',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else if (state is LoginFailure) {
                if (ScaffoldMessenger.of(context).mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              }
            },
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                body: Center(
                  child: Form(
                    key: loginCubit.formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          const Text(
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
                            controller: loginCubit.emailController,
                            keyboardType: TextInputType.text,
                            label: 'Email or Phone Number',
                            hint: 'Enter your email or phone number',
                            validationFunc: validateEmailNPhoneNumber,
                          ),
                          const SizedBox(height: 20),
                          BlocBuilder<LoginCubit, LoginState>(
                            builder: (context, state) {
                              return CustomTextFormField(
                                controller: loginCubit.passwordController,
                                isPassword: !(state.isPasswordVisible),
                                keyboardType: TextInputType.text,
                                label: 'Password',
                                hint: 'Enter your password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    state.isPasswordVisible
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                  ),
                                  onPressed: () {
                                    loginCubit.togglePasswordVisibility();
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                          BlocBuilder<LoginCubit, LoginState>(
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed:
                                    state is LoginLoading && state.loginMethod == LoginMethod.form
                                        ? null
                                        : () => loginCubit.submitForm(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 0,
                                ),
                                child:
                                    state is LoginLoading && state.loginMethod == LoginMethod.form
                                        ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                        : const Text(
                                          'Login',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                              );
                            },
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: const Color(0xFFE6E6E6),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
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
                                child: Container(
                                  height: 1,
                                  color: const Color(0xFFE6E6E6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          BlocBuilder<LoginCubit, LoginState>(
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed:
                                    state is LoginLoading && state.loginMethod == LoginMethod.google
                                        ? null
                                        : () async {
                                          loginCubit.signInWithGoogle();
                                        },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade300,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 0,
                                ),
                                child:
                                    state is LoginLoading && state.loginMethod == LoginMethod.google
                                        ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.black,
                                          ),
                                        )
                                        : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                              );
                            },
                          ),
                          const SizedBox(height: 30),
                          Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              children: [
                                const TextSpan(
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                                                  (context) =>
                                                      const SignUpPage(),
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
        },
      ),
    );
  }
}
