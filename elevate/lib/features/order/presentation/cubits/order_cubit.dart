import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_state.dart';
import '../../data/services/order_service.dart';
import '../../data/models/order_item.dart';
import '../../../cart/data/models/cart_item.dart';
import '../../data/models/shipment_types.dart';

class OrderCubit extends Cubit<OrderState> {
  String? _orderId;
  OrderItem? _orderItem;
  List<CartItem> _cartItems = [];

  List<Address> _addresses = []; // Store parsed Address objects
  List<String> _formattedAddresses = [];
  Address? _selectedAddress;
  String? _selectedFormattedAddress;

  int _loyaltyPoints = 0;
  String _selectedShipmentType = ShipmentTypes.pickup;
  double _shipmentFee = 0.0;

  OrderItem? get orderItem => _orderItem;
  List<String> get userAddresses => _formattedAddresses;
  int get loyaltyPoints => _loyaltyPoints;
  String get selectedShipmentType => _selectedShipmentType;
  String? get selectedAddress => _selectedFormattedAddress;
  double get shipmentFee => _shipmentFee;
  String? get orderId => _orderId;
  List<CartItem> get cartItems => _cartItems;

  double get subtotal =>
      _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  OrderCubit({List<CartItem> cartItems = const []}) : super(OrderInitial()) {
    _cartItems = cartItems;
  }

  Future<void> initializeOrder(String orderId, String userId) async {
    emit(OrderLoading());
    try {
      final customerData = await OrderService.fetchCustomerData(userId);
      if (customerData == null) {
        emit(OrderError('An error occurred while loading order.'));
        return;
      }

      _orderId = orderId;

      // Print raw address data from API
      final addressesData = customerData['addresses'] as List<dynamic>? ?? [];
      _addresses = addressesData.map((addr) => Address.fromJson(addr)).toList();

      // Format addresses for UI display
      _formattedAddresses =
          _addresses
              .map(
                (addr) =>
                    "${addr.city}, ${addr.street}, Building ${addr.building}",
              )
              .toList();

      _loyaltyPoints = customerData['loyaltyPoints'] ?? 0;
      _selectedShipmentType = ShipmentTypes.pickup;
      _shipmentFee = 0.0;

      // Default selected address
      if (_addresses.isNotEmpty) {
        _selectedAddress = _addresses.first;
        _selectedFormattedAddress = _formattedAddresses.first;
      }

      _orderItem = OrderItem(
        id: orderId,
        customerId: userId,
        address:
            _selectedAddress ??
            Address(
              building: 0,
              city: '',
              street: '',
              latitude: 0.0,
              longitude: 0.0,
            ),
        phoneNumber: customerData['phoneNumber'] ?? '',
        pointsRedeemed: 0,
        shipmentMethod: _selectedShipmentType,
        shipmentFees: _shipmentFee,
      );

      emit(OrderLoaded());
    } catch (e) {
      emit(OrderError('Error loading order: ${e.toString()}'));
    }
  }

  Future<void> releaseOrder(String orderId, String userId) async {
    try {
      await OrderService.releaseItems(orderId, userId);
      emit(OrderReleased());
    } catch (e) {
      emit(OrderError('Failed to release order.'));
    }
  }

  Future<void> updateShipmentType(String type) async {
    if (state is OrderLoaded) {
      _selectedShipmentType = type;

      try {
        if (type == ShipmentTypes.pickup) {
          _shipmentFee = 0.0;
          _orderItem!.shipmentFees = 0.0;
          _orderItem!.shipmentMethod = ShipmentTypes.pickup;
        } else if (_selectedAddress != null) {
          final requestBody = jsonEncode({
            "address": _selectedAddress!.toJson(),
            "shipmentType": type,
          });
          _shipmentFee = await OrderService.calculateShipmentFees(
            _orderId!,
            _orderItem!.customerId,
            requestBody,
          );
          _orderItem!.shipmentFees = _shipmentFee;
          _orderItem!.shipmentMethod = type;
        }
      } catch (e) {
        _shipmentFee = 0.0;
        _selectedShipmentType = ShipmentTypes.pickup;
        _orderItem!.shipmentFees = 0.0;
        _orderItem!.shipmentMethod = ShipmentTypes.pickup;
        emit(OrderError('Failed to update shipment type: ${e.toString()}'));
        return; // Avoid emitting OrderLoaded
      }
      emit(OrderLoaded());
    }
  }

  void updateAddress(String formattedAddress) {
    if (state is OrderLoaded) {
      final index = _formattedAddresses.indexOf(formattedAddress);
      if (index >= 0) {
        _selectedAddress = _addresses[index];
        _selectedFormattedAddress = formattedAddress;

        // Recalculate shipping fee with new address
        updateShipmentType(_selectedShipmentType);
      }
    }
  }

  Future<void> placeOrder() async {
    if (state is OrderLoaded && _orderId != null && _orderItem != null) {
      emit(OrderLoading());

      try {
        final success = await OrderService.confirmOrder(
          _orderId!,
          _orderItem!.customerId,
          _orderItem!.phoneNumber,
        );
        if (success) {
          emit(OrderPlaced());
        } else {
          emit(OrderError('Failed to place order. Please try again.'));
        }
      } catch (e) {
        emit(OrderError('Error placing order: ${e.toString()}'));
      }
    }
  }
}
