import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/cart_service.dart';
import '../../data/models/cart_item.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartService _cartService = CartService();
  final String userId;

  List<CartItem> _cartItems = [];
  double subtotal = 0.0;
  String? orderId;

  List<CartItem> get cartItems => _cartItems;
  double get cartItemsCount => subtotal;

  CartCubit({required this.userId}) : super(CartInitial());

  Future<void> fetchCartItems() async {
    emit(CartLoading());
    try {
      _cartItems = await _cartService.fetchCartItems(userId);

      await Future.wait(
        _cartItems.map((item) async {
          item.productStock = await _cartService.fetchProductStock(
            item.productId,
            item.variantId,
          );

          if (item.productStock != null && item.quantity > item.productStock!) {
            item.quantity = item.productStock!;
          }
        }),
      );

      subtotal = _cartItems.fold(
        0.0,
        (sum, item) => sum + item.price * item.quantity,
      );
      if (_cartItems.isNotEmpty) {
        emit(CartLoaded());
      } else {
        emit(CartEmpty());
      }
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> updateQuantity(int index, int newQuantity) async {
    final cartItem = _cartItems[index];

    try {
      // Try to update the quantity in the backend
      await _cartService.updateQuantity(userId, cartItem.id!, newQuantity);
      _cartItems[index].quantity = newQuantity;
      // Reference changed, so the UI can detects the change and update quantity
      // _cartItems = List<CartItem>.from(_cartItems);
      subtotal = _cartItems.fold(
        0.0,
        (sum, item) => sum + item.price * item.quantity,
      );
      emit(CartLoaded());
    } catch (e) {
      try {
        final latestStock = await _cartService.fetchProductStock(
          cartItem.productId,
          cartItem.variantId,
        );
        _cartItems[index].productStock = latestStock;

        // Set the quantity to the max available stock
        if (latestStock > 0) {
          _cartItems[index].quantity = latestStock;
          // Update the backend with the new max stock value
          await _cartService.updateQuantity(userId, cartItem.id!, latestStock);
        }

        subtotal = _cartItems.fold(
          0.0,
          (sum, item) => sum + item.price * item.quantity,
        );

        emit(
          CartError(
            message:
                "Quantity exceeds available stock. Updated to max available.",
          ),
        );
        emit(CartLoaded());
      } catch (stockError) {
        emit(CartError(message: "Failed to update quantity: $e"));
        emit(CartLoaded());
      }
    }
  }

  Future<void> removeFromCart(int index) async {
    try {
      final cartItem = _cartItems[index];
      await _cartService.removeItem(userId, cartItem.id!);
      _cartItems.removeAt(index);
      emit(CartItemRemoved());
      if (_cartItems.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartLoaded());
      }
    } catch (e) {
      emit(CartError(message: 'Failed to remove item: $e'));
    }
  }

  Future<void> proceedToCheckout() async {
    try {
      orderId = await _cartService.proceedToCheckout(userId, _cartItems);
      emit(CartCheckoutSuccess());
    } catch (e) {
      // 1. Update product stock for all cart items
      await Future.wait(
        _cartItems.map((item) async {
          try {
            item.productStock = await _cartService.fetchProductStock(
              item.productId,
              item.variantId,
            );
            // If quantity exceeds stock, set it to stock
            if (item.productStock != null &&
                item.quantity > item.productStock!) {
              item.quantity = item.productStock!;
            }
          } catch (_) {}
        }),
      );

      // 2. Show a clear error message if it's a stock/quantity issue
      String userMessage =
          "Some products' quantity exceeds the available stock. Please review your cart.";
      emit(CartError(message: userMessage));
      if (_cartItems.isNotEmpty) {
        emit(CartLoaded());
      } else {
        emit(CartEmpty());
      }
    }
  }

  bool canProceedToCheckout() {
    // Check if any item in the cart has zero stock
    final hasOutOfStockItems = _cartItems.any(
      (item) => item.productStock == 0 || item.productStock == null,
    );

    return !hasOutOfStockItems && _cartItems.isNotEmpty;
  }
}
