import 'package:flareup/core/routes/routs.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/search_bar.dart';

class SearchEvents extends StatelessWidget {
  const SearchEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSearchSection(context);
  }

  Widget _buildSearchSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.horizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: EventSearchBar(),
          ),
          const SizedBox(width: 8),
          Material(
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(),
                ),
                child: IconButton(
                  icon: Icon(Icons.tune),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouts.category);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
