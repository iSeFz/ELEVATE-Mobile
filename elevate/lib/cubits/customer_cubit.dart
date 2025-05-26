import 'package:elevate/constants/app_constants.dart';
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
        Uri.parse('$apiBaseURL/v1/customers/login'),
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
          final customer = Customer.fromJson(customerData);
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

  Future<void> signUpUser(Customer customerData) async {
    emit(CustomerLoading());
    try {
      final response = await http.post(
        Uri.parse("$apiBaseURL/v1/customers/signup"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({...customerData.toJson()}),
      );

      final responseData = jsonDecode(response.body);

      if ((response.statusCode == 201 || response.statusCode == 200) &&
          responseData['status'] == 'success') {
        final newCustomerData = responseData['data'];
        if (newCustomerData != null) {
          final customerId = newCustomerData['id'];
          if (customerId != null) {
            final customerJson = customerData.toJson();
            customerJson['id'] = customerId;
            customerData = Customer.fromJson(customerJson);
          }

          emit(CustomerRegistered(customerData));
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

  void updateCustomer(Customer customer) {
    emit(CustomerLoaded(customer));
  }

  void clearCustomer() {
    emit(CustomerInitial());
  }
}
