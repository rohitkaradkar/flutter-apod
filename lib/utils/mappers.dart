import 'package:apod/data/model/picture_entity.dart';
import 'package:apod/details/model/picture_detail_item.dart';

PictureDetailItem mapToPictureDetailEntity(PictureEntity entity) {
  return PictureDetailItem(
      date: entity.date,
      explanation: entity.explanation,
      imageUrl: entity.hdImageUrl ?? entity.imageUrl,
      title: entity.title,
      copyright: entity.copyright);
}
