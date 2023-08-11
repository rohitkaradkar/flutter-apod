import 'package:apod/list/model/picture_item.dart';
import 'package:equatable/equatable.dart';

enum PictureListStatus { loading, success, error }

final class PictureListState extends Equatable {
  final PictureListStatus status;
  final List<PictureItem> pictures;
  final int pageIndex;

  const PictureListState({
    this.status = PictureListStatus.loading,
    this.pictures = const <PictureItem>[],
    this.pageIndex = -1,
  });

  PictureListState copyWith({
    PictureListStatus? status,
    List<PictureItem>? pictures,
    int? pageIndex,
  }) {
    return PictureListState(
      status: status ?? this.status,
      pictures: pictures ?? this.pictures,
      pageIndex: pageIndex ?? this.pageIndex,
    );
  }

  @override
  List<Object> get props => [status, pictures, pageIndex];
}
