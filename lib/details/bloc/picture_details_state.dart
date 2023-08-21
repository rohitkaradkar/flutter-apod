part of 'picture_details_bloc.dart';

enum PictureDetailsStatus { loading, success, error }

class PictureDetailsState extends Equatable {
  final PictureDetailsStatus status;
  final List<PictureDetailItem> pictures;
  final int selectedPictureIndex;

  const PictureDetailsState({
    this.status = PictureDetailsStatus.loading,
    this.pictures = const <PictureDetailItem>[],
    this.selectedPictureIndex = 0,
  });

  PictureDetailItem? get selectedPicture {
    if (pictures.isEmpty ||
        selectedPictureIndex < 0 ||
        selectedPictureIndex >= pictures.length) {
      return null;
    }
    return pictures[selectedPictureIndex];
  }

  @override
  List<Object?> get props => [status, pictures, selectedPictureIndex];

  copyWith({
    PictureDetailsStatus? status,
    List<PictureDetailItem>? pictures,
    int? selectedPictureIndex,
  }) {
    return PictureDetailsState(
      status: status ?? this.status,
      pictures: pictures ?? this.pictures,
      selectedPictureIndex: selectedPictureIndex ?? this.selectedPictureIndex,
    );
  }
}
