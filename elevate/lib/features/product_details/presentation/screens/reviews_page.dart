import 'package:elevate/features/product_details/data/models/review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/rate_card.dart';
import '../cubits/review_cubit.dart';
import 'create_review_page.dart';

class ReviewsBar extends StatelessWidget {
  final List<ReviewModel> reviews;

  const ReviewsBar({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
        child: Column(
          children: reviews.map((review) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: RateCard(review: review),
            );
          }).toList(),
        ),
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
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (context) => ReviewCubit(),
                      child: CreateReviewPage(productId: reviews.first.productId!),
                    ),
                  ));

                },
              ),
            ],
          ),
        ),
      ),

    );

  }
}
