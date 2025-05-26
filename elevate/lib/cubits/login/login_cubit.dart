import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/../constants/app_constants.dart';
import '/../models/customer.dart';
import '/../utils/google_utils.dart';
import 'login_state.dart';

// Login Cubit
class LoginCubit extends Cubit<LoginState> {
  Customer? _customer;
  Customer? get customer => _customer;

  // Hold current visibility state within the Cubit
  bool _isPasswordVisible = false;

  // Fields for form and controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginCubit() : super(LoginInitial(isPasswordVisible: false));

  // Dispose controllers
  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }

  // Submit form
  Future<void> submitForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      await loginUser(emailController.text, passwordController.text);
    }
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    emit(LoginPasswordVisibilityChanged(isPasswordVisible: _isPasswordVisible));
  }

  Future<void> loginUser(String email, String password) async {
    emit(LoginLoading(isPasswordVisible: _isPasswordVisible, loginMethod: LoginMethod.form));
    try {
      final response = await http.post(
        Uri.parse("$apiBaseURL/v1/customers/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if ((response.statusCode == 200) && responseData['status'] == 'success') {
        final customerJsonFromServer = responseData['data']['user'];

        if (customerJsonFromServer != null) {
          _customer = Customer.fromJson(customerJsonFromServer);

          emit(LoginSuccess());
        } else {
          emit(
            LoginFailure(
              message:
                  responseData['message'] ?? 'User data not found in response',
              isPasswordVisible: _isPasswordVisible,
            ),
          );
        }
      } else {
        emit(
          LoginFailure(
            message:
                responseData['error'] ??
                responseData['message'] ??
                'Login failed',
            isPasswordVisible: _isPasswordVisible,
          ),
        );
      }
    } catch (e) {
      emit(
        LoginFailure(
          message: 'Failed to login: ${e.toString()}',
          isPasswordVisible: _isPasswordVisible,
        ),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    emit(LoginLoading(isPasswordVisible: _isPasswordVisible, loginMethod: LoginMethod.google));
    try {
      UserCredential? userCredential = await getGoogleUserCredential();
      if (userCredential == null || userCredential.user == null) {
        emit(
          LoginFailure(
            message: 'Google Sign-In was cancelled or failed.',
            isPasswordVisible: _isPasswordVisible,
          ),
        );
        return;
      }

      final userID = userCredential.user!.uid;

      // Retrieve user data from database using the userID
      final response = await http.get(
        Uri.parse("$apiBaseURL/v1/customers/me?userId=$userID"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          testAuthHeader: testAuthValue,
        },
      );

      final responseData = jsonDecode(response.body);

      if ((response.statusCode == 200) && responseData['status'] == 'success') {
        final customerJsonFromServer = responseData['data'];

        if (customerJsonFromServer != null) {
          _customer = Customer.fromJson(customerJsonFromServer);

          emit(LoginWithGoogleSuccess());
        } else {
          emit(
            LoginFailure(
              message:
                  responseData['message'] ?? 'User data not found in response',
              isPasswordVisible: _isPasswordVisible,
            ),
          );
        }
      }
    } catch (e) {
      emit(
        LoginFailure(
          message: 'Google Sign-In failed: ${e.toString()}',
          isPasswordVisible: _isPasswordVisible,
        ),
      );
    }
  }
}
