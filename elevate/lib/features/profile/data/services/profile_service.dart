import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../auth/data/models/customer.dart';
import '../../../../core/constants/constants.dart';

class ProfileService {
  // Fetch the latest customer data from the server
  Future<Customer> refreshCustomer(String customerID) async {
    try {
      final response = await http.get(
        Uri.parse("$apiBaseURL/v1/customers/me?userId=$customerID"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          testAuthHeader: testAuthValue,
        },
      );

      final responseData = jsonDecode(response.body);

      // Return the latest customer data if the fetch was successful
      if (response.statusCode == 200 && responseData['status'] == 'success') {
        final customerData = json.decode(response.body);
        return Customer.fromJson(customerData['data']);
      } else {
        throw Exception('Failed to load customer data');
      }
    } catch (e) {
      throw Exception('Error updating user profile: $e');
    }
  }

  // Update the customer profile with the provided updated customer JSON
  Future<bool> updateCustomer(Map<String, dynamic> updatedCustomerJSON) async {
    // Take a copy from the updated customer JSON passed to preserve its data
    // Any adjustments needed for the request is done on this copy
    Map<String, dynamic> customerRequestBody = updatedCustomerJSON;
    try {
      final response = await http.put(
        Uri.parse(
          "$apiBaseURL/v1/customers/me?userId=${customerRequestBody['id']}",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          testAuthHeader: testAuthValue,
        },
        // Remove the 'id' field from the request body as it can not be updated
        body: json.encode(customerRequestBody..remove('id')),
      );

      // Return true if the update was done successfully
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error updating user profile: $e');
    }
  }

  // Upload the customer profile image to the firebase storage and get an imageURL
  Future<String> uploadProfileImage(
    String customerID,
    File selectedImage,
  ) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
        'profile-images/${customerID}_${DateTime.now().millisecondsSinceEpoch}_pfp.png',
      );

      // Upload the file to Firebase Storage
      final uploadTask = storageRef.putFile(selectedImage);
      final snapshot = await uploadTask.whenComplete(() {});
      // Get the download URL of the uploaded image
      final downloadURL = await snapshot.ref.getDownloadURL();
      // Return the download URL of the uploaded image
      return downloadURL;
    } catch (e) {
      throw Exception('Error updating profile image: $e');
    }
  }
}
