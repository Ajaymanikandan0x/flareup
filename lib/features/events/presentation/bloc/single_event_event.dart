part of 'single_event_bloc.dart';

@immutable
sealed class SingleEventEvent extends Equatable {
  const SingleEventEvent();
  @override
  List<Object?> get props => [];
}

class SelectEvent extends SingleEventEvent {
  final GetEventEntities event;

  const SelectEvent(this.event);

  @override
  List<Object?> get props => [event];
}
