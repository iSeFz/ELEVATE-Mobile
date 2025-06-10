import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/../features/auth/data/models/customer.dart';
import 'profile_state.dart';
import '../../data/services/profile_service.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final ProfileService _profileService = ProfileService();
  Customer? _customer;
  Map<String, dynamic>? _customerJSON;

  // Map to track which fields have been changed
  final Map<String, dynamic> _changedFields = {};

  // Form Key and Controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Getters for easier access to customer data
  Customer? get customer => _customer;

  String get fullName => '${_customer!.firstName} ${_customer!.lastName}';

  String get loyaltyPoints => '${_customer!.loyaltyPoints.toString()} Points';

  // Helper method to update text controllers with current customer data
  void _updateControllers() {
    firstNameController.text = _customer?.firstName ?? '';
    lastNameController.text = _customer?.lastName ?? '';
    emailController.text = _customer?.email ?? '';
    phoneController.text = _customer?.phoneNumber ?? '';

    // Reset changed fields tracking
    _changedFields.clear();
  }

  // Initialize customer data and controllers at the start
  void initializeCustomer(Customer? customer) {
    try {
      if (customer == null) {
        throw Exception("Customer data is not available");
      }
      _customer = customer;
      // Create a map of the current customer data as a starting point
      _customerJSON = _customer!.toJson();
      // Initialize controllers with customer data
      _updateControllers();
      emit(ProfileLoaded()); // Emit loaded after data is ready
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  // Method to track field changes
  void fieldChanged(String fieldName, String? value) {
    if (value == null) return;

    // Add to changed fields if different from current value, otherwise remove
    if (value != _customerJSON?[fieldName]?.toString()) {
      _changedFields[fieldName] = value;
    } else {
      _changedFields.remove(fieldName);
    }
  }

  // Method to be called from the UI to trigger form validation and update
  void submitProfileUpdate() async {
    emit(ProfileLoading());
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      // If no fields have been changed, no need to update
      if (_changedFields.isEmpty) {
        emit(ProfileLoaded());
        return;
      }

      // Create an update payload with only the changed fields, preserving the ID
      Map<String, dynamic> customerToUpdate = {'id': _customer!.id};

      // Add changed fields to the update payload
      customerToUpdate.addAll(_changedFields);

      try {
        bool isUpdated = await _profileService.updateCustomer(customerToUpdate);
        if (isUpdated) {
          // Update only the changed fields (overwrite existing values)
          _customerJSON?.addAll(_changedFields);

          // Create a new customer instance with all fields (changed + unchanged)
          _customer = Customer.fromJson(_customerJSON!);

          // Re-initialize controllers to ensure they reflect the latest saved data
          _updateControllers();
          emit(ProfileUpdated());
        } else {
          emit(
            ProfileError(
              message: "Failed to update profile. Please try again.",
            ),
          );
        }
      } catch (e) {
        emit(ProfileError(message: e.toString()));
      }
    }
  }

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    return super.close();
  }
}
