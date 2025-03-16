import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../home/domain/entities/get_event_entite.dart';
import '../../domain/usecases/get_event_usecase.dart';
import '../../domain/usecases/update_ticket_count_usecase.dart';
import 'single_event_state.dart';
import 'package:dio/dio.dart';
import '../../../../core/utils/logger.dart';

part 'single_event_event.dart';

class SingleEventBloc extends Bloc<SingleEventEvent, SingleEventState> {
  final GetEventUseCase getEventUseCase;
  final UpdateTicketCountUseCase updateTicketCountUseCase;

  SingleEventBloc({
    required this.getEventUseCase,
    required this.updateTicketCountUseCase,
  }) : super(SingleEventInitial()) {
    on<SelectEvent>(_onSelectEvent);
    on<InitializeTicketCount>(_onInitializeTicketCount);
    on<IncrementTicketCount>(_onIncrementTicketCount);
    on<DecrementTicketCount>(_onDecrementTicketCount);
  }

  Future<void> _onSelectEvent(
    SelectEvent event,
    Emitter<SingleEventState> emit,
  ) async {
    try {
      Logger.debug('Starting event selection for ID: ${event.event.id}');
      emit(SingleEventLoading());

      if (event.event.id == 0) {
        throw Exception('Invalid event data: Missing event ID');
      }

      // First try to use the passed event data
      if (event.event.bannerImage.isNotEmpty &&
          event.event.approvalStatus.toLowerCase() == 'approved' &&
          event.event.status.toLowerCase() == 'active') {
        Logger.debug('Using passed event data: ${event.event.title}');
        emit(SingleEventLoaded(event.event));
        return;
      }

      // If passed event data is incomplete, fetch from API
      Logger.debug('Fetching complete event data from API');
      final eventData = await getEventUseCase(event.event.id);
      emit(SingleEventLoaded(eventData));
    } catch (e, stackTrace) {
      Logger.error('Failed to load event:', e);
      Logger.error('Stack trace:', stackTrace);

      String errorMessage = 'Failed to load event';
      if (e is DioException) {
        errorMessage = _handleDioError(e);
      }
      emit(SingleEventError(errorMessage));
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 404) {
          return 'Event not found';
        }
        return 'Server error: ${e.response?.statusCode}';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      default:
        return 'Network error: ${e.message}';
    }
  }

  Future<void> _onInitializeTicketCount(
    InitializeTicketCount event,
    Emitter<SingleEventState> emit,
  ) async {
    if (state is SingleEventLoaded) {
      final currentState = state as SingleEventLoaded;
      emit(currentState.copyWith(
        ticketCount: 1,
        totalPrice: event.event.ticketPrice,
      ));
    }
  }

  Future<void> _onIncrementTicketCount(
    IncrementTicketCount event,
    Emitter<SingleEventState> emit,
  ) async {
    if (state is SingleEventLoaded) {
      final currentState = state as SingleEventLoaded;
      final newCount = currentState.ticketCount + 1;
      final newPrice = newCount * currentState.event!.ticketPrice;

      try {
        await updateTicketCountUseCase(currentState.event!.id, newCount);
        emit(currentState.copyWith(
          ticketCount: newCount,
          totalPrice: newPrice,
        ));
      } catch (e) {
        emit(
            SingleEventError('Failed to update ticket count: ${e.toString()}'));
      }
    }
  }

  Future<void> _onDecrementTicketCount(
    DecrementTicketCount event,
    Emitter<SingleEventState> emit,
  ) async {
    if (state is SingleEventLoaded) {
      final currentState = state as SingleEventLoaded;
      if (currentState.ticketCount > 1) {
        final newCount = currentState.ticketCount - 1;
        final newPrice = newCount * currentState.event!.ticketPrice;

        try {
          await updateTicketCountUseCase(currentState.event!.id, newCount);
          emit(currentState.copyWith(
            ticketCount: newCount,
            totalPrice: newPrice,
          ));
        } catch (e) {
          emit(SingleEventError(
              'Failed to update ticket count: ${e.toString()}'));
        }
      }
    }
  }
}
