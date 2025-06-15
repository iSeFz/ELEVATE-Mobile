class UserAddress {
  String? id;
  String? displayedAddress;
  String? city;
  String? street;
  int? building;
  int? postalCode;
  double? latitude;
  double? longitude;
  bool? isDefault;

  UserAddress({
    required this.id,
    required this.displayedAddress,
    required this.city,
    required this.street,
    required this.building,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
  });

  // Parameterized constructor with null safety
  UserAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    displayedAddress = json['displayedAddress'] ?? '';
    city = json['city'] ?? '';
    street = json['street'] ?? '';
    building = json['building'] ?? 0;
    postalCode = json['postalCode'] ?? 0;
    latitude = json['latitude'] is num ? (json['latitude'] as num).toDouble() : 0.0;
    longitude = json['longitude'] is num ? (json['longitude'] as num).toDouble() : 0.0;
    isDefault = json['isDefault'] ?? false;
  }

  // Getter to return a map of the converted address object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayedAddress': displayedAddress,
      'city': city,
      'street': street,
      'building': building,
      'postalCode': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
    };
  }
}
