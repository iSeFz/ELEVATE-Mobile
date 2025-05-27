import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/wishlist_cubit.dart';
import '../cubits/wishlist_state.dart';
import '../widgets/wishlist_product_card.dart';

// Wishlist Page
class WishlistPage extends StatelessWidget {
  final String userID;
  const WishlistPage({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WishlistCubit>(
      create: (context) => WishlistCubit()..fetchWishlist(userID),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Wishlist',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<WishlistCubit, WishlistState>(
          listener: (context, state) {
            if (state is WishlistItemRemoved) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Item removed from wishlist')),
              );
            } else if (state is WishlistError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is WishlistLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            } else if (state is WishlistLoaded) {
              final wishlistProducts =
                  context.read<WishlistCubit>().wishlistProducts;

              return Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: (wishlistProducts.length / 2).ceil(),
                  itemBuilder: (context, index) {
                    final int firstIndex = index * 2;
                    final int secondIndex = firstIndex + 1;
                    final double screenTotalWidth =
                        MediaQuery.of(context).size.width;

                    return Row(
                      children: [
                        WishlistProductCard(
                          userID: userID,
                          product: wishlistProducts[firstIndex],
                        ),
                        if (secondIndex < wishlistProducts.length)
                          WishlistProductCard(
                            userID: userID,
                            product: wishlistProducts[secondIndex],
                          )
                        else
                          SizedBox(width: screenTotalWidth / 2 - 8),
                      ],
                    );
                  },
                ),
              );
            } else if (state is WishlistEmpty) {
              return Center(
                child: Text(
                  'No wishlist item found.',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
            return Center(
              child: Text('Something went wrong. Please try again.'),
            );
          },
        ),
      ),
    );
  }
}
