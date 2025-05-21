import 'package:flutter/material.dart';

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
            _buildReviewCard(
              username: 'Adham_Immortal',
              avatarUrl:
              'https://domanza.co/cdn/shop/files/CCxNavy-45Large_27baa9f2-e314-4ffb-a8a9-65d1ad738bc8_jpg.jpg?v=1739309915&width=5760',
              comment: 'Loved the material!',
            ),
            const SizedBox(height: 40),
            _buildReviewCard(
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

  Widget _buildReviewCard({
    required String username,
    required String avatarUrl,
    required String comment,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Comment box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 24, left: 12, right: 12, bottom: 16),
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!, width: 0.5),
          ),
          child: Text(
            comment,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Avatar + Username box
        Positioned(
          top: -5,
          left: 0,
          child: Container(
            // padding:  EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            child: Row(
              // clipBehavior: Clip.none,
              // alignment: Alignment.centerLeft,
              children: [
                CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
                // SizedBox(width: 46),
                Container(
                padding:  EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                    // topLeft: Radius.circular(0),
                    // bottomLeft: Radius.circular(0),
                  ),
                  border: Border(
                    top: BorderSide(color: Colors.black12),
                    right: BorderSide(color: Colors.black12),
                    bottom: BorderSide(color: Colors.black12),
                    // left: BorderSide(color: Colors.transparent), // ignore left border
                  ),
              ),
              child:Text(
                  username,
                  style:  TextStyle(
                    fontSize: 10,
                    color: Color(0xFF160202),
                  ),
                ),),
              ],
            ),
          ),
        ),

        // Star box
        Positioned(
          top: 5,
          right: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              // border: Border.all(color: Color(0xFFA51930)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                5,
                    (index) => const Icon(Icons.star, size: 12, color: Colors.amber),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
