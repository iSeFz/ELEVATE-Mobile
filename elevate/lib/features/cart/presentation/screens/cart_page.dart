import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/cart_body.dart';
import '../cubits/cart_cubit.dart';
import '../cubits/cart_state.dart';
import '../../../order/presentation/screens/order_page.dart';

class CartPage extends StatelessWidget {
  final String userID;
  const CartPage({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartCubit>(
      create: (context) => CartCubit(userId: userID)..fetchCartItems(),
      child: Scaffold(
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
        body: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {
            if (state is CartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is CartItemSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Item removed from cart')),
              );
            }
            if (state is CartCheckoutSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<CartCubit>(),
                    child: OrderScreen(
                      orderId: context.read<CartCubit>().orderId!,
                      userId: userID,
                      cartItems: context.read<CartCubit>().cartItems,
                    ),
                  ),
                ),
              ).then((_) {
                if (context.mounted &&
                    !context.read<CartCubit>().isClosed) {
                  context.read<CartCubit>().fetchCartItems();
                }
              });
            }
          },
          builder: (context, state) {
            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;

            if (state is CartLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CartEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.remove_shopping_cart_rounded,
                      size: screenWidth * 0.3,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Nothing added to cart yet.\nStart shopping now!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to the home page via the main page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        Theme.of(context).colorScheme.primary,
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                          horizontal: screenWidth * 0.15,
                        ),
                        textStyle: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Continue Shopping',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const CartBody();
            }
          },
        ),
      ),
    );
  }
}
