part of 'single_event_bloc.dart';

@immutable
sealed class SingleEventState {}

final class SingleEventInitial extends SingleEventState {}

final class SingleEventLoading extends SingleEventState {}

final class SingleEventLoadedState extends SingleEventState {
  final GetAllEventEntities event;

  SingleEventLoadedState(this.event);
}

final class SingleEventError extends SingleEventState {
  final String message;

  SingleEventError(this.message);
}
