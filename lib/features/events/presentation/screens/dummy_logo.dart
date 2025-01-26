class DummyEvent {
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
  final String organizer;
  final String category;

  DummyEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.bannerImage,
    required this.startDateTime,
    required this.endDateTime,
    required this.addressLine1,
    required this.city,
    required this.ticketPrice,
    required this.participantCount,
    required this.maxParticipants,
    required this.isPaymentRequired,
    required this.organizer,
    required this.category,
  });

  static DummyEvent get sampleEvent => DummyEvent(
        id: 1,
        title: 'Summer Music Festival 2024',
        description: 'Join us for an unforgettable summer music festival!',
        bannerImage:
            'https://images.unsplash.com/photo-1520074189855-c26f27cc7ac8?q=80&w=2058&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        startDateTime: DateTime.now().add(const Duration(days: 30)),
        endDateTime: DateTime.now().add(const Duration(days: 31)),
        addressLine1: 'Central Park',
        city: 'New York',
        ticketPrice: 149.99,
        participantCount: 156,
        maxParticipants: 500,
        isPaymentRequired: true,
        organizer: 'EventMaster Productions',
        category: 'Music',
      );
}
