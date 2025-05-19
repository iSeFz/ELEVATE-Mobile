// Model class for the customer object
class Customer {
  String? id; // Added id field
  String? email;
  String? firstName;
  String? lastName;
  String? username;
  String? password;
  String? phoneNumber;

  // Default constructor
  Customer({
    this.id, // Added id to constructor
    this.email,
    this.firstName,
    this.lastName,
    this.username,
    this.password,
    this.phoneNumber,
  });

  // Parameterized constructor
  Customer.fromMap(Map<dynamic, dynamic> map) {
    id = map['id']?.toString() ?? map['_id']?.toString(); // Handle 'id' or '_id'
    email = map['email'];
    firstName = map['firstName'];
    lastName = map['lastName'];
    username = map['username'];
    password = map['password'];
    phoneNumber = map['phoneNumber'];
  }

  // Getter to return a map of the converted customer object
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Added id to map
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'password': password,
      'phoneNumber': phoneNumber,
    };
  }
}