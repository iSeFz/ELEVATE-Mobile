import 'package:flutter/material.dart';

void main() => runApp(ShirtApp());

class ShirtApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShirtProductList(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ShirtProductList extends StatefulWidget {
  @override
  _ShirtProductListState createState() => _ShirtProductListState();
}

class _ShirtProductListState extends State<ShirtProductList> {
  final List<Map<String, String>> shirts = [
    {
      'name': 'Classic White Shirt',
      'price': 'EGP 450',
      'desc': 'Cotton shirt perfect for formal wear.',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'name': 'Denim Shirt',
      'price': 'EGP 550',
      'desc': 'Casual denim shirt with chest pockets.',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'name': 'Striped Shirt',
      'price': 'EGP 500',
      'desc': 'Stylish striped shirt for outings.',
      'image': 'https://via.placeholder.com/150'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shirt Collection')),
      body: ListView.builder(
        itemCount: shirts.length,
        itemBuilder: (context, index) {
          final shirt = shirts[index];
          return Card(
            margin: EdgeInsets.all(10),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    shirt['image']!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(shirt['name']!,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(shirt['desc']!, style: TextStyle(color: Colors.grey[700])),
                      SizedBox(height: 6),
                      Text(shirt['price']!,
                          style: TextStyle(fontSize: 16, color: Colors.green[700])),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
