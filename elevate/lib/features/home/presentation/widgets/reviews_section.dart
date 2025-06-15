import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/rate_card.dart';
import '../screens/reviews.dart';

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0 * SizeConfig.horizontalBlock,
        ),
      child:
      Container(
        padding: EdgeInsets.symmetric(
          vertical: 10 * SizeConfig.verticalBlock,
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey[300]!,
              width: 1,
            ),
            bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
          ),
        ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReviewsBar(),
            ),
          );
        },
      child:
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            "Reviews",
            style: TextStyle(
              fontSize: 18 * SizeConfig.textRatio,
              fontWeight: FontWeight.w500,
            ),
          ),

        SizedBox(height: 20 * SizeConfig.verticalBlock),
        // RateCard(
        //   username: 'Adham_Immortal',
        //   avatarUrl:
        //       'https://domanza.co/cdn/shop/files/CCxNavy-45Large_27baa9f2-e314-4ffb-a8a9-65d1ad738bc8_jpg.jpg?v=1739309915&width=5760',
        //   comment: 'Loved the material!',
        //   stars: 5,
        // ),
        SizedBox(
          height: 20 * SizeConfig.verticalBlock,
        ),
        // RateCard(
        //   username: 'Adham_Immortal',
        //   avatarUrl:
        //   'https://domanza.co/cdn/shop/files/CCxNavy-45Large_27baa9f2-e314-4ffb-a8a9-65d1ad738bc8_jpg.jpg?v=1739309915&width=5760',
        //   comment: 'Loved the material!',
        //   stars: 1,
        // ),
        SizedBox(
          height: 10 * SizeConfig.verticalBlock,
        ),
        // Container(
        //   padding: EdgeInsets.symmetric(
        //     vertical: 10 * SizeConfig.verticalBlock,
        //   ),
        //   decoration: BoxDecoration(
        //     border: Border(
        //       top: BorderSide(
        //         color: Colors.grey[300]!,
        //         width: 1,
        //       ),
        //     ),
        //   ),
          // child: GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (_) => ReviewsBar(),
          //       ),
          //     );
          //   },
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       Text(
          //         "See more >>",
          //         style: TextStyle(
          //           color: Color(0xFFA51930),
          //           fontSize: 10 * SizeConfig.textRatio,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        // ),
      ],))
      ),
    );
  }
}