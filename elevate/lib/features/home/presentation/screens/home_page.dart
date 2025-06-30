import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/size_config.dart';
import '../cubits/home_cubit.dart';
import '../cubits/home_state.dart';
import '/../core/widgets/product_card.dart';
import '/core/widgets/video_player_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../cart/presentation/cubits/cart_cubit.dart';
import '../../../wishlist/presentation/cubits/wishlist_cubit.dart';
import '../../../wishlist/presentation/cubits/wishlist_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      // Initialize HomeCubit and fetch products grouped by department
      create:
          (_) =>
              HomeCubit()..fetchProductsByDepartments(['Men', 'Women', 'Kids']),
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
                color: theme.colorScheme.primary,
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
        body: MultiBlocListener(
          listeners: [
            BlocListener<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is HomeError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
            ),
            BlocListener<WishlistCubit, WishlistState>(
              listener: (context, state) {
                if (state is WishlistProductRemoved) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Product removed from wishlist')),
                  );
                } else if (state is WishlistProductAdded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Product added to wishlist')),
                  );
                } else if (state is WishlistError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: theme.primaryColor,
                    ),
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final departmentProducts = context.read<HomeCubit>().departmentProducts;

              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video with overlayed phrase
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 9 / 16,
                          child: VideoPlayerWidget(
                            assetPath: 'assets/hs_video.mp4',
                          ),
                        ),
                        Positioned(
                          bottom: 40,
                          child: Text(
                            'Summer is here!',
                            style: GoogleFonts.lobster(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 32 * SizeConfig.textRatio,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(blurRadius: 10, color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Products by department (only non-empty ones)
                    ...departmentProducts.entries
                        .where((entry) => entry.value.isNotEmpty)
                        .map(
                          (entry) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      (entry.key.toLowerCase() == 'men' ||
                                              entry.key.toLowerCase() ==
                                                  'women' ||
                                              entry.key.toLowerCase() == 'kids')
                                          ? 32.0
                                          : 16.0,
                                  vertical: 8.0,
                                ),
                                child: Text(
                                  entry.key,
                                  style: TextStyle(
                                    fontSize: 20 * SizeConfig.textRatio,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 350 * SizeConfig.verticalBlock,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  itemCount: entry.value.length,
                                  separatorBuilder:
                                      (_, __) => const SizedBox(width: 12),
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      width: 200 * SizeConfig.horizontalBlock,
                                      child: BlocBuilder<WishlistCubit, WishlistState>(
                                        builder: (context, state) {
                                          return ProductCard(
                                            product: entry.value[index],
                                            userId: context.read<CartCubit>().userId,
                                            // Here we get the userId from the cart cubit which seems to be confusing but we use the provided cubits to get the information we need
                                            // It is not the best practice but it is a workaround to avoid passing the whole profile cubit to the whole app
                                          );
                                        }
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),

                    // OPTIONAL: Uncomment if you want to show empty categories as well
                    /*
                    ...departmentProducts.entries
                        .where((entry) => entry.value.isEmpty)
                        .map((entry) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                '${entry.key} has no products available.',
                                style: TextStyle(
                                  fontSize: 16 * SizeConfig.textRatio,
                                  color: Colors.grey,
                                ),
                              ),
                            )),
                    */
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
