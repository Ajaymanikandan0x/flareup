import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/utils/logger.dart';
import '../../domain/entities/get_event_entite.dart';

part 'single_event_event.dart';
part 'single_event_state.dart';

class SingleEventBloc extends Bloc<SingleEventEvent, SingleEventState> {
  SingleEventBloc() : super(SingleEventInitial()) {
    on<SelectEvent>(_onSelectEvent);
  
  }

  Future<void> _onSelectEvent(
    SelectEvent event,
    Emitter<SingleEventState> emit,
  ) async {
    try {
      Logger.debug('Selecting event: ${event.event.title}');
      
      emit(SingleEventLoading());
      
      if (event.event.id == 0) {
        throw Exception('Invalid event data: Missing event ID');
      }

      emit(SingleEventLoaded(event.event));
      Logger.debug('Event selected successfully');
      
    } catch (e, stackTrace) {
      Logger.error('Error selecting event:', e, stackTrace);
      emit(SingleEventError('Failed to load event: ${e.toString()}'));
    }
  }

  
}
