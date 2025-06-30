import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/brand_products_cubit.dart';
// import '../cubits/brand_products_state.dart';
import 'package:elevate/core/widgets/product_card.dart';
import 'package:elevate/core/utils/size_config.dart';

class BrandProductsPage extends StatelessWidget {
  final String brandId;
  final String brandName;
  const BrandProductsPage({required this.brandId, required this.brandName});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BrandProductsCubit()..fetchInitial(brandId),
      child: Scaffold(
        appBar: AppBar(title: Text(brandName)),
        body: BlocBuilder<BrandProductsCubit, BrandProductsState>(
          builder: (context, state) {
            if (state is BrandProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BrandProductsError) {
              return Center(child: Text(state.message));
            } else if (state is BrandProductsLoaded) {
              final products = state.products;
              final hasNextPage = state.hasNextPage;
              final isLoadingMore = state.isLoadingMore;
              return Column(
                children: [
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && hasNextPage && !isLoadingMore) {
                          context.read<BrandProductsCubit>().loadMore(brandId);
                        }
                        return false;
                      },
                      child: GridView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          mainAxisExtent: 350 * (SizeConfig.verticalBlock ?? 1),
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
                      child: const CircularProgressIndicator(),
                    ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
} 