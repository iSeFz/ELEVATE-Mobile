import 'package:flutter/material.dart';
import '/../core/utils/size_config.dart';
import '/../features/home/presentation/screens/product_details_page.dart';
import '/../features/home/data/models/product.dart';

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
      width: SizeConfig.horizontalBlock * 200,
      height: 350*SizeConfig.verticalBlock,
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Container(
              // borderRadius: BorderRadius.circular(10),
              width: double.infinity,
              height: 225*SizeConfig.verticalBlock,
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      color: Colors.grey[100],
                      // width: double.infinity,
                      // height: 220*SizeConfig.verticalBlock,
                      child: Icon(Icons.broken_image_rounded, size: 100*SizeConfig.verticalBlock,color: Color(
                          0xFFE8BBC2),),
                    ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(18*SizeConfig.verticalBlock),
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
                        SizedBox(height: 2*SizeConfig.verticalBlock),
                        Text(
                          product.brandName,
                          style: TextStyle(
                            color: Color(0xFFA51930),
                            fontSize: 14 * SizeConfig.textRatio,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4*SizeConfig.verticalBlock),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite_outline_rounded),

                      padding: EdgeInsets.zero,
                      onPressed: () {

                        // setState(() {
                        //   // favoriteProducts.remove(product);
                        // });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.shopping_bag_outlined),
                      padding: EdgeInsets.zero,
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
