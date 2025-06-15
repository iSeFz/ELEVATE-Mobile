import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../wishlist/presentation/cubits/wishlist_cubit.dart';
import '../../data/models/product_card_model.dart';
import '../cubits/product_details_cubit.dart';
import '../cubits/product_details_state_cubit.dart';
import 'reviews.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/rate_card.dart';
import '../../../../core/widgets/full_screen_image.dart';

class ProductDetails extends StatefulWidget {
  ProductDetails({
    required this.productView,
    required this.userId,
    required this.productId,
    super.key,
  });

  final String productId;
  final ProductCardModel productView;
  final dynamic userId;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int selectedColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WishlistCubit>(
          create: (context) => WishlistCubit(),
        ),
        BlocProvider<ProductDetailsCubit>(
          create: (_) => ProductDetailsCubit(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
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
            body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
              builder: (context, state) {
                if (state is ProductDetailsInitial) {
                  context.read<ProductDetailsCubit>().fetchProductDetials(widget.productId);
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductDetailsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductDetailsLoaded) {
                  // Extract color-image pairs from product variants
                  final variants = state.product.variants;
                  final colorImagePairs = variants
                      .expand((variant) => variant.colors.asMap().entries.map((entry) {
                    final colorName = entry.value;
                    final color = _parseColor(colorName);
                    final image = (variant.images.isNotEmpty)
                        ? variant.images[entry.key % variant.images.length]
                        : state.product.image;
                    return {'color': color, 'image': image};
                  }))
                      .toList();

                  final selectedImage = colorImagePairs.isNotEmpty
                      ? colorImagePairs[selectedColorIndex]['image']
                      : state.product.image;

                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullScreenImage(imageUrl: selectedImage.toString()),
                            ),
                          );
                        },
                        child: Image.network(
                          selectedImage.toString(),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter,
                        ),
                      ),
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
                                  widget.productView.name,
                                  style: TextStyle(
                                    fontSize: 18 * SizeConfig.textRatio,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8 * SizeConfig.verticalBlock),
                                Text(
                                  widget.productView.brandName,
                                  style: TextStyle(
                                    fontSize: 15 * SizeConfig.textRatio,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFA51930),
                                  ),
                                ),
                                SizedBox(height: 12 * SizeConfig.verticalBlock),
                                Text(
                                  state.product.price.toString(),
                                  style: TextStyle(
                                    fontSize: 20 * SizeConfig.textRatio,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 13 * SizeConfig.verticalBlock),
                                Text(
                                  'Colors :',
                                  style: TextStyle(fontSize: 13 * SizeConfig.textRatio),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: colorImagePairs.asMap().entries.map((entry) {
                                    int idx = entry.key;
                                    Color variantColor = entry.value['color'] as Color;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedColorIndex = idx;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        width: 30 * SizeConfig.horizontalBlock,
                                        height: 30 * SizeConfig.verticalBlock,
                                        decoration: BoxDecoration(
                                          color: variantColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: selectedColorIndex == idx
                                                ? Colors.red
                                                : Colors.grey.shade300,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
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
                                      ),
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
                                                ),
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
                                              Padding(
                                                padding: EdgeInsets.all(
                                                  16 * SizeConfig.verticalBlock,),
                                                child: Text(
                                                state.product.description,
                                                style: TextStyle(
                                                  fontSize: 14 * SizeConfig.textRatio,
                                                  color: Colors.grey[700],
                                                ),
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
                                                  Icons.straighten,
                                                  color: Colors.black,
                                                ),
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
                                                ),
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
                                  ),
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
                                    // Add recommended ProductCards here
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                } else if (state is ProductDetailsError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const Center(child: Text('loading...'));
              },
            ),
          );
        },
      ),
    );
  }
}

// Helper to parse color names to Color objects
Color _parseColor(String colorName) {
  switch (colorName.toLowerCase()) {
    case 'black':
      return Colors.black;
    case 'blue':
      return Colors.blue[900]!;
    case 'red':
      return Color(0xFFA51930);
  // Add more color mappings as needed
    default:
      return Colors.grey;
  }
}