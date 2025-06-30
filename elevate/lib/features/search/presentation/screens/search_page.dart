import 'package:elevate/features/wishlist/presentation/cubits/wishlist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../camera/presentation/screens/camera.dart';
import '../cubits/filter/filter_cubit.dart';
import '../cubits/search/search_cubit.dart';
import '../cubits/search/search_state.dart';
import '../widgets/filter_button.dart';

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
                                    context.read<SearchCubit>().searchProducts(query: value);
                                  },
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey.shade200),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10 * SizeConfig.horizontalBlock,
                  vertical: 10 * SizeConfig.verticalBlock,
                ),
                child: Row(
                  children: [
                    // 👉 Scrollable buttons
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            FilterButton(
                              label: 'Category',
                              filterOptions: 1,
                              onFetch: () async {
                                await context.read<FilterCubit>().getAllCategories();
                              },
                              isExpanded: true,
                            ),
                            SizedBox(width: 6 * SizeConfig.horizontalBlock),
                            FilterButton(
                              label: 'Brand',
                              filterOptions: 2,
                              onFetch: () async {
                                await context.read<FilterCubit>().getAllBrands();
                              },
                            ),
                            SizedBox(width: 6 * SizeConfig.horizontalBlock),
                            FilterButton(
                              label: 'Dep',
                              filterOptions: 3,
                              onFetch: () async {
                                await context.read<FilterCubit>().getAllDepartments();
                              },
                            ),
                            SizedBox(width: 6 * SizeConfig.horizontalBlock),
                            FilterButton(
                              label: 'Color',
                              filterOptions: 4,
                              onFetch: () async {
                                await context.read<FilterCubit>().getAllColors();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 👉 Fixed icons
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Camera()),
                        );
                      },
                      child: Icon(Icons.image_outlined, size: 24 * SizeConfig.verticalBlock),
                    ),
                    SizedBox(width: 10 * SizeConfig.horizontalBlock),
                    Icon(Icons.compare_arrows_outlined, size: 24 * SizeConfig.verticalBlock),
                  ],
                ),
              ),
              ]
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
                          }
                          else if(state is SearchEmpty) {
                            return const Center(
                              child: Text(
                                'No results found.',
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }
                          else if (state is SearchLoaded)
                        {

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
