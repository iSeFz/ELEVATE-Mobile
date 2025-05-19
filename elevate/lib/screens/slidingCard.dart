import 'package:flutter/material.dart';

void main() => runApp(SlidingCardApp());

class SlidingCardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SlidingProductScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SlidingProductScreen extends StatelessWidget {
  final Map<String, String> product = {
    'name': 'Cotton Shirt',
    'brand': ' Brand : شوقي للملابس',
    'price': '450 EGP',
    'desc': 'High-quality cotton shirt, ideal for summer.',
    'image': 'https://plus.unsplash.com/premium_photo-1727967194155-ed1b295c76ae?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Product Image
          Image.network(
            product['image']!,
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter, // ⬅️ ensures image starts from top
          )
          ,

          // Draggable Card
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(product['name']!,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Text(product['brand']!,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red)),
                    SizedBox(height: 8),
                    Text(product['price']!,
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 12),
                    Text(product['desc']!,
                        style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Add to Cart',style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),)
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
