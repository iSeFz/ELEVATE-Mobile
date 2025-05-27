import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/customer.dart';
import '../../../data/services/auth_service.dart';
import 'login_state.dart';

// Login Cubit
class LoginCubit extends Cubit<LoginState> {
  final AuthService _authService = AuthService();
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
    emit(
      LoginLoading(
        isPasswordVisible: _isPasswordVisible,
        loginMethod: LoginMethod.form,
      ),
    );
    try {
      _customer = await _authService.loginUser(email, password);
      if (_customer != null) {
        emit(LoginSuccess());
      } else {
        emit(
          LoginFailure(
            message: 'Login failed: No user data returned',
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
    emit(
      LoginLoading(
        isPasswordVisible: _isPasswordVisible,
        loginMethod: LoginMethod.google,
      ),
    );
    try {
      _customer = await _authService.signInWithGoogleLogin();
      if (_customer != null) {
        emit(LoginWithGoogleSuccess());
      } else {
        emit(
          LoginFailure(
            message: 'Google Sign-In failed: No user data returned.',
            isPasswordVisible: _isPasswordVisible,
          ),
        );
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
