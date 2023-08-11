import 'package:apod/data/model/picture_entity.dart';

sealed class PictureListEvent {}

final class FetchPictures extends PictureListEvent {}

final class PicturesLoaded extends PictureListEvent {
  final Iterable<PictureEntity> entities;

  PicturesLoaded(this.entities);
}
