import 'package:flutter_bloc/flutter_bloc.dart';
import '/../features/auth/data/models/customer.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Customer? _customer;

  // Getters for easier access to customer data
  Customer? get customer => _customer;

  String get fullName => '${_customer!.firstName} ${_customer!.lastName}'.trim();

  String get loyaltyPoints => '${_customer!.loyaltyPoints.toString()} Points';

  // Initialize customer data at the start
  void initializeCustomer(Customer? customer) {
    emit(ProfileLoading());
    try {
      if (customer == null) {
        throw Exception("Customer data is not available");
      }
      // Save a copy of the customer data
      _customer = customer;
      emit(ProfileLoaded());
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
