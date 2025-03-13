class GetEventEntities {
  final int id;
  final String title;
  final String description;
  final String category;
  final String type;
  final int hostId;
  final int organizationId;
  final double latitude;
  final double longitude;
  final String addressLine1;
  final String city;
  final String state;
  final String country;
  final bool paymentRequired;
  final double ticketPrice;
  final int participantCapacity;
  final String bannerImage;
  final String promoVideo;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final DateTime registrationDeadline;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;
  final String statusRequest;
  final String approvalStatus;
  final String approvalComments;
  final DateTime approvalUpdatedAt;
  final List<String> keyParticipants;

  GetEventEntities({
    required this.id, 
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    required this.hostId,
    required this.organizationId,
    required this.latitude,
    required this.longitude,
    required this.addressLine1,
    required this.city,
    required this.state,
    required this.country,
    required this.paymentRequired,
    required this.ticketPrice,
    required this.participantCapacity,
    required this.bannerImage,
    required this.promoVideo,
    required this.startDateTime,
    required this.endDateTime,
    required this.registrationDeadline,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.statusRequest,
    required this.approvalStatus,
    required this.approvalComments,
    required this.approvalUpdatedAt,
    required this.keyParticipants,
  });
}
