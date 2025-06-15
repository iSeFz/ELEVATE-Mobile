import 'package:elevate/features/search/presentation/screens/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/size_config.dart';
import '../cubits/product_cubit.dart';
import '/../core/widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit()..fetchProducts(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.only(top: 20*SizeConfig.verticalBlock,
                bottom: 20*SizeConfig.verticalBlock, left: 15*SizeConfig.verticalBlock, right: 15*SizeConfig.verticalBlock),
            child: Text(
              'ELEVATE',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18*SizeConfig.textRatio,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },

            ),
          ],
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(
              color: Colors.grey[300],
              height: 1,
            ),
          ),
        ),

        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              final products = state.products;
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 per row
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  mainAxisExtent: 350 * SizeConfig.verticalBlock,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(product: products[index], userId: '',);
                },
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
