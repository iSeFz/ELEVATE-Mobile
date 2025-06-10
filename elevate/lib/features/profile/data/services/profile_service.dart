import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/constants/constants.dart';

class ProfileService {
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
}
