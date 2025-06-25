import 'dart:io';
import 'package:elevate/core/services/local_database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '/../features/auth/data/models/customer.dart';
import 'profile_state.dart';
import '../../data/models/address.dart';
import '../../data/services/profile_service.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final ProfileService _profileService = ProfileService();
  Customer? _customer;
  Map<String, dynamic>? _customerJSON;
  List<UserAddress> _addresses = [];
  String? _expandedAddressId;

  // Map to track which fields have been changed
  final Map<String, dynamic> _changedFields = {};

  // Form Key and Controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Address form key and controllers
  final GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  // Getters for easier access to customer data
  Customer? get customer => _customer;
  List<UserAddress> get addresses => _addresses;
  String? get expandedAddressId => _expandedAddressId;

  String get fullName => '${_customer?.firstName} ${_customer?.lastName}';

  String get imageURL => '${_customer?.imageURL}';

  String get loyaltyPoints =>
      '${_customer?.loyaltyPoints == 0 ? "Loyalty" : _customer?.loyaltyPoints.toString()} Points';

  // --- Profile Related Methods ---

  // Helper method to update text controllers with current customer data
  void _updateProfileControllers() {
    firstNameController.text = _customer?.firstName ?? '';
    lastNameController.text = _customer?.lastName ?? '';
    emailController.text = _customer?.email ?? '';
    phoneController.text = _customer?.phoneNumber ?? '';

    // Reset changed fields tracking
    _changedFields.clear();
  }

  // Method to refresh customer data from the database
  Future<void> refreshCustomerData() async {
    try {
      if (_customer?.id == null) {
        throw Exception("Customer ID is not available");
      }

      emit(ProfileLoading());

      // Fetch the latest customer data from the server
      final refreshedCustomer = await _profileService.refreshCustomer(
        _customer!.id!,
      );

      // Update the customer instance with the refreshed data
      initializeCustomer(refreshedCustomer);

      emit(ProfileLoaded());
    } catch (e) {
      emit(
        ProfileError(
          message: "Failed to refresh customer data: ${e.toString()}",
        ),
      );
    }
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
      _updateProfileControllers();

      // Fetch addresses for the customer
      _addresses = _customer?.addresses ?? [];

      for (var address in _addresses) {
        // Set local variables for address display
        address.id = _addresses.indexOf(address).toString();
        address.isDefault = address.id == "0" ? true : false;
        // Initialize address controllers
        _updateAddressControllers(address.id ?? '');
      }

      _expandedAddressId = null; // Reset expanded address state

      emit(ProfileLoaded()); // Emit loaded state after data is ready
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
          _updateProfileControllers();
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

  // --- Profile Photo Related Methods ---

  // Pick an image from the photo library or camera
  Future<void> pickImage(String sourceOption) async {
    try {
      final returnedImage = await ImagePicker().pickImage(
        source:
            sourceOption == "camera" ? ImageSource.camera : ImageSource.gallery,
      );
      if (returnedImage != null) {
        // Save the selected image to the profile
        // Convert the XFile to File by using its path
        saveProfilePhoto(File(returnedImage.path));
      } else {
        emit(ProfileError(message: "No image selected."));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  // Upload the profile photo to the firebase storage
  void saveProfilePhoto(File selectedImage) async {
    emit(ProfileLoading());
    try {
      // Upload the image to Firebase Storage
      String imageURL = await _profileService.uploadProfileImage(
        _customerJSON?['id'],
        selectedImage,
      );

      if (imageURL.isEmpty) {
        emit(ProfileError(message: "Image upload failed."));
        return;
      }

      // Update the changed fields map to trigger the customer update upon save
      fieldChanged("imageURL", imageURL);

      // Emit success state
      emit(ProfilePictureUpdated());
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  // --- Address Related Methods ---

  // Helper method to update text controllers with current address data
  void _updateAddressControllers(String addressID) {
    // Update address controllers with the selected address data
    final address = _addresses.firstWhere((addr) => addr.id == addressID);
    cityController.text = address.city ?? '';
    streetController.text = address.street ?? '';
    buildingController.text = address.building?.toString() ?? '';
    postalCodeController.text = address.postalCode?.toString() ?? '';
    address.displayedAddress =
        "${address.building} ${address.street}, ${address.city}";
  }

  // Toggle the expansion of address cards
  void toggleExpandAddress(String addressID) {
    // If the address is already expanded, clear the controllers and collapse it
    if (_expandedAddressId == addressID) {
      _expandedAddressId = null;
      clearAddressControllers();
    }
    // Otherwise expand the selected address
    _expandedAddressId = addressID;
    // Populate controllers when expanding
    _updateAddressControllers(addressID);
    emit(AddressExpanded());
  }

  Future<void> saveAddress(String addressID) async {
    if (addressFormKey.currentState?.validate() ?? false) {
      addressFormKey.currentState!.save();
      // Implement address save logic
      final index = _addresses.indexWhere((addr) => addr.id == addressID);
      if (index != -1) {
        _addresses[index] = UserAddress(
          id: addressID,
          displayedAddress:
              "${buildingController.text} ${streetController.text}, ${cityController.text}",
          city: cityController.text,
          street: streetController.text,
          building: int.tryParse(buildingController.text),
          postalCode: int.tryParse(postalCodeController.text),
          latitude: _addresses[index].latitude,
          longitude: _addresses[index].longitude,
          isDefault: _addresses[index].isDefault,
        );
      }
      // Mark addresses as changed by providing the full current list
      _changedFields['addresses'] =
          _addresses
              .map(
                (addr) =>
                    addr.toJson()..removeWhere(
                      (key, _) =>
                          key == 'id' ||
                          key == 'displayedAddress' ||
                          key == 'isDefault',
                    ),
              )
              .toList();
      emit(AddressSaved());
    }
  }

  void deleteAddress(String addressID) {
    emit(AddressLoading());
    _addresses.removeWhere((addr) => addr.id == addressID);

    // Mark addresses as changed by providing the full current list
    _changedFields['addresses'] =
        _addresses
            .map(
              (addr) =>
                  addr.toJson()..removeWhere(
                    (key, _) =>
                        key == 'id' ||
                        key == 'displayedAddress' ||
                        key == 'isDefault',
                  ),
            )
            .toList();

    if (_expandedAddressId == addressID) {
      clearAddressControllers();
      _expandedAddressId = null;
    }
    emit(AddressDeleted());
  }

  void addNewAddress() {
    clearAddressControllers();
    emit(AddressLoading());
    // Create a new address with a unique ID
    final newId = (_addresses.length + 1).toString();
    final newAddress = UserAddress(
      id: newId,
      displayedAddress: 'New Address',
      city: '',
      street: '',
      building: 0,
      postalCode: 0,
      latitude: 0,
      longitude: 0,
    );

    // Add the new address to the list
    _addresses.add(newAddress);
    _expandedAddressId = newId;
    emit(AddressExpanded());
  }

  void setDefaultAddress(String addressID) {
    for (var address in _addresses) {
      address.isDefault = address.id == addressID;
    }
    emit(DefaultAddressUpdated());
  }

  void logout() {
    LocalDatabaseService.deleteCustomer();
  }

  void clearAddressControllers() {
    cityController.clear();
    streetController.clear();
    buildingController.clear();
    postalCodeController.clear();
  }

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cityController.dispose();
    streetController.dispose();
    buildingController.dispose();
    postalCodeController.dispose();
    return super.close();
  }
}
