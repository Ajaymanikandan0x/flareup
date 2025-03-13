import 'package:flutter/material.dart';

import '../empty_state.dart';



class CategoryEmptyState extends StatelessWidget {
  final VoidCallback? onRetry;
  final String message;

  const CategoryEmptyState({
    super.key,
    this.onRetry,
    this.message = 'No categories available at the moment',
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateCategory(
      icon: Icons.category_outlined,
      message: message,
      onRetry: onRetry,
    );
  }
}