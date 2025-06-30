import '../../../cart/data/models/cart_item.dart';
import 'address.dart';

// Function to parse date
DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is String) return DateTime.tryParse(value);
  if (value is Map && value.containsKey('_seconds')) {
    return DateTime.fromMillisecondsSinceEpoch(value['_seconds'] * 1000);
  }
  return null;
}

class Order {
  String? id;
  String? customerId;
  String? status;
  UserAddress? address;
  String? phoneNumber;
  int? pointsRedeemed;
  int? pointsEarned;
  double? price;
  List<CartItem>? products;
  String? paymentMethod;
  Shipment? shipment;
  DateTime? createdAt;
  DateTime? updatedAt;

  Order({
    this.id,
    this.customerId,
    this.status,
    this.address,
    this.phoneNumber,
    this.pointsRedeemed,
    this.pointsEarned,
    this.price,
    this.products,
    this.paymentMethod,
    this.shipment,
    this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerId: json['customerId'],
      status: json['status'],
      address: json['address'] != null ? UserAddress.fromJson(json['address']) : null,
      phoneNumber: json['phoneNumber'],
      pointsRedeemed: json['pointsRedeemed'],
      pointsEarned: json['pointsEarned'],
      price: json['price'] is num ? (json['price'] as num).toDouble() : null,
      products: json['products'] != null
          ? (json['products'] as List<dynamic>)
              .map((product) => CartItem.fromJson(product))
              .toList()
          : null,
      paymentMethod: "Cash on Delivery",
      shipment: json['shipment'] != null ? Shipment.fromJson(json['shipment']) : null,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }
}

class Shipment {
  DateTime? createdAt;
  DateTime? deliveredAt;
  double? fees;
  String? method;
  String? trackingNumber;
  String? carrier;

  Shipment({
    this.createdAt,
    this.deliveredAt,
    this.fees,
    this.method,
    this.trackingNumber,
    this.carrier,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) {
    return Shipment(
      createdAt: _parseDate(json['createdAt']),
      deliveredAt: _parseDate(json['deliveredAt']),
      fees: json['fees'] is num ? (json['fees'] as num).toDouble() : null,
      method: json['method'],
      trackingNumber: json['trackingNumber'],
      carrier: json['carrier'],
    );
  }
}
