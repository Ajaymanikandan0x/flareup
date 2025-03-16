import '../entities/payment_response_entity.dart';
import '../entities/payment_session_entity.dart';

abstract class PaymentRepository {
  Future<PaymentResponseEntity> createPaymentSession(
      PaymentSessionEntity paymentSession);
  Future<PaymentResponseEntity> processPayment(String paymentIntentId);
}
