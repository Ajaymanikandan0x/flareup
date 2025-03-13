part of 'single_event_bloc.dart';

@immutable
sealed class SingleEventState {}

final class SingleEventInitial extends SingleEventState {}

final class SingleEventLoading extends SingleEventState {}

final class SingleEventLoaded extends SingleEventState {
  final GetEventEntities event;

  SingleEventLoaded(this.event);
}

final class SingleEventError extends SingleEventState {
  final String message;

  SingleEventError(this.message);
}
