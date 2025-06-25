import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/product_card.dart';
import '../cubits/product_details_cubit.dart';
import '../cubits/product_details_state.dart';

class RecommendationSection extends StatelessWidget {
  final String userId;

  const RecommendationSection({Key? key, required this.userId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        if (state is! ProductDetailsLoaded) {
          return SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0 * SizeConfig.horizontalBlock,
              ),
              child: Text(
                "You might also like",
                style: TextStyle(
                  fontSize: 18 * SizeConfig.textRatio,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 10 * SizeConfig.verticalBlock),
            SizedBox(
              height: 350 * SizeConfig.verticalBlock,
              child:
                  state.relatedProducts != null &&
                          state.relatedProducts!.isNotEmpty
                      ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0 * SizeConfig.horizontalBlock,
                        ),
                        itemCount: state.relatedProducts!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              right: 12 * SizeConfig.horizontalBlock,
                            ),
                            child: SizedBox(
                              width: 180 * SizeConfig.horizontalBlock,
                              height: 320 * SizeConfig.verticalBlock,
                              child: ProductCard(
                                product: state.relatedProducts![index],
                                userId: userId,
                              ),
                            ),
                          );
                        },
                      )
                      : Center(
                        child: Text(
                          "Loading related products...",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14 * SizeConfig.textRatio,
                          ),
                        ),
                      ),
            ),
          ],
        );
      },
    );
  }
}
