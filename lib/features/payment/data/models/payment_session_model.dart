import '../../domain/entities/payment_response_entity.dart';
import '../../domain/entities/payment_session_entity.dart';

class PaymentSessionModel {
  final String username;
  final String eventId;
  final String hosterId;
  final String title;
  final String price;
  final String quantity;

  PaymentSessionModel({
    required this.username,
    required this.eventId,
    required this.hosterId,
    required this.title,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'event_id': eventId,
      'hoster_id': hosterId,
      'title': title,
      'price': price,
      'quantity': quantity,
    };
  }

  factory PaymentSessionModel.fromEntity(PaymentSessionEntity entity) {
    return PaymentSessionModel(
      username: entity.username,
      eventId: entity.eventId,
      hosterId: entity.hosterId,
      title: entity.title,
      price: entity.price,
      quantity: entity.quantity,
    );
  }
}

class PaymentResponseModel {
  final String sessionId;
  final String paymentIntentId;
  final String clientSecret;
  final String status;
  final double amount;
  final String currency;

  PaymentResponseModel({
    required this.sessionId,
    required this.paymentIntentId,
    required this.clientSecret,
    required this.status,
    required this.amount,
    required this.currency,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      sessionId: json['session_id'] ?? '',
      paymentIntentId: json['payment_intent_id'] ?? '',
      clientSecret: json['client_secret'] ?? '',
      status: json['status'] ?? '',
      amount: double.parse(json['amount']?.toString() ?? '0'),
      currency: json['currency'] ?? 'USD',
    );
  }

  PaymentResponseEntity toEntity() {
    return PaymentResponseEntity(
      sessionId: sessionId,
      paymentIntentId: paymentIntentId,
      clientSecret: clientSecret,
      status: status,
      amount: amount,
      currency: currency,
    );
  }
}
