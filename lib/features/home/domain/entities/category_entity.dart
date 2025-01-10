class CategoryEntity {
  final int id;
  final String name;
  final String description;
  final String status;
  final DateTime updatedAt;
  final List<EventTypeEntity> eventTypes;
  final String? parentId;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.updatedAt,
    required this.eventTypes,
    this.parentId,
  });
}

class EventTypeEntity {
  final int id;
  final String name;
  final String description;
  final String status;
  final DateTime updatedAt;
  final String? image;

  EventTypeEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.updatedAt,
    this.image,
  });
}
