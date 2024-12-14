import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:home_hub_provider_final/utils/extension.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_color.dart';
import 'model/UserData.dart';
import 'model/reviews.dart';


class ReviewContainer extends StatelessWidget {
Reviews reviews;
UserData userDataList;
ReviewContainer({required this.reviews, required this.userDataList});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: greyColor.withOpacity(0.1),
                offset: const Offset(2, 2),
                blurStyle: BlurStyle.outer,
              )
            ],
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            1.h.addHSpace(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               Row(
                 children: [
                   Container(
                     height: 60,
                     width: 60,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(100),
                     ),
                     child: ClipRRect(
                       borderRadius: BorderRadius.circular(100),
                       child:userDataList.profileImage == ""
                           ? Image.asset(
                         "assets/images/profile_image.jpg",
                         fit: BoxFit.fill,
                       )
                           : CachedNetworkImage(
                         placeholder: (context, url) {
                           return LoadingAnimationWidget
                               .hexagonDots(
                               color: appColor, size: 3.h);
                         },
                         fit: BoxFit.fill,
                         imageUrl:
                         userDataList.profileImage,
                       ),
                     ),
                   ),
                   2.w.addWSpace(),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         "Parth Vyas",
                         style: TextStyle(fontSize: 20),
                       ),
                       Text("27 Aug 2017")
                     ],
                   ),
                 ],
               ),
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: reviews.ratings,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20.0,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    Icon(Icons.star_rate),
                  ],
                ),
              ],
            ),
            1.h.addHSpace(),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 12),
              child: Text("${reviews.description}" ,maxLines: 3,style: TextStyle(overflow: TextOverflow.ellipsis),textAlign: TextAlign.start),
            ),
            1.h.addHSpace(),
          ],
        ),
      ),
    );
  }
}
