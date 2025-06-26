import 'package:elevate/features/product_details/data/models/product_card_model.dart';
import 'package:elevate/features/search/data/models/brand_model.dart';
import 'package:elevate/features/wishlist/presentation/cubits/wishlist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../camera/presentation/screens/camera.dart';
import '../cubits/filter/filter_cubit.dart';
import '../cubits/filter/filter_state.dart';
import '../cubits/search/search_cubit.dart';
import '../cubits/search/search_state.dart';
import '../widgets/filter_button.dart';
import '../widgets/filters_row.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WishlistCubit>(
          create: (context) => WishlistCubit(),
        ),
        BlocProvider<SearchCubit>(
          create: (_) => SearchCubit(),
        ),
        BlocProvider<FilterCubit>(
          create: (_) => FilterCubit()
        ),
      ],
      child: Builder(
        builder: (context) {
          // cubit.getAllBrands();
          // final List<String> brands = cubit.brands;
          // final List<ProductCardModel>products = cubit.products;
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16 * SizeConfig.horizontalBlock),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12 * SizeConfig.horizontalBlock,
                                  vertical: 10 * SizeConfig.verticalBlock,
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    hintText: 'Pants, Shoes, etc.',
                                    hintStyle: TextStyle(
                                      fontSize: 14 * SizeConfig.textRatio,
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.search,
                                      size: 20 * SizeConfig.verticalBlock,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12 * SizeConfig.verticalBlock,
                                    ),
                                  ),
                                  textInputAction: TextInputAction.search,
                                  onSubmitted: (value) {
                                    context.read<SearchCubit>().searchProducts(value);
                                  },
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey.shade200),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10 * SizeConfig.horizontalBlock,
                                  vertical: 10 * SizeConfig.verticalBlock,
                                ),
                                child:FiltersRow()

                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: BlocBuilder<SearchCubit, SearchState>(
                        builder: (context, state) {
                          if (state is SearchLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is SearchLoaded) {

                            // final cubit = context.read<SearchCubit>();
                            // final List<ProductCardModel>products = cubit.products;
                            return GridView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: state.products.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                mainAxisExtent: 350 * SizeConfig.verticalBlock,
                              ),
                              itemBuilder: (context, index) {
                                return ProductCard(
                                  product: state.products[index],
                                  userId: '',
                                );
                              },
                            );
                          } else if (state is SearchError) {
                            return Center(child: Text('Error: ${state.message}'));
                          }
                          return const Center(child: Text('Start searching...'));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }


}
