import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/wishlist_cubit.dart';
import '../cubits/wishlist_state.dart';
import '../../data/models/wishlist_product.dart';

// Product card builder widget for displaying individual products in the wishlist
class WishlistProductCard extends StatelessWidget {
  const WishlistProductCard({
    super.key,
    required this.userID,
    required this.product,
  });

  final String userID;
  final WishlistProduct product;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        return Expanded(
          child: Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    product.imageURL,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 120,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          height: 120,
                          width: double.infinity,
                          child: Icon(
                            Icons.broken_image,
                            size: 80,
                            color: Colors.grey[600],
                          ),
                        ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Brand: ${product.brandName}',
                              style: TextStyle(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'EGP ${product.price}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.favorite, color: Colors.red),
                          tooltip: 'Remove from Wishlist',
                          onPressed: () {
                            context.read<WishlistCubit>().removeFromWishlist(
                              userID,
                              product.productId,
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.shopping_bag_outlined),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
