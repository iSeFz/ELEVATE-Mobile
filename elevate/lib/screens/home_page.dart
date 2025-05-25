import 'package:flutter/material.dart';
import 'package:elevate/custom_widgets/product_card.dart';
import 'package:elevate/models/wishlist_product.dart';
import 'package:elevate/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elevate/custom_widgets/product_card.dart';
import 'package:elevate/models/wishlist_product.dart';

import 'package:elevate/cubits/product_cubit.dart'; // Adjust import path

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit()..fetchProducts(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text('Home'), backgroundColor: Colors.white,),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              final products = state.products;
              return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: products
                        .map((product) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ProductCard(product: product),
                    ))
                        .toList(),
                  ),

              );
            } else if (state is ProductError) {
              return Center(child: Text(state.message));
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
