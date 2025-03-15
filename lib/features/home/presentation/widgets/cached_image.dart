import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String? imageUrl;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BoxFit? fit;

  const CachedImage({
    this.imageUrl,
    this.placeholder,
    this.errorWidget,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    final validUrl = _getValidImageUrl(imageUrl);

    if (validUrl == null) {
      return errorWidget ?? _buildDefaultErrorWidget();
    }

    return CachedNetworkImage(
      imageUrl: validUrl,
      placeholder: (context, url) => placeholder ?? _buildDefaultPlaceholder(),
      errorWidget: (context, url, error) =>
          errorWidget ?? _buildDefaultErrorWidget(),
      fit: fit ?? BoxFit.cover,
    );
  }

  String? _getValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return null;

    // If it's already a complete URL, return as is
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    // Construct full URL for partial paths
    return 'https://res.cloudinary.com/dzwjm8n8v/image/upload/v1732028654/$url';
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(Icons.image, color: Colors.grey[400]),
      ),
    );
  }

  Widget _buildDefaultErrorWidget() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(Icons.broken_image, color: Colors.grey[400]),
      ),
    );
  }
}
