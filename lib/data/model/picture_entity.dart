import 'package:hive/hive.dart';

part 'picture_entity.g.dart';

@HiveType(typeId: 0)
class PictureEntity {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final String explanation;

  @HiveField(2)
  final String? hdImageUrl;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final String title;

  @HiveField(5)
  final String? copyright;

  PictureEntity({
    required this.date,
    required this.explanation,
    required this.hdImageUrl,
    required this.imageUrl,
    required this.title,
    this.copyright,
  });

  PictureEntity copyWith({
    DateTime? date,
    String? explanation,
    String? hdImageUrl,
    String? imageUrl,
    String? title,
    String? copyRight,
  }) {
    return PictureEntity(
      date: date ?? this.date,
      explanation: explanation ?? this.explanation,
      hdImageUrl: hdImageUrl ?? this.hdImageUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
    );
  }
}
