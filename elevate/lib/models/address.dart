class UserAddress {
  String id;
  String city;
  String street;
  String building;
  bool isDefault;

  UserAddress({
    required this.id,
    required this.city,
    required this.street,
    required this.building,
    this.isDefault = false,
  });
}
