import 'package:flutter/material.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../core/widgets/shimmer_loading.dart';


class ImageShimmerLoading extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;


  const ImageShimmerLoading({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
   
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      isLoading: true,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 200,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(borderRadius ?? Responsive.borderRadius),
        ),
      ),
    );
  }
}