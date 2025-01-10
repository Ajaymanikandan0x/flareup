import 'package:flareup/core/routes/routs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../core/widgets/shimmer_loading.dart';
import '../../bloc/event_bloc.dart';
import '../../bloc/event_event.dart';
import '../../bloc/event_state.dart';
import '../../widgets/category_widget/category_card.dart';


import '../../widgets/category_widget/empty_caregory.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch categories when screen loads
    context.read<EventBloc>().add(const FetchCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search TextField
            Padding(
              padding: EdgeInsets.all(Responsive.horizontalPadding),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search event..',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.tune),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? AppPalette.darkCard
                      : AppPalette.lightCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Categories Grid with BlocBuilder
            Expanded(
              child: BlocBuilder<EventBloc, EventBlocState>(
                builder: (context, state) {
                  if (state is EventLoading) {
                    return GridView.builder(
                      padding: EdgeInsets.all(Responsive.horizontalPadding),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: 6, // Show 6 shimmer items while loading
                      itemBuilder: (context, index) {
                        return ShimmerLoading(
                          isLoading: true,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  if (state is EventError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is EventsLoaded) {
                    return _buildContent(state);
                  }

                  return const Center(child: Text('No categories available'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(EventsLoaded state) {
    if (state.categories.isEmpty) {
      return CategoryEmptyState(
        message: state.searchError ?? 'No categories available at the moment',
        onRetry: () {
          context.read<EventBloc>().add(const FetchCategoriesEvent());
        },
      );
    }
    return GridView.builder(
      padding: EdgeInsets.all(Responsive.horizontalPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: state.categories.length,
      itemBuilder: (context, index) {
        final category = state.categories[index];
        final image = category.eventTypes.isNotEmpty
            ? category.eventTypes.first.image ?? ""
            : "";

        return CategoryCard(
          title: category.name,
          description: category.description,
          imagePath: image,
          categoryId: category.id.toString(),
          onTap: () {
            // Navigate to subcategories screen
            Navigator.pushNamed(context, AppRouts.subCategories,
                arguments: category.id.toString());
          },
        );
      },
    );
  }
}
