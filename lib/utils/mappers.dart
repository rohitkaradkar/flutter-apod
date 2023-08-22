import 'package:apod/data/model/picture_entity.dart';
import 'package:apod/details/model/picture_detail_item.dart';

import '../list/model/picture_item.dart';

PictureDetailItem mapPictureEntityToDetailItem(PictureEntity entity) {
  return PictureDetailItem(
      date: entity.date,
      explanation: entity.explanation,
      imageUrl: entity.hdImageUrl ?? entity.imageUrl,
      title: entity.title,
      copyright: entity.copyright);
}

PictureItem mapPictureEntityToItem(PictureEntity entity) {
  return PictureItem(
    date: entity.date,
    title: entity.title,
    url: entity.imageUrl,
  );
}
