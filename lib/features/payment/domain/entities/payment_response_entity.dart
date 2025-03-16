class PaymentResponseEntity {
  final String sessionId;
  final String paymentIntentId;
  final String clientSecret;
  final String status;
  final double amount;
  final String currency;

  PaymentResponseEntity({
    required this.sessionId,
    required this.paymentIntentId,
    required this.clientSecret,
    required this.status,
    required this.amount,
    required this.currency,
  });
}
