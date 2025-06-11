abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {}

class CartItemRemoved extends CartState {}

class CartEmpty extends CartState {}

class CartError extends CartState {
  final String message;
  CartError({required this.message});
}
