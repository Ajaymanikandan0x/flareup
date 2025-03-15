part of 'single_event_bloc.dart';

@immutable
sealed class SingleEventEvent extends Equatable {
  const SingleEventEvent();
  @override
  List<Object?> get props => [];
}

class SelectSingleEvent extends SingleEventEvent {
  final GetAllEventEntities event;

  const SelectSingleEvent(this.event);

  @override
  List<Object?> get props => [event];
}
