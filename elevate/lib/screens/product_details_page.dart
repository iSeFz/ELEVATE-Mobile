import 'package:flutter/material.dart';
import '../models/product.dart';
import '/screens/reviews.dart';
import '/utils/size_config.dart';
import '/custom_widgets/product_card.dart';
import '/custom_widgets/rate_card.dart';
import '/models/wishlist_product.dart';
import '../custom_widgets/full_screen_image.dart';

Widget _buildColorCircle(Color color) {
  return Container(
    margin: EdgeInsets.only(right: 10),
    width: 30 * SizeConfig.horizontalBlock,
    height: 30 * SizeConfig.verticalBlock,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.grey.shade300),
    ),
  );
}

class ProductDetails extends StatelessWidget {
  @override
  ProductDetails({required this.product,super.key});
  final Product product;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // remove default shadow
        centerTitle: true,
        title: Text('Men', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: Container(
            height: 4 * SizeConfig.verticalBlock,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          // Background Product Image
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FullScreenImage(imageUrl: product.image),
                ),
              );
            },
            child: Image.network(
              product.image,
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fitWidth,
              alignment:
              Alignment.topCenter, // ⬅️ ensures image starts from top
            ),
          ),

          // Draggable Card
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(16 * SizeConfig.verticalBlock),
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
                        width: 50 * SizeConfig.horizontalBlock,
                        height: 5 * SizeConfig.verticalBlock,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 18 * SizeConfig.textRatio,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8 * SizeConfig.verticalBlock),
                    Text(
                      product.brandName,
                      style: TextStyle(
                        fontSize: 15 * SizeConfig.textRatio,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA51930),
                      ),
                    ),
                    SizedBox(height: 12 * SizeConfig.verticalBlock),
                    Text(
                      product.price.toString(),
                      style: TextStyle(
                        fontSize: 20 * SizeConfig.textRatio,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 13 * SizeConfig.verticalBlock),
                    // Text(product['desc']!,
                    //     style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                    // SizedBox(height: 24),
                    Text(
                      'Colors :',
                      style: TextStyle(fontSize: 13 * SizeConfig.textRatio),
                    ),
                    SizedBox(height: 8),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildColorCircle(Colors.black),
                        _buildColorCircle(Colors.blue[900]!),
                        _buildColorCircle(
                          Color(0xFFA51930),
                        ), // your custom color
                      ],
                    ),
                    SizedBox(height: 20 * SizeConfig.verticalBlock),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'ADD TO CART',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: Size(
                          double.infinity,
                          50 * SizeConfig.textRatio,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    SizedBox(height: 30 * SizeConfig.verticalBlock),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0 * SizeConfig.horizontalBlock,
                          ), // same as box
                          child: Text(
                            "About product",
                            style: TextStyle(
                              fontSize: 18 * SizeConfig.textRatio,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 20 * SizeConfig.verticalBlock),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(
                              8 * SizeConfig.verticalBlock,
                            ),
                          ),
                          child: Column(
                            children: [
                              ExpansionTile(
                                title: Row(
                                  children: [
                                    Icon(
                                      Icons.checkroom,
                                      color: Colors.black,
                                    ), // size/ruler icon
                                    SizedBox(width: 8),
                                    Text(
                                      "Description",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18 * SizeConfig.textRatio
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Icon(Icons.expand_more),
                                children: [
                                  // padding: const EdgeInsets.all(8.0),
                                  Text("High-quality cotton shirt..."),
                                ],
                              ),
                              Divider(
                                color: Colors.grey.shade300,
                                height: 1 * SizeConfig.verticalBlock,
                              ),
                              ExpansionTile(
                                title: Row(
                                  children: [
                                    Icon(
                                      Icons.straighten,
                                      color: Colors.black,
                                    ), // size/ruler icon
                                    SizedBox(
                                      width: 8 * SizeConfig.horizontalBlock,
                                    ),
                                    Text(
                                      "Size Chart",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18 * SizeConfig.textRatio

                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Icon(Icons.expand_more),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(
                                      8.0 * SizeConfig.verticalBlock,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text("S: Chest 36-38 in"),
                                        Text("M: Chest 39-41 in"),
                                        Text("L: Chest 42-44 in"),
                                        Text("XL: Chest 45-47 in"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              Divider(
                                color: Colors.grey.shade300,
                                height: 1 * SizeConfig.verticalBlock,
                              ),
                              ExpansionTile(
                                title: Row(
                                  children: [
                                    Icon(
                                      Icons.reviews_outlined,
                                      color: Colors.black,
                                    ), // size/ruler icon
                                    SizedBox(
                                      width: 8 * SizeConfig.horizontalBlock,
                                    ),
                                    Text(
                                      "Reviews",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18 * SizeConfig.textRatio

                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Icon(Icons.expand_more),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                      24 * SizeConfig.horizontalBlock,
                                      vertical: 10 * SizeConfig.verticalBlock,
                                    ),
                                    child: Column(
                                      children: [
                                        RateCard(
                                          username: 'Adham_Immortal',
                                          avatarUrl:
                                          'https://domanza.co/cdn/shop/files/CCxNavy-45Large_27baa9f2-e314-4ffb-a8a9-65d1ad738bc8_jpg.jpg?v=1739309915&width=5760',
                                          comment: 'Loved the material!',
                                          stars: 5,
                                        ),
                                        SizedBox(
                                          height: 30 * SizeConfig.verticalBlock,
                                        ),
                                        RateCard(
                                          username: 'Belal_Ahmedd',
                                          avatarUrl:
                                          'https://domanza.co/cdn/shop/files/CCxNavy-45Large_27baa9f2-e314-4ffb-a8a9-65d1ad738bc8_jpg.jpg?v=1739309915&width=5760',
                                          comment: 'Had fun AR',
                                          stars: 3,
                                        ),
                                        SizedBox(
                                          height: 20 * SizeConfig.verticalBlock,
                                        ),
                                        Container(
                                          // margin: const EdgeInsets.all(16),
                                          padding: EdgeInsets.symmetric(
                                            vertical:
                                            10 * SizeConfig.verticalBlock,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                color: Colors.grey[300]!,
                                                width: 1,
                                              ),
                                              // bottom: BorderSide(color: Colors.grey, width: 1),
                                            ),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => ReviewsBar(),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "See more >>",
                                                  style: TextStyle(
                                                    color: Color(0xFFA51930),
                                                    fontSize:
                                                    10 *
                                                        SizeConfig.textRatio,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey.shade300,
                                height: 1 * SizeConfig.verticalBlock,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20 * SizeConfig.verticalBlock),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0 * SizeConfig.horizontalBlock,
                      ), // same as box
                      child: Text(
                        "You might like",
                        style: TextStyle(
                          fontSize: 18 * SizeConfig.textRatio,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 20 * SizeConfig.verticalBlock),
                    Row(
                      children: [
                        // ProductCard(
                        //   product: WishlistProduct(
                        //     productId: '1',
                        //     brandName: 'NAVY',
                        //     name: 'Sweatshirt',
                        //     imageURL:
                        //     'https://domanza.co/cdn/shop/files/CCxNavy-45Large_27baa9f2-e314-4ffb-a8a9-65d1ad738bc8_jpg.jpg?v=1739309915&width=5760',
                        //     price: 799,
                        //   ),
                        // ),
                        //
                        // ProductCard(
                        //   product: WishlistProduct(
                        //     productId: '1',
                        //     brandName: 'NAVY',
                        //     name: 'Sweatshirt',
                        //     imageURL:
                        //     'https://domanza.co/cdn/shop/files/CCxNavy-45Large_27baa9f2-e314-4ffb-a8a9-65d1ad738bc8_jpg.jpg?v=1739309915&width=5760',
                        //     price: 799,
                        //   ),
                        // ),
                      ],
                    ),
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
