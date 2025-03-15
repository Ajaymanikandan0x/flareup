import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../home/domain/entities/get_event_entite.dart';
import '../../domain/entities/get_event_entite.dart';

part 'single_event_event.dart';
part 'single_event_state.dart';

class SingleEventLoaded extends SingleEventState {
  final GetAllEventEntities event;

  SingleEventLoaded(this.event);

  @override
  List<Object?> get props => [event];
}

class SingleEventBloc extends Bloc<SingleEventEvent, SingleEventState> {
  SingleEventBloc() : super(SingleEventInitial()) {
    on<SelectEvent>(_onSelectEvent);
  }

  Future<void> _onSelectEvent(
    SelectEvent event,
    Emitter<SingleEventState> emit,
  ) async {
    try {
      if (event.event.id == 0) {
        throw Exception('Invalid event data: Missing event ID');
      }
      emit(SingleEventLoaded(event.event));
    } catch (e) {
      emit(SingleEventError('Failed to load event: ${e.toString()}'));
    }
  }
}

class SelectEvent extends SingleEventEvent {
  final GetAllEventEntities event;

  const SelectEvent(this.event);

  @override
  List<Object?> get props => [event];
}
