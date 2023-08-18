part of 'picture_details_bloc.dart';

enum PictureDetailsStatus { loading, success, error }

class PictureDetailsState extends Equatable {
  final PictureDetailsStatus status;
  final List<PictureDetailItem> pictures;
  final DateTime? selectedPictureDate;

  const PictureDetailsState({
    this.selectedPictureDate,
    this.status = PictureDetailsStatus.loading,
    this.pictures = const <PictureDetailItem>[],
  });

  int get selectedPictureIndex {
    return pictures
        .indexWhere((element) => element.date == selectedPictureDate);
  }

  @override
  List<Object?> get props => [status, pictures, selectedPictureDate];

  PictureDetailsState copyWith({
    PictureDetailsStatus? status,
    List<PictureDetailItem>? pictures,
    DateTime? selectedPictureDate,
  }) {
    return PictureDetailsState(
      status: status ?? this.status,
      pictures: pictures ?? this.pictures,
      selectedPictureDate: selectedPictureDate ?? this.selectedPictureDate,
    );
  }
}
