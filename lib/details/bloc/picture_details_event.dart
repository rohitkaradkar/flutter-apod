part of 'picture_details_bloc.dart';

sealed class PictureDetailsEvent {}

class InitialisePictureDetails extends PictureDetailsEvent with EquatableMixin {
  String? selectedItemDate;

  InitialisePictureDetails({this.selectedItemDate});

  @override
  List<Object?> get props => [selectedItemDate];
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
