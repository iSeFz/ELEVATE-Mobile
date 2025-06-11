import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/cart_service.dart';
import '../../data/models/cart_item.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartService _cartService = CartService();
  List<CartItem> _cartItems = [];
  double subtotal = 0.0;

  List<CartItem> get cartItems => _cartItems;

  CartCubit() : super(CartInitial());

  Future<void> fetchCartItems(String userId) async {
    emit(CartLoading());
    try {
      _cartItems = await _cartService.fetchCartItems(userId);

      await Future.wait(
        _cartItems.map((item) async {
          item.productStock = await _cartService.fetchProductStock(
            item.productId,
            item.variantId,
          );
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

  Future<void> updateQuantity(String userId, int index, int change) async {
    final cartItem = _cartItems[index];
    final newQuantity = cartItem.quantity + change;

    try {
      if (newQuantity > 0) {
        _cartItems[index].quantity = newQuantity;
      } else {
        await _cartService.removeItem(userId, cartItem.id!);
        _cartItems.removeAt(index);
        emit(CartItemRemoved());
      }

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
      String backendMsg = "";
      if (e is Exception && e.toString().contains('Exception:')) {
        backendMsg = e.toString().replaceFirst('Exception:', '').trim();
      }
      emit(
        CartError(
          message:
              backendMsg.isNotEmpty ? backendMsg : "Failed to remove item.",
        ),
      );
      if (_cartItems.isNotEmpty) {
        emit(CartLoaded());
      } else {
        emit(CartEmpty());
      }
    }
  }

  Future<String?> proceedToCheckout(String userId) async {
    emit(CartLoading());
    try {
      final orderId = await _cartService.proceedToCheckout(userId, _cartItems);
      emit(CartLoaded());
      return orderId;
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
      return null;
    }
  }
}
