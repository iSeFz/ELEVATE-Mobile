import 'package:flutter/material.dart';
import '../cubits/cart_cubit.dart';
import 'cart_item_card.dart';
import 'cart_section.dart';

class CartBody extends StatelessWidget {
  final CartCubit cartCubit;
  final String userId;

  const CartBody({super.key, required this.cartCubit, required this.userId});

  @override
  Widget build(BuildContext context) {
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
                onQuantityChanged: (idx, quantityChange) {
                  cartCubit.updateQuantity(userId, idx, quantityChange);
                },
              );
            },
          ),
        ),
        CartSection(cartCubit: cartCubit, userId: userId),
      ],
    );
  }
}
