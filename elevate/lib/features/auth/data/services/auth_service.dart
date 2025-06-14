import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/constants/constants.dart';
import '../models/customer.dart';
import '../../../../core/utils/google_utils.dart';

class AuthService {
  Future<Customer?> registerUser(Customer customerData) async {
    final response = await http.post(
      Uri.parse("$apiBaseURL/v1/customers/signup"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        customerData.toJson()
          ..removeWhere((key, _) => key == 'id' || key == 'loyaltyPoints'),
      ),
    );

    final responseData = jsonDecode(response.body);

    if ((response.statusCode == 201) && responseData['status'] == 'success') {
      final customerJsonFromServer = responseData['data'];

      if (customerJsonFromServer != null) {
        return Customer(
          id: customerJsonFromServer['id'],
          email: customerJsonFromServer['email'],
          username: customerData.username,
          firstName: customerData.firstName,
          lastName: customerData.lastName,
          phoneNumber: customerData.phoneNumber,
        );
      } else {
        throw Exception(
          responseData['message'] ?? 'User data not found in signup response',
        );
      }
    } else {
      throw Exception(
        responseData['error'] ?? responseData['message'] ?? 'Signup failed',
      );
    }
  }

  Future<Customer?> signUpWithGoogle() async {
    UserCredential? userCredential = await getGoogleUserCredential();
    if (userCredential == null || userCredential.user == null) {
      throw Exception('Google Sign-Up was cancelled or failed.');
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
        return customerFromGoogle;
      } else {
        throw Exception(
          responseData['message'] ??
              'Failed to register Google user with backend.',
        );
      }
    } else {
      // If user already exists, just return their data
      // Potentially fetch updated data from backend if necessary
      return customerFromGoogle;
    }
  }

  Future<Customer?> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse("$apiBaseURL/v1/customers/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );

    final responseData = jsonDecode(response.body);

    if ((response.statusCode == 200) && responseData['status'] == 'success') {
      final customerJsonFromServer = responseData['data']['user'];

      if (customerJsonFromServer != null) {
        return Customer.fromJson(customerJsonFromServer);
      } else {
        throw Exception(
          responseData['message'] ?? 'User data not found in response',
        );
      }
    } else {
      throw Exception(
        responseData['error'] ?? responseData['message'] ?? 'Login failed',
      );
    }
  }

  Future<Customer?> signInWithGoogleLogin() async {
    UserCredential? userCredential = await getGoogleUserCredential();
    if (userCredential == null || userCredential.user == null) {
      throw Exception('Google Sign-In was cancelled or failed.');
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
        return Customer.fromJson(customerJsonFromServer);
      } else {
        throw Exception(
          responseData['message'] ?? 'User data not found in response',
        );
      }
    } else {
      throw Exception(
        'Failed to get user data from backend: ${responseData['message']}',
      );
    }
  }
}
