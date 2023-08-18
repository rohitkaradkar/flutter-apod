part of 'picture_details_bloc.dart';

sealed class PictureDetailsEvent {}

class InitialisePictureDetails extends PictureDetailsEvent {}

class PicturesEntitiesLoaded extends PictureDetailsEvent with EquatableMixin {
  final List<PictureEntity> entities;

  PicturesEntitiesLoaded({
    required this.entities,
  });

  @override
  List<Object?> get props => [entities];
}

class FetchPictures extends PictureDetailsEvent {}
