import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/size_config.dart';
import '../cubits/home_cubit.dart';
import '../cubits/home_state.dart';
import '/../core/widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Initialize HomeCubit and fetch the first page of products
      create: (_) => HomeCubit()..fetchProductPage(1),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.only(
              top: 20 * SizeConfig.verticalBlock,
              bottom: 20 * SizeConfig.verticalBlock,
              left: 15 * SizeConfig.verticalBlock,
              right: 15 * SizeConfig.verticalBlock,
            ),
            child: Text(
              'ELEVATE',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 24 * SizeConfig.textRatio,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(color: Colors.grey[300], height: 1),
          ),
        ),
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is HomeError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final homeCubit = context.read<HomeCubit>();
            if (state is HomeLoaded || state is HomeLoadingMore) {
              final products = homeCubit.homePageProducts;
              final isLoadingMore = homeCubit.isLoadingMore;

              return Column(
                children: [
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent &&
                            !isLoadingMore) {
                          homeCubit.loadMoreProducts();
                        }
                        return false;
                      },
                      child: GridView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 per row
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          mainAxisExtent: 350 * SizeConfig.verticalBlock,
                        ),
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: products[index],
                            userId: '',
                          );
                        },
                      ),
                    ),
                  ),
                  if (isLoadingMore)
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.transparent,
                      child: CircularProgressIndicator(),
                    ),
                ],
              );
            } else if (state is HomeLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
