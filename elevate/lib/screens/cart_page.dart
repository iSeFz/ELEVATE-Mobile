import 'package:flutter/material.dart';
import '/models/item.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<Item> cartItems = [
    Item(
      image:
          'https://plus.unsplash.com/premium_photo-1718913936342-eaafff98834b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dCUyMHNoaXJ0fGVufDB8fDB8fHww',
      name: 'T-shirt Gamed awyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy',
      brand: 'شوقي للملابس',
      price: 100.777,
      size: "L",
      colors: ["White"],
      quantity: 1,
    ),
    Item(
      image:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcyfFUztxIyItyyvdCwHNm60RpFbSRuN9h3g&s',
      name: 'Black T-Shirt',
      brand: 'شوقي للملابس',
      price: 200,
      size: "XL",
      colors: ["Black", "Blue"],
      quantity: 2,
    ),
    Item(
      image:
          'https://plus.unsplash.com/premium_photo-1718913936342-eaafff98834b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dCUyMHNoaXJ0fGVufDB8fDB8fHww',
      name: 'T-shirt Gamed awyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy',
      brand: 'شوقي للملابس',
      price: 100,
      size: "L",
      colors: ["White"],
      quantity: 1,
    ),
    Item(
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcyfFUztxIyItyyvdCwHNm60RpFbSRuN9h3g&s',
      name: 'Black T-Shirt',
      brand: 'شوقي للملابس',
      price: 200,
      size: "XL",
      colors: ["Black", "Blue"],
      quantity: 2,
    ),
    Item(
      image:
      'https://plus.unsplash.com/premium_photo-1718913936342-eaafff98834b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dCUyMHNoaXJ0fGVufDB8fDB8fHww',
      name: 'T-shirt Gamed awyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy',
      brand: 'شوقي للملابس',
      price: 100,
      size: "L",
      colors: ["White"],
      quantity: 1,
    ),
    Item(
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcyfFUztxIyItyyvdCwHNm60RpFbSRuN9h3g&s',
      name: 'Black T-Shirt',
      brand: 'شوقي للملابس',
      price: 200,
      size: "XL",
      colors: ["Black", "Blue"],
      quantity: 2,
    ),
    Item(
      image:
      'https://plus.unsplash.com/premium_photo-1718913936342-eaafff98834b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dCUyMHNoaXJ0fGVufDB8fDB8fHww',
      name: 'T-shirt Gamed awyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy',
      brand: 'شوقي للملابس',
      price: 100,
      size: "L",
      colors: ["White"],
      quantity: 1,
    ),
  ];
  late double subtotal;

  @override
  void initState() {
    super.initState();
    calculateSubtotal();
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
      body: Column(
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
                    onPressed: () {
                      print('Checkout');
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

  void updateQuantity(int index, int change) {
    setState(() {
      if (cartItems[index].quantity + change > 0) {
        cartItems[index].quantity += change;
      } else {
        cartItems.remove(cartItems[index]);
      }
      calculateSubtotal();
    });
  }

  Widget buildCartItem(Item item, int index) {
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
                  item.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Brand: ${item.brand}',
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
                    'Colors: ${cartItems[index].colors.join("/")}',
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
