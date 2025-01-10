import '../../domain/entities/get_event_entite.dart';

class GetEventModel extends GetEventEntities {
  GetEventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.type,
    required super.hostId,
    required super.organizationId,
    required super.latitude,
    required super.longitude,
    required super.addressLine1,
    required super.city,
    required super.state,
    required super.country,
    required super.paymentRequired,
    required super.ticketPrice,
    required super.participantCapacity,
    required super.bannerImage,
    required super.promoVideo,
    required super.startDateTime,
    required super.endDateTime,
    required super.registrationDeadline,
    required super.createdAt,
    required super.updatedAt,
    required super.status,
    required super.statusRequest,
    required super.approvalStatus,
    required super.approvalComments,
    required super.approvalUpdatedAt,
    required super.keyParticipants,
  });

  factory GetEventModel.fromJson(Map<String, dynamic> json) {
    return GetEventModel(
      id: int.parse(json['id'].toString()),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      hostId: int.parse(json['host_id'].toString()),
      organizationId: json['organization_id'] != null
          ? int.parse(json['organization_id'].toString())
          : 0,
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      addressLine1: json['address_line_1']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      paymentRequired: json['payment_required'] == true,
      ticketPrice: double.parse(json['ticket_price'].toString()),
      participantCapacity: int.parse(json['participant_capacity'].toString()),
      bannerImage: json['banner_image']?.toString() ?? '',
      promoVideo: json['promo_video']?.toString() ?? '',
      startDateTime: DateTime.parse(json['start_date_time'].toString()),
      endDateTime: DateTime.parse(json['end_date_time'].toString()),
      registrationDeadline:
          DateTime.parse(json['registration_deadline'].toString()),
      createdAt: DateTime.parse(json['created_at'].toString()),
      updatedAt: DateTime.parse(json['updated_at'].toString()),
      status: json['status']?.toString() ?? '',
      statusRequest: json['status_request']?.toString() ?? '',
      approvalStatus: json['approval_status']?.toString() ?? '',
      approvalComments: json['approval_comments']?.toString() ?? '',
      approvalUpdatedAt: json['approval_updated_at'] != null
          ? DateTime.parse(json['approval_updated_at'].toString())
          : DateTime.now(),
      keyParticipants: (json['key_participants'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'type': type,
      'host_id': hostId,
      'organization_id': organizationId,
      'latitude': latitude,
      'longitude': longitude,
      'address_line_1': addressLine1,
      'city': city,
      'state': state,
      'country': country,
      'payment_required': paymentRequired,
      'ticket_price': ticketPrice,
      'participant_capacity': participantCapacity,
      'banner_image': bannerImage,
      'promo_video': promoVideo,
      'start_date_time': startDateTime.toIso8601String(),
      'end_date_time': endDateTime.toIso8601String(),
      'registration_deadline': registrationDeadline.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'status': status,
      'status_request': statusRequest,
      'approval_status': approvalStatus,
      'approval_comments': approvalComments,
      'approval_updated_at': approvalUpdatedAt.toIso8601String(),
      'key_participants': keyParticipants,
    };
  }

  GetEventEntities toEntity() {
    return this;
  }
}
