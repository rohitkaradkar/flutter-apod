// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picture_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PictureResponse _$PictureResponseFromJson(Map<String, dynamic> json) =>
    PictureResponse(
      copyright: json['copyright'] as String?,
      date: DateTime.parse(json['date'] as String),
      explanation: json['explanation'] as String,
      hdImageUrl: json['hdurl'] as String?,
      imageUrl: json['url'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$PictureResponseToJson(PictureResponse instance) =>
    <String, dynamic>{
      'copyright': instance.copyright,
      'date': instance.date.toIso8601String(),
      'explanation': instance.explanation,
      'hdurl': instance.hdImageUrl,
      'url': instance.imageUrl,
      'title': instance.title,
    };
