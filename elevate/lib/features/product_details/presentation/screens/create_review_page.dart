import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/review_model.dart';
import '../cubits/review_cubit.dart';
import '../cubits/review_state.dart';

class CreateReviewPage extends StatefulWidget {
  final String productId;

  const CreateReviewPage({super.key, required this.productId});

  @override
  State<CreateReviewPage> createState() => _CreateReviewPageState();
}

class _CreateReviewPageState extends State<CreateReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final ValueNotifier<int> _rating = ValueNotifier<int>(0);

  String nourdebug = "nourdeb";
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _rating.dispose();
    super.dispose();
  }

  Future<void> _submitForm(BuildContext context) async {
    final cubit = context.read<ReviewCubit>();
    final review = ReviewModel(
      productId: widget.productId,
      title: _titleController.text,
      content: _contentController.text,
      rating: _rating.value,
    );

    cubit.createReview(review);

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Review'),
        centerTitle: true,
      ),
      body: BlocConsumer<ReviewCubit, ReviewState>(
        listener: (context, state) {
          if (state is ReviewSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Review submitted successfully!')),
            );
            Navigator.pop(context);
          }
          // else if (state is ReviewError) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('Error: ${state.message}')),
          //   );
          // }
          else if (state is ReviewError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Container(
                  // height: 400, // Very big height
                  child: SingleChildScrollView(
                    child: Text(
                      'Error: ${state.message}' , // Example to make it long text
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 5), // Optional: control how long it appears
              ),
            );
          }


        },
        builder: (context, state) {
          if (state is ReviewLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration:  InputDecoration(
                      labelText: 'Review Title'+nourdebug+ widget.productId,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a review title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: 'Review Content',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please write your review';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return ValueListenableBuilder<int>(
                        valueListenable: _rating,
                        builder: (context, value, _) => IconButton(
                          icon: Icon(
                            index < value ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                          onPressed: () {
                            _rating.value = index + 1;
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: state is ReviewLoading ? null : () => _submitForm(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state is ReviewLoading
                        ? CircularProgressIndicator(color: theme.colorScheme.onPrimary)
                        : Text(
                      'Submit Review',
                      style: TextStyle(color: theme.colorScheme.onPrimary),
                    ),
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
