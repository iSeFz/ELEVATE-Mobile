import 'package:flutter/material.dart';
import 'package:elevate/models/wishlist_product.dart';
import 'package:elevate/utils/size_config.dart';
import 'package:elevate/screens/product_details_page.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetails(product: product),
        ),
      );
    },
    child: Container(
      width: SizeConfig.screenWidth * 0.5 - 20,
      height: 350*SizeConfig.verticalBlock,
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "product.imageURL",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 220*SizeConfig.verticalBlock,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      color: Colors.grey[100],
                      width: double.infinity,
                      height: 220*SizeConfig.verticalBlock,
                      child: Icon(Icons.broken_image_rounded, size: 100*SizeConfig.verticalBlock,color: Color(
                          0xFFE8BBC2),),
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
                            fontSize: 14 * SizeConfig.textRatio,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          product.brandName,
                          style: TextStyle(
                            color: Color(0xFFA51930),
                            fontSize: 14 * SizeConfig.textRatio,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'EGP ${product.price}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15 * SizeConfig.textRatio,
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
                      icon: Icon(Icons.favorite_outline_rounded),
                      onPressed: () {
                        // setState(() {
                        //   // favoriteProducts.remove(product);
                        // });
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
      ),)
    );
  }
}
