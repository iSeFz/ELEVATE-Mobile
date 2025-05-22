import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elevate/models/customer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define the states for the CustomerCubit
abstract class CustomerState {}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final Customer customer;
  CustomerLoaded(this.customer);
}

class CustomerLoggedIn extends CustomerState {
  final Customer customer;
  CustomerLoggedIn(this.customer);
}

class CustomerRegistered extends CustomerState {
  final Customer customer;
  CustomerRegistered(this.customer);
}

class CustomerError extends CustomerState {
  final String message;
  CustomerError(this.message);
}

// Define the CustomerCubit
class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit() : super(CustomerInitial());

  Future<void> loginUser(String email, String password) async {
    emit(CustomerLoading());
    try {
      final response = await http.post(
        Uri.parse('https://elevate-gp.vercel.app/api/v1/customers/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        final customerData = responseData['data']?['user'];
        if (customerData != null) {
          final customer = Customer(
            id: customerData['id']?.toString(),
            email: customerData['email'],
            firstName: customerData['firstName'],
            lastName: customerData['lastName'],
            username: customerData['username'],
            phoneNumber: customerData['phoneNumber'],
          );
          emit(CustomerLoggedIn(customer));
        } else {
          emit(
            CustomerError(
              responseData['message'] ?? 'User data not found in response',
            ),
          );
        }
      } else {
        emit(
          CustomerError(
            responseData['error'] ?? responseData['message'] ?? 'Login failed',
          ),
        );
      }
    } catch (e) {
      emit(CustomerError('Failed to login: ${e.toString()}'));
    }
  }

  Future<void> signUpUser(Customer customerData, String password) async {
    emit(CustomerLoading());
    try {
      final response = await http.post(
        Uri.parse('https://elevate-gp.vercel.app/api/v1/customers/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String?>{
          'email': customerData.email,
          'password': password,
          'firstName': customerData.firstName,
          'lastName': customerData.lastName,
          'username': customerData.username,
          'phoneNumber': customerData.phoneNumber,
        }),
      );

      final responseData = jsonDecode(response.body);

      if ((response.statusCode == 201 || response.statusCode == 200) &&
          responseData['status'] == 'success') {
        final newCustomerData = responseData['data']?['user'];
        if (newCustomerData != null) {
          final customer = Customer(
            id:
                newCustomerData['_id']?.toString() ??
                newCustomerData['id']?.toString(),
            email: newCustomerData['email'],
            firstName: newCustomerData['firstName'],
            lastName: newCustomerData['lastName'],
            username: newCustomerData['username'],
          );
          emit(CustomerRegistered(customer));
        } else {
          emit(
            CustomerError(
              responseData['message'] ??
                  'User data not found in signup response',
            ),
          );
        }
      } else {
        emit(
          CustomerError(
            responseData['error'] ?? responseData['message'] ?? 'Signup failed',
          ),
        );
      }
    } catch (e) {
      emit(CustomerError('Failed to sign up: ${e.toString()}'));
    }
  }

  // Method to fetch/update customer data (can be used for profile loading etc.)
  void fetchCustomer() {
    if (state is CustomerLoaded) {
      // If customer data is already loaded, no need to fetch again unless forced
      return;
    }
    if (state is CustomerLoggedIn) {
      // If customer data is already loaded, no need to fetch again unless forced
      return;
    }
    emit(CustomerLoading());
    // Simulate API call or data retrieval for a generic fetch
    // This might be used if the user is already logged in and we need to refresh their data
    // For now, it creates a default user if no one is loaded.
    final customer = Customer(
      email: 'default.user@example.com',
      firstName: 'Default',
      lastName: 'User',
      username: 'defaultuser',
    );
    emit(CustomerLoaded(customer));
  }

  void updateCustomer(Customer customer) {
    emit(CustomerLoaded(customer));
  }

  void clearCustomer() {
    emit(CustomerInitial());
  }
}
