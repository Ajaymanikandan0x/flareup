import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/get_event_entite.dart';

abstract class SingleEventState extends Equatable {
  final GetAllEventEntities? event;
  final int ticketCount;
  final double totalPrice;

  const SingleEventState({
    this.event,
    this.ticketCount = 0,
    this.totalPrice = 0,
  });

  @override
  List<Object?> get props => [event, ticketCount, totalPrice];
}

class SingleEventInitial extends SingleEventState {}

class SingleEventLoading extends SingleEventState {}

class SingleEventLoaded extends SingleEventState {
  const SingleEventLoaded(
    GetAllEventEntities event, {
    int ticketCount = 0,
    double totalPrice = 0,
  }) : super(
          event: event,
          ticketCount: ticketCount,
          totalPrice: totalPrice,
        );

  @override
  List<Object?> get props => [event, ticketCount, totalPrice];

  SingleEventLoaded copyWith({
    GetAllEventEntities? event,
    int? ticketCount,
    double? totalPrice,
  }) {
    return SingleEventLoaded(
      event ?? this.event!,
      ticketCount: ticketCount ?? this.ticketCount,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

class SingleEventError extends SingleEventState {
  final String message;

  const SingleEventError(this.message) : super();

  @override
  List<Object?> get props => [message];
}
