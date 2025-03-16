import '../entities/payment_response_entity.dart';
import '../entities/payment_session_entity.dart';
import '../repositories/payment_repository.dart';

class CreatePaymentSessionUseCase {
  final PaymentRepository repository;

  CreatePaymentSessionUseCase(this.repository);

  Future<PaymentResponseEntity> call(PaymentSessionEntity payment) {
    return repository.createPaymentSession(payment);
  }
}
