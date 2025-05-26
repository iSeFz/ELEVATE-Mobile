// Model class for the customer object
class Customer {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? username;
  String? password;
  String? phoneNumber;

  // Default constructor
  Customer({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.username,
    this.password,
    this.phoneNumber,
  });

  // Parameterized constructor with null safety
  Customer.fromJson(Map<dynamic, dynamic> map) {
    id = map['id']?.toString();
    email = map['email']?.toString();
    firstName = map['firstName']?.toString();
    lastName = map['lastName']?.toString();
    username = map['username']?.toString();
    password = map['password']?.toString();
    phoneNumber = map['phoneNumber']?.toString();
  }

  // Getter to return a map of the converted customer object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'password': password,
      'phoneNumber': phoneNumber,
    };
  }
}