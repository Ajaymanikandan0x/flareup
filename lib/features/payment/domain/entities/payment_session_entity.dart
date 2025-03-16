class PaymentSessionEntity {
  final String username;
  final String eventId;
  final String hosterId;
  final String title;
  final String price;
  final String quantity;

  PaymentSessionEntity({
    required this.username,
    required this.eventId,
    required this.hosterId,
    required this.title,
    required this.price,
    required this.quantity,
  });
}
