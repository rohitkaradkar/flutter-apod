part of 'picture_details_bloc.dart';

enum PictureDetailsStatus { loading, success, error }

class PictureDetailsState extends Equatable {
  final PictureDetailsStatus status;
  final List<PictureDetailItem> pictures;
  final int? selectedPictureIndex;

  const PictureDetailsState({
    this.status = PictureDetailsStatus.loading,
    this.pictures = const <PictureDetailItem>[],
    this.selectedPictureIndex,
  });

  @override
  List<Object> get props => [status, pictures];

  PictureDetailsState copyWith({
    PictureDetailsStatus? status,
    List<PictureDetailItem>? pictures,
  }) {
    return PictureDetailsState(
      status: status ?? this.status,
      pictures: pictures ?? this.pictures,
    );
  }
}
