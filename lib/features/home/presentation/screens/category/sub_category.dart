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
    debugPrint('Initializing SubCategoryScreen with parentCategoryId: $parentCategoryId');
    _loadSubCategories();
  }

  void _loadSubCategories() {
    debugPrint('Requesting subcategories for parentId: $parentCategoryId');
    context.read<EventBloc>().add(
      FetchSubCategoriesEvent(parentCategoryId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subcategories'),
        actions: [
          // Add a diagnostic button to help debug category relationships
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showDiagnosticInfo(),
            tooltip: 'Show diagnostic info',
          ),
        ],
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
                // Log the state to help with debugging
                debugPrint('State loaded: ${state.categories.length} categories, isSubcategoryView: ${state.isSubcategoryView}');
                
                // Log each category's parent ID for debugging
                if (state.categories.isNotEmpty) {
                  debugPrint('Categories received:');
                  for (var cat in state.categories) {
                    debugPrint('  - ${cat.name} (ID: ${cat.id}, parentId: ${cat.parentId})');
                  }
                }
                
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
      debugPrint('No event types found for category ID: $parentCategoryId');
      
      if (state.isSubcategoryView) {
        debugPrint('Redirecting to event list for main category');
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, AppRouts.eventList);
        });
        
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(Responsive.horizontalPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: state.categories.length,
        itemBuilder: (context, index) {
          final eventType = state.categories[index];
          
          return CategoryCard(
            title: eventType.name,
            description: eventType.description,
            imagePath: eventType.image ?? '',
            categoryId: eventType.id.toString(),
            onTap: () => _onCategorySelected(eventType.id.toString(), eventType.parentId.toString()),
          );
        },
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
              'No subcategories found for this category',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Category ID: $parentCategoryId',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Directly navigate to event list for this category
                context.read<EventBloc>().add(FilterEventsByCategoryEvent(parentCategoryId));
                Navigator.pushReplacementNamed(context, AppRouts.eventList);
              },
              child: const Text('View Events in this Category'),
            ),
          ],
        ),
      ),
    );
  }

  void _onCategorySelected(String subcategoryId, String parentId) {
    context.read<EventBloc>().add(
      FilterEventsByCategoryEvent(
        parentId,  // Main category ID
        subcategoryId: subcategoryId,  // Subcategory ID
      ),
    );
    Navigator.pushNamed(context, AppRouts.eventList);
  }

  // Add this new method for displaying diagnostic information
  void _showDiagnosticInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Subcategory Diagnostic Info'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Parent Category ID: $parentCategoryId', style: const TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              const Text('Current State:', style: TextStyle(fontWeight: FontWeight.bold)),
              
              BlocBuilder<EventBloc, EventBlocState>(
                builder: (context, state) {
                  if (state is EventsLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• Total categories: ${state.categories.length}'),
                        Text('• isSubcategoryView: ${state.isSubcategoryView}'),
                        Text('• selectedSubCategoryId: ${state.selectedSubCategoryId}'),
                        const SizedBox(height: 8),
                        if (state.categories.isNotEmpty) ...[
                          const Text('Categories in current state:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ...state.categories.map((cat) => 
                              Text('• ${cat.name} (ID: ${cat.id}, parentId: ${cat.parentId})')),
                        ],
                      ],
                    );
                  } else {
                    return Text('State type: ${state.runtimeType}');
                  }
                },
              ),
              
              const Divider(),
              const Text('Common Issues:', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text('• Category parentId might be null or mismatched'),
              const Text('• API response structure could be different than expected'),
              const Text('• Type mismatch between parentId (string vs int)'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Directly try to view events for this category
              context.read<EventBloc>().add(FilterEventsByCategoryEvent(parentCategoryId));
              Navigator.pushReplacementNamed(context, AppRouts.eventList);
            },
            child: const Text('Show Events'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
