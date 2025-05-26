import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/../constants/app_constants.dart';
import '/../models/customer.dart';
import '/../utils/google_utils.dart';
import 'sign_up_state.dart';

// Sign Up Cubit
class SignUpCubit extends Cubit<SignUpState> {
  Customer? _customer;
  Customer? get customer => _customer;

  // Hold current visibility state within the Cubit
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Fields for form and controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpCubit()
    : super(
        SignUpInitial(
          isPasswordVisible: false,
          isConfirmPasswordVisible: false,
        ),
      );

  // Dispose controllers
  void disposeControllers() {
    emailController.dispose();
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
  }

  // Submit form
  Future<void> submitForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final customerToSignUp = Customer(
        email: emailController.text,
        username: usernameController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        phoneNumber: phoneNumberController.text,
        password: passwordController.text,
      );
      await registerUser(customerToSignUp);
    }
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    emit(
      SignUpPasswordVisibilityChanged(
        isPasswordVisible: _isPasswordVisible,
        isConfirmPasswordVisible: _isConfirmPasswordVisible,
      ),
    );
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    emit(
      SignUpPasswordVisibilityChanged(
        isPasswordVisible: _isPasswordVisible,
        isConfirmPasswordVisible: _isConfirmPasswordVisible,
      ),
    );
  }

  Future<void> registerUser(Customer customerData) async {
    // Pass current visibility to loading and failure states
    emit(
      SignUpLoading(
        isPasswordVisible: _isPasswordVisible,
        isConfirmPasswordVisible: _isConfirmPasswordVisible,
        signUpMethod: SignUpMethod.form,
      ),
    );
    try {
      final response = await http.post(
        Uri.parse("$apiBaseURL/v1/customers/signup"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(customerData.toJson()),
      );

      final responseData = jsonDecode(response.body);

      if ((response.statusCode == 201) && responseData['status'] == 'success') {
        final customerJsonFromServer = responseData['data'];

        if (customerJsonFromServer != null) {
          _customer = Customer(
            id: customerJsonFromServer['id'],
            email: customerJsonFromServer['email'],
            username: customerData.username,
            firstName: customerData.firstName,
            lastName: customerData.lastName,
            phoneNumber: customerData.phoneNumber,
          );

          emit(SignUpSuccess());
        } else {
          emit(
            SignUpFailure(
              message:
                  responseData['message'] ??
                  'User data not found in signup response',
              isPasswordVisible: _isPasswordVisible,
              isConfirmPasswordVisible: _isConfirmPasswordVisible,
            ),
          );
        }
      } else {
        emit(
          SignUpFailure(
            message:
                responseData['error'] ??
                responseData['message'] ??
                'Signup failed',
            isPasswordVisible: _isPasswordVisible,
            isConfirmPasswordVisible: _isConfirmPasswordVisible,
          ),
        );
      }
    } catch (e) {
      emit(
        SignUpFailure(
          message: 'Failed to sign up: ${e.toString()}',
          isPasswordVisible: _isPasswordVisible,
          isConfirmPasswordVisible: _isConfirmPasswordVisible,
        ),
      );
    }
  }

  Future<void> signUpWithGoogle() async {
    emit(
      SignUpLoading(
        isPasswordVisible: _isPasswordVisible,
        isConfirmPasswordVisible: _isConfirmPasswordVisible,
        signUpMethod: SignUpMethod.google,
      ),
    );
    try {
      UserCredential? userCredential = await getGoogleUserCredential();
      if (userCredential == null || userCredential.user == null) {
        emit(
          SignUpFailure(
            message: 'Google Sign-Up was cancelled or failed.',
            isPasswordVisible: _isPasswordVisible,
            isConfirmPasswordVisible: _isConfirmPasswordVisible,
          ),
        );
        return;
      }

      final user = userCredential.user!;
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      // Prepare customer data from Google sign-in
      final customerFromGoogle = Customer(
        id: user.uid,
        email: user.email,
        firstName: user.displayName?.split(' ').first ?? '',
        lastName:
            user.displayName != null && user.displayName!.split(' ').length > 1
                ? user.displayName!.split(' ').sublist(1).join(' ')
                : '',
        username: user.email?.split('@').first ?? '',
      );

      _customer = customerFromGoogle;

      if (isNewUser) {
        final response = await http.post(
          Uri.parse('$apiBaseURL/v1/customers/third-party-signup'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String?>{
            'uid': user.uid,
            'email': user.email,
          }),
        );

        final responseData = jsonDecode(response.body);
        if (response.statusCode == 201 && responseData['status'] == 'success') {
          emit(SignUpWithGoogleSuccess());
        } else {
          emit(
            SignUpFailure(
              message:
                  responseData['message'] ??
                  'Failed to register Google user with backend.',
              isPasswordVisible: _isPasswordVisible,
              isConfirmPasswordVisible: _isConfirmPasswordVisible,
            ),
          );
          return;
        }
      } else {
        emit(SignUpWithGoogleSuccess());
      }
    } catch (e) {
      emit(
        SignUpFailure(
          message: 'Google Sign-Up failed: ${e.toString()}',
          isPasswordVisible: _isPasswordVisible,
          isConfirmPasswordVisible: _isConfirmPasswordVisible,
        ),
      );
    }
  }
}
