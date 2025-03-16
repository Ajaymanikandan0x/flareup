import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/custom_image_wid.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../home/domain/entities/get_event_entite.dart';
import '../bloc/single_event_bloc.dart';
import '../bloc/single_event_state.dart';

class TicketCountScreen extends StatefulWidget {
  const TicketCountScreen({super.key});

  @override
  State<TicketCountScreen> createState() => _TicketCountScreenState();
}

class _TicketCountScreenState extends State<TicketCountScreen> {
  late GetAllEventEntities event;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initializeEvent();
    }
  }

  void _initializeEvent() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! GetAllEventEntities) {
      _handleInvalidEvent('Invalid event data');
      return;
    }

    if (!_isEventValid(args)) {
      _handleInvalidEvent('Event is not available');
      return;
    }

    event = args;
    _initializeBloc();
    _initialized = true;
  }

  bool _isEventValid(GetAllEventEntities event) {
    return event.approvalStatus.toLowerCase() == 'approved' &&
        event.status.toLowerCase() == 'active';
  }

  void _handleInvalidEvent(String message) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _initializeBloc() {
    final bloc = context.read<SingleEventBloc>();
    bloc.add(SelectEvent(event));
    bloc.add(InitializeTicketCount(event));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingleEventBloc, SingleEventState>(
      builder: (context, state) {
        if (state is! SingleEventLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: _buildAppBar(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: Responsive.verticalPadding * 4),
                Divider(
                  thickness: 1.5,
                  color: AppPalette.darkTextSecondary,
                ),
                SizedBox(height: Responsive.verticalPadding * 1.4),
                _buildEventCard(),
                SizedBox(height: Responsive.verticalPadding * 1),
                Divider(
                  thickness: 5,
                  color: AppPalette.darkTextSecondary,
                ),
                _buildTicketCounter(state),
              ],
            ),
          ),
          bottomSheet: _buildBottomSheet(state),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Padding(
        padding: EdgeInsets.only(top: 30.0),
        child: Text('Buy Event Tickets',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            )),
      ),
      centerTitle: true,
    );
  }

  Widget _buildEventCard() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding,
        vertical: Responsive.verticalPadding / 2,
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: AppPalette.darkCard,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'event_image_${event.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomImageWidget(
                    imageUrl: "$cloudinaryBaseUrl${event.bannerImage}",
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.calendar_today,
                      _formatDate(event.startDateTime),
                      AppPalette.gradient2,
                      iconSize: 18,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.location_on,
                      "${event.city}, ${event.country}",
                      AppPalette.gradient2,
                      iconSize: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color, {double iconSize = 16}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: iconSize, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: AppPalette.darkTextSecondary,
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCounter(SingleEventState state) {
    return Padding(
      padding: EdgeInsets.all(Responsive.horizontalPadding),
      child: Card(
        color: AppPalette.darkCard,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Regular Ticket',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'IDR ${_formatPrice(state.event!.ticketPrice)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppPalette.payment,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _CounterButton(
                      icon: Icons.remove,
                      onPressed: () => context
                          .read<SingleEventBloc>()
                          .add(DecrementTicketCount()),
                    ),
                    SizedBox(width: 16),
                    Text(
                      '${state.ticketCount}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 16),
                    _CounterButton(
                      icon: Icons.add,
                      onPressed: () => context
                          .read<SingleEventBloc>()
                          .add(IncrementTicketCount()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet(SingleEventState state) {
    return Container(
      padding: EdgeInsets.all(Responsive.horizontalPadding),
      decoration: BoxDecoration(
        color: AppPalette.darkCard,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Responsive.borderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price per ticket',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'IDR ${_formatPrice(state.event!.ticketPrice)}',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quantity',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                '${state.ticketCount} tickets',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 8),
          Divider(color: Colors.grey.withAlpha(30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'IDR ${_formatPrice(state.event!.ticketPrice * state.ticketCount)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.payment,
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.verticalPadding),
          PrimaryButton(
            onTap: () {
              // TODO: Implement checkout logic
            },
            text: 'Continue to Checkout',
            width: double.infinity,
          ),
          SizedBox(height: Responsive.verticalPadding),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CounterButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey),
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(
          minWidth: 36,
          minHeight: 36,
        ),
      ),
    );
  }
}
