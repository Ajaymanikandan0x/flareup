import '../repositories/payment_repository.dart';
import '../entities/payment_response_entity.dart';

class ProcessPaymentUseCase {
  final PaymentRepository repository;

  ProcessPaymentUseCase(this.repository);

  Future<PaymentResponseEntity> call(String paymentIntentId) {
    return repository.processPayment(paymentIntentId);
  }
}
