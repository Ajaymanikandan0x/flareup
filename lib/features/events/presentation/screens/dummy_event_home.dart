class DummyEventHome {
  final int id;
  final String title;
  final String description;
  final String bannerImage;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String addressLine1;
  final String city;
  final double ticketPrice;
  final int participantCount;
  final int maxParticipants;
  final bool isPaymentRequired;
  final String category;
  final String type;
  final int hostId;
  final double latitude;
  final double longitude;
  final String state;
  final String country;
  final bool paymentRequired;
  final int participantCapacity;
  final String promoVideo;
  final DateTime registrationDeadline;
  final List<int> keyParticipants;

  DummyEventHome({
    required this.keyParticipants,
    required this.id,
    required this.title,
    required this.description,
    required this.bannerImage,
    required this.promoVideo,
    required this.startDateTime,
    required this.endDateTime,
    required this.registrationDeadline,
    required this.addressLine1,
    required this.city,
    required this.ticketPrice,
    required this.participantCount,
    required this.maxParticipants,
    required this.isPaymentRequired,
    required this.category,
    required this.type,
    required this.hostId,
    required this.latitude,
    required this.longitude,
    required this.state,
    required this.country,
    required this.paymentRequired,
    required this.participantCapacity,
  });

  static DummyEventHome get sampleEvent => DummyEventHome(
        keyParticipants: [1, 2, 3],
        id: 1,
        title: 'Summer Music Festival 2024',
        description: 'Join us for an unforgettable summer music festival!',
        bannerImage:
            'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3',
        promoVideo: 'https://www.youtube.com/watch?v=video_id',
        startDateTime: DateTime.now().add(const Duration(days: 30)),
        endDateTime: DateTime.now().add(const Duration(days: 31)),
        registrationDeadline: DateTime.now().add(const Duration(days: 29)),
        addressLine1: 'Central Park',
        city: 'New York',
        ticketPrice: 149.99,
        participantCount: 156,
        maxParticipants: 500,
        isPaymentRequired: true,
        category: 'Music',
        type: 'Festival',
        hostId: 123,
        latitude: 9.931233,
        longitude: 76.267303,
        state: 'New York',
        country: 'USA',
        paymentRequired: true,
        participantCapacity: 500,
      );
}
