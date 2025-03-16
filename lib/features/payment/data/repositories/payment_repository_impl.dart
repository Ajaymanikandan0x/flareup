import '../../domain/entities/payment_response_entity.dart';
import '../../domain/entities/payment_session_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_datasource.dart';
import '../models/payment_session_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<PaymentResponseEntity> createPaymentSession(
      PaymentSessionEntity payment) async {
    final model = PaymentSessionModel.fromEntity(payment);
    final response = await remoteDataSource.createPaymentSession(model);
    return PaymentResponseModel.fromJson(response.data!).toEntity();
  }

  @override
  Future<PaymentResponseEntity> processPayment(String paymentIntentId) async {
    final response = await remoteDataSource.processPayment(paymentIntentId);
    return PaymentResponseModel.fromJson(response.data!).toEntity();
  }
}
