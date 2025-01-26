import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../../../core/routes/routs.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../core/widgets/shimmer_loading.dart';
import '../../bloc/event_bloc.dart';
import '../../bloc/event_event.dart';
import '../../bloc/event_state.dart';
import '../../widgets/category_widget/category_card.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({super.key});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  late String parentCategoryId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the parentCategoryId from route arguments
    parentCategoryId = ModalRoute.of(context)!.settings.arguments as String;
    _loadSubCategories();
  }

  void _loadSubCategories() {
    context.read<EventBloc>().add(
      FetchSubCategoriesEvent(parentCategoryId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subcategories'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _loadSubCategories(),
          child: BlocBuilder<EventBloc, EventBlocState>(
            builder: (context, state) {
              if (state is EventLoading) {
                return _buildLoadingGrid();
              }

              if (state is EventError) {
                return _buildErrorState(state.message);
              }

              if (state is EventsLoaded) {
                return _buildContent(state);
              }

              return _buildEmptyState();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(EventsLoaded state) {
    if (state.categories.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 
                    AppBar().preferredSize.height - 
                    MediaQuery.of(context).padding.top,
        ),
        child: MasonryGridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(Responsive.horizontalPadding),
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: state.categories.length,
          itemBuilder: (context, index) {
            final category = state.categories[index];
            final image = category.eventTypes.isNotEmpty == true 
                ? category.eventTypes.first.image 
                : null;

            return SizedBox(
              height: 200,  // Fixed height for each card
              child: CategoryCard(
                title: category.name,
                description: category.description,
                imagePath: image ?? '',
                categoryId: category.id.toString(),
                onTap: () => _onCategorySelected(category.id.toString()),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 
                    AppBar().preferredSize.height - 
                    MediaQuery.of(context).padding.top,
        ),
        child: MasonryGridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(Responsive.horizontalPadding),
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ShimmerLoading(
                isLoading: true,
                child: Container(
                  width: double.infinity,
                  height: 200,  // Match the height of content cards
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadSubCategories,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No subcategories available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _onCategorySelected(String categoryId) {
    // Filter events for this subcategory
    context.read<EventBloc>().add(FilterEventsByCategoryEvent(categoryId));
    // Navigate to event list screen
    Navigator.pushNamed(context, AppRouts.eventList);
  }
}
