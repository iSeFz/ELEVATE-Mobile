import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/cart_body.dart';
import '../cubits/cart_cubit.dart';
import '../cubits/cart_state.dart';
import '../../../order/presentation/screens/order_page.dart';

class CartPage extends StatelessWidget {
  final String userId;
  const CartPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartCubit>(
      create: (context) => CartCubit(userId: userId)..fetchCartItems(),
      child: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is CartItemRemoved) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Item removed from cart')));
          }
          if (state is CartCheckoutSuccess) {
            final cartCubit = context.read<CartCubit>();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider.value(
                      value: context.read<CartCubit>(),
                      child: OrderScreen(
                        orderId: cartCubit.orderId!,
                        userId: userId,
                        cartItems: cartCubit.cartItems,
                      ),
                    ),
              ),
            ).then((_) {
              // Refresh the cart data when returning from the OrderScreen
              final cubit = context.read<CartCubit>();
              if (!cubit.isClosed && context.mounted) {
                cubit.fetchCartItems();
              }
            });
          }
        },
        builder: (context, state) {
          final cartCubit = context.read<CartCubit>();
          if (state is CartLoading) {
            return _cartScaffold(
              context,
              body: const Center(child: CircularProgressIndicator()),
            );
          } else if (state is CartLoaded || state is CartItemRemoved) {
            return _cartScaffold(
              context,
              body:
                  cartCubit.cartItems.isEmpty
                      ? const Center(
                        child: Text(
                          'Your cart is empty.',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                      : const CartBody(),
            );
          } else if (state is CartEmpty) {
            return _cartScaffold(
              context,
              body: const Center(
                child: Text(
                  'Your cart is empty.',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          } else if (state is CartError) {
            return _cartScaffold(
              context,
              body: Center(child: Text(state.message)),
            );
          }
          return _cartScaffold(
            context,
            body: const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _cartScaffold(BuildContext context, {required Widget body}) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Colors.black26,
        title: Text(
          'Cart',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: body,
    );
  }
}
