import 'package:elevate/features/product_details/data/models/review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/size_config.dart';
import '../cubits/review_cubit.dart';
import '../cubits/review_state.dart';
import '../widgets/rate_card.dart';
import 'create_review_page.dart';

class ReviewsPage extends StatelessWidget {
  final String productId;

  const ReviewsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReviewCubit>();
    List<ReviewModel> reviews = cubit.reviews;
  return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reviews',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey[300],
            height: 1,
          ),
        ),
      ),
      body:  BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        List<ReviewModel> reviews = context.read<ReviewCubit>().reviews;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24 * SizeConfig.horizontalBlock, vertical: 26 * SizeConfig.verticalBlock),
          child: Column(
            children: reviews.map((review) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: RateCard(review: review),
              );
            }).toList(),
          ),
        );
      },
      ),

    bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 13*SizeConfig.horizontalBlock),
          height: 60,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.add, size: 30),
                onPressed: () {
                  if (cubit.canCustomerReview(productId) == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('You have already reviewed this product.')),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: cubit,
                        child: CreateReviewPage(productId: productId),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

    );

  }
}
