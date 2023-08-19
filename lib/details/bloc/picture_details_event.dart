part of 'picture_details_bloc.dart';

sealed class PictureDetailsEvent {}

class InitialisePictureDetails extends PictureDetailsEvent with EquatableMixin {
  String defaultItemDate;

  InitialisePictureDetails({required this.defaultItemDate});

  @override
  List<Object?> get props => [defaultItemDate];
}

class PicturesEntitiesLoaded extends PictureDetailsEvent with EquatableMixin {
  final List<PictureEntity> entities;

  PicturesEntitiesLoaded({
    required this.entities,
  });

  @override
  List<Object?> get props => [entities];
}

class FetchPictures extends PictureDetailsEvent {}

class SelectedPictureChanged extends PictureDetailsEvent with EquatableMixin {
  final int index;

  SelectedPictureChanged(this.index);

  @override
  List<Object?> get props => [index];
}
