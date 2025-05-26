import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/constants.dart';
import '../../../../cubits/customer_cubit.dart';
import '../../data/models/wishlist_product.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<WishlistProduct> favoriteProducts = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    final customerState = context.read<CustomerCubit>().state;
    String? userId;

    if (customerState is CustomerLoggedIn) {
      userId = customerState.customer.id;
    } else if (customerState is CustomerLoaded) {
      userId = customerState.customer.id;
    }

    if (userId == null) {
      setState(() {
        isLoading = false;
        errorMessage = 'User not logged in.';
      });
      return;
    }
    final url =
        "https://elevate-gp.vercel.app/api/v1/customers/me/wishlist?userId=$userId";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {testAuthHeader: testAuthValue},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> productsJson = data['data'] ?? [];
        setState(() {
          favoriteProducts =
              productsJson
                  .map((json) => WishlistProduct.fromJson(json))
                  .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load wishlist.';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $e';
      });
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    final customerState = context.read<CustomerCubit>().state;
    String? userId;

    if (customerState is CustomerLoggedIn) {
      userId = customerState.customer.id;
    } else if (customerState is CustomerLoaded) {
      userId = customerState.customer.id;
    }

    if (userId == null) {
      setState(() {
        errorMessage = 'User not logged in.';
      });
      return;
    }

    final url = "https://elevate-gp.vercel.app/api/v1/customers/me/wishlist/items/$productId?userId=$userId";

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {testAuthHeader: testAuthValue,},
      );

      if (response.statusCode == 200) {
        setState(() {
          favoriteProducts.removeWhere(
            (product) => product.productId == productId,
          );
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to remove from wishlist.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Favourites',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : favoriteProducts.isEmpty
              ? Center(child: Text('No favorites found.'))
              : Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: (favoriteProducts.length / 2).ceil(),
                  itemBuilder: (context, index) {
                    final int firstIndex = index * 2;
                    final int secondIndex = firstIndex + 1;
                    final double screenTotalWidth =
                        MediaQuery.of(context).size.width;

                    return Row(
                      children: [
                        _buildProductCard(favoriteProducts[firstIndex]),
                        if (secondIndex < favoriteProducts.length)
                          _buildProductCard(favoriteProducts[secondIndex])
                        else
                          SizedBox(width: screenTotalWidth / 2 - 8),
                      ],
                    );
                  },
                ),
              ),
    );
  }

  Widget _buildProductCard(WishlistProduct product) {
    return Expanded(
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      child: Icon(Icons.broken_image, size: 40),
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
                      onPressed: () {
                          removeFromWishlist(product.productId);
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
  }
}
