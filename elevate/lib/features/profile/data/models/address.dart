class UserAddress {
  String id;
  String displayedAddress;
  String city;
  String street;
  String building;
  String postalCode;
  String latitude;
  String longitude;
  bool isDefault;

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
}
