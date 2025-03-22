import 'package:flutter/material.dart';

class Product {
  final String image;
  final String name;
  final String brand;
  final String price;

  Product({
    required this.image,
    required this.name,
    required this.brand,
    required this.price,
  });
}

class FavoritesPage extends StatefulWidget {
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Product> favoriteProducts = [
    Product(
      image:
          'https://plus.unsplash.com/premium_photo-1718913936342-eaafff98834b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dCUyMHNoaXJ0fGVufDB8fDB8fHww',
      name: 'T-shirt Gamed awyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy',
      brand: 'شوقي للملابس',
      price: '120',
    ),
    Product(
      image:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcyfFUztxIyItyyvdCwHNm60RpFbSRuN9h3g&s',
      name: 'Black T-Shirt',
      brand: 'شوقي للملابس',
      price: '150',
    ),
    Product(
      image:
          'https://plus.unsplash.com/premium_photo-1718913936342-eaafff98834b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dCUyMHNoaXJ0fGVufDB8fDB8fHww',
      name: 'T-shirt Gamed awy',
      brand: 'شوقي للملابس',
      price: '120',
    ),
    Product(
      image:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcyfFUztxIyItyyvdCwHNm60RpFbSRuN9h3g&s',
      name: 'Black T-Shirt',
      brand: 'شوقي للملابس',
      price: '150',
    ),
    Product(
      image:
          'https://plus.unsplash.com/premium_photo-1718913936342-eaafff98834b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dCUyMHNoaXJ0fGVufDB8fDB8fHww',
      name: 'T-shirt Gamed awy',
      brand: 'شوقي للملابس',
      price: '120',
    ),
    Product(
      image:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcyfFUztxIyItyyvdCwHNm60RpFbSRuN9h3g&s',
      name: 'Black T-Shirt',
      brand: 'شوقي للملابس',
      price: '150',
    ),
    Product(
      image:
          'https://plus.unsplash.com/premium_photo-1718913936342-eaafff98834b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dCUyMHNoaXJ0fGVufDB8fDB8fHww',
      name: 'T-shirt Gamed awy',
      brand: 'شوقي للملابس',
      price: '120',
    ),
  ];

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
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: (favoriteProducts.length / 2).ceil(),
          itemBuilder: (context, index) {
            final int firstIndex = index * 2;
            final int secondIndex = firstIndex + 1;
            final double screenTotalWidth = MediaQuery.of(context).size.width;

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

  Widget _buildProductCard(Product product) {
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
                product.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 120,
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
                          'Brand: ${product.brand}',
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
                        setState(() {
                          print('Product Removed Successfully');
                          favoriteProducts.remove(product);
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.shopping_bag_outlined),
                      onPressed: () {
                        print('Product Added to cart');
                      },
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
