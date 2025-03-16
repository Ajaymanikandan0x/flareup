part of 'single_event_bloc.dart';

@immutable
sealed class SingleEventEvent extends Equatable {
  const SingleEventEvent();
  @override
  List<Object?> get props => [];
}

class SelectEvent extends SingleEventEvent {
  final GetAllEventEntities event;

  const SelectEvent(this.event);

  @override
  List<Object?> get props => [event];
}

class InitializeTicketCount extends SingleEventEvent {
  final GetAllEventEntities event;

  const InitializeTicketCount(this.event);

  @override
  List<Object?> get props => [event];
}

class IncrementTicketCount extends SingleEventEvent {}

class DecrementTicketCount extends SingleEventEvent {}

class UpdateTicketCount extends SingleEventEvent {
  final int ticketCount;

  const UpdateTicketCount(this.ticketCount);

  @override
  List<Object?> get props => [ticketCount];
}
