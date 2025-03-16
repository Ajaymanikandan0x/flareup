import 'package:equatable/equatable.dart';
import '../../domain/entities/payment_session_entity.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class CreatePaymentSessionEvent extends PaymentEvent {
  final PaymentSessionEntity session;

  const CreatePaymentSessionEvent(this.session);

  @override
  List<Object?> get props => [session];
}

class InitializePaymentEvent extends PaymentEvent {
  final Map<String, dynamic> args;

  InitializePaymentEvent(this.args);

  @override
  List<Object?> get props => [args];
}

class ProcessPaymentEvent extends PaymentEvent {
  final String paymentIntentId;

  const ProcessPaymentEvent(this.paymentIntentId);

  @override
  List<Object?> get props => [paymentIntentId];
}

class CancelPaymentEvent extends PaymentEvent {}
