import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/get_event_entite.dart';
import '../../domain/entities/payment_response_entity.dart';
import '../../domain/entities/payment_session_entity.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final PaymentResponseEntity response;
  final String message;

  const PaymentSuccess({
    required this.response,
    this.message = 'Payment successful',
  });

  @override
  List<Object?> get props => [response, message];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}

class PaymentSessionCreated extends PaymentState {
  final PaymentResponseEntity sessionDetails;

  const PaymentSessionCreated(this.sessionDetails);

  @override
  List<Object?> get props => [sessionDetails];
}

class PaymentInitializing extends PaymentState {}

class PaymentInitialized extends PaymentState {
  final GetAllEventEntities event;
  final int ticketCount;
  final PaymentResponseEntity sessionDetails;

  PaymentInitialized({
    required this.event,
    required this.ticketCount,
    required this.sessionDetails,
  });

  @override
  List<Object?> get props => [event, ticketCount, sessionDetails];
}
