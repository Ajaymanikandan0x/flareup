
import 'package:flareup/core/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive_utils.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      isLoading: true,
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) => Container(
            width: 100,
            margin: EdgeInsets.only(
              right: Responsive.horizontalPadding,
              left: index == 0 ? Responsive.horizontalPadding : 0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}