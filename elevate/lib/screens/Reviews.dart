import 'package:flutter/material.dart';
import 'package:elevate/screens/Rate_Card.dart';

class ReviewsBar extends StatefulWidget {
  const ReviewsBar({super.key});

  @override
  State<ReviewsBar> createState() => _ReviewsBarState();
}

class _ReviewsBarState extends State<ReviewsBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        elevation: 0,  // remove default shadow
        backgroundColor: Colors.white,  // or your app bar color
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1), // height of the shadow line
          child: Container(
            color: Colors.grey[300],  // thin gray line color
            height: 1,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
        child: Column(
          children: [
            RateCard(
              username: 'Adham_Immortal',
              avatarUrl:
              'https://domanza.co/cdn/shop/files/CCxNavy-45Large_27baa9f2-e314-4ffb-a8a9-65d1ad738bc8_jpg.jpg?v=1739309915&width=5760',
              comment: 'Loved the material!',
            ),
            const SizedBox(height: 40),
            RateCard(
              username: 'Belal_Ahmedd',
              avatarUrl:
              'https://domanza.co/cdn/shop/files/CCxNavy-45Large_27baa9f2-e314-4ffb-a8a9-65d1ad738bc8_jpg.jpg?v=1739309915&width=5760',
              comment: 'Had fun AR',
            ),
          ],
        ),
      ),
    );
  }

}
