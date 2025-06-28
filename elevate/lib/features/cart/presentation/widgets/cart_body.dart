import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/cart_cubit.dart';
import 'cart_item_card.dart';
import 'cart_section.dart';
import '../cubits/cart_state.dart';

class CartBody extends StatelessWidget {
  const CartBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Use BlocBuilder to rebuild when CartState changes
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cartCubit = context.watch<CartCubit>();
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: cartCubit.cartItems.length,
                itemBuilder: (context, index) {
                  return CartItemCard(
                    item: cartCubit.cartItems[index],
                    index: index,
                    onQuantityChanged: (idx, newQuantity) {
                      cartCubit.updateQuantity(idx, newQuantity);
                    },
                    onRemoveItem: (idx) {
                      cartCubit.removeFromCart(index: idx);
                    },
                  );
                },
              ),
            ),
            const CartSection(),
          ],
        );
      },
    );
  }
}
