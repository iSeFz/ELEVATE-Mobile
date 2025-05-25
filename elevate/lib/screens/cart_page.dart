import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/cart_item.dart';
import '/cubits/customer_cubit.dart';
import '/constants/app_constants.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];
  late double subtotal = 0.0;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
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

    final url = "https://elevate-fcai-cu.vercel.app/api/v1/customers/me/cart?userId=$userId";
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {testAuthHeader: testAuthValue},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cartData = data['data'];
        final List<dynamic> itemsJson = cartData['items'] ?? [];
        
        setState(() {
          cartItems = itemsJson.map((json) => CartItem(
            id: json['id'],
            productId: json['productId'],
            variantId: json['variantId'],
            quantity: json['quantity'],
            brandName: json['brandName'],
            productName: json['productName'],
            size: json['size'],
            colors: (json['colors'] as List<dynamic>?)?.map((c) => c.toString()).toList() ?? [],
            price: (json['price'] as num).toDouble(),
            imageURL: json['imageURL'],
          )).toList();
          subtotal = (cartData['subtotal'] as num?)?.toDouble() ?? 0.0;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load cart items.';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $e';
      });
    }
  }

  Future<void> updateQuantity(int index, int change) async {
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

    final cartItem = cartItems[index];
    final newQuantity = cartItem.quantity + change;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      if (newQuantity > 0) {
        final url = "https://elevate-fcai-cu.vercel.app/api/v1/customers/me/cart/items/${cartItem.id}?userId=$userId";
        final response = await http.put(
          Uri.parse(url),
          headers: {
            testAuthHeader: testAuthValue,
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'quantity': newQuantity,
          }),
        );
        if (response.statusCode == 200) {
          setState(() {
            cartItems[index].quantity = newQuantity;
            calculateSubtotal();
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Failed to update quantity.';
            isLoading = false;
          });
        }
      } else {
        final url = "https://elevate-fcai-cu.vercel.app/api/v1/customers/me/cart/items/${cartItem.id}?userId=$userId";
        final response = await http.delete(
          Uri.parse(url),
          headers: {testAuthHeader: testAuthValue},
        );
        if (response.statusCode == 200) {
          setState(() {
            cartItems.removeAt(index);
            calculateSubtotal();
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Failed to remove item.';
            isLoading = false;
          });
        }
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
          'Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : cartItems.isEmpty
                  ? Center(child: Text('Your cart is empty.'))
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(12),
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              return buildCartItem(cartItems[index], index);
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "SubTotal",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "EGP ${subtotal.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 9),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),
                                  ),
                                  onPressed: cartItems.isEmpty ? null : () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => 
                                          CheckoutScreen(
                                            cartItems: cartItems,
                                            subtotal: subtotal,
                                          ),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          const begin = Offset(1.0, 0.0);
                                          const end = Offset.zero;
                                          const curve = Curves.easeInOut;
                                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                          var offsetAnimation = animation.drive(tween);
                                          return SlideTransition(position: offsetAnimation, child: child);
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Proceed to Checkout",
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
    );
  }

  void calculateSubtotal() {
    subtotal = 0;
    for (var item in cartItems) {
      subtotal += item.price * item.quantity;
    }
  }

  Widget buildCartItem(CartItem item, int index) {
    return Card(
      color: Colors.white,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // small image
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(8),
            //   child: SizedBox(
            //     width: 80,
            //     height: 80,
            //     child: Image.network(
            //       item.image,
            //       fit: BoxFit.contain,
            //     ),
            //   ),
            // ),
            // Image cropped from sides
            SizedBox(
              width: 100,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageURL,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image, size: 40),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Brand: ${item.brandName}',
                    style: TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    'Size: ${item.size}',
                    style: TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    'Colors: ${item.colors.join(", ")}',
                    style: TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "EGP ${item.price.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () => updateQuantity(index, -1),
                    ),
                    Text(
                      item.quantity.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () => updateQuantity(index, 1),
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
