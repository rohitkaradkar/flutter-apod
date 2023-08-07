import 'package:json_annotation/json_annotation.dart';

part 'picture_response.g.dart';

@JsonSerializable()
class PictureResponse {
  final String copyright;
  final DateTime date;
  final String explanation;
  @JsonKey(name: 'hdurl')
  final String hdImageUrl;
  @JsonKey(name: 'url')
  final String imageUrl;
  final String title;

  PictureResponse({
    required this.copyright,
    required this.date,
    required this.explanation,
    required this.hdImageUrl,
    required this.imageUrl,
    required this.title,
  });

  factory PictureResponse.fromJson(Map<String, dynamic> json) =>
      _$PictureResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PictureResponseToJson(this);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PictureResponse &&
            runtimeType == other.runtimeType &&
            copyright == other.copyright &&
            date == other.date &&
            explanation == other.explanation &&
            hdImageUrl == other.hdImageUrl &&
            imageUrl == other.imageUrl &&
            title == other.title;
  }

  @override
  int get hashCode {
    return copyright.hashCode ^
        date.hashCode ^
        explanation.hashCode ^
        hdImageUrl.hashCode ^
        imageUrl.hashCode ^
        title.hashCode;
  }
}
