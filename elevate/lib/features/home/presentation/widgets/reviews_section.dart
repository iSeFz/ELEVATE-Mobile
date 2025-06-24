import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/rate_card.dart';
import '../../data/models/review_model.dart';
import '../cubits/review_cubit.dart';
import '../cubits/review_state.dart';
import '../screens/reviews_page.dart';
class ReviewsSection extends StatelessWidget {
  final String productId;
  final String userId;

  const ReviewsSection(
      {super.key, required this.productId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      ReviewCubit()
        ..fetchProductReviews(productId),
      child: BlocBuilder<ReviewCubit, ReviewState>(
        builder: (context, state) {
          if (state is ReviewInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ReviewError) {
            return Center(child: Text(
                'Error: ${state.message}')); // Fix: display the error message
          }

          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 8.0 * SizeConfig.horizontalBlock),
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: 10 * SizeConfig.verticalBlock),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!, width: 1),
                  bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => ReviewsBar()));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text(
                          "Reviews",
                          style: TextStyle(
                            fontSize: 18 * SizeConfig.textRatio,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "see more >>",
                          style: TextStyle(
                            fontSize: 11 * SizeConfig.textRatio,
                            color: Theme.of(context).primaryColor
                            // fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20 * SizeConfig.verticalBlock),
                    if (state is ReviewLoaded && state.reviews.isNotEmpty)
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15 * SizeConfig.horizontalBlock),
                          child:
                              Column(
                                children: [

                                  RateCard(review: state.reviews[0]),
                                  SizedBox(height: 20 * SizeConfig.verticalBlock),
                                  RateCard(review: state.reviews[1])]
                              )
                          )

                    else
                      Text('No reviews yet.'),
                    SizedBox(height: 10 * SizeConfig.verticalBlock),
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
