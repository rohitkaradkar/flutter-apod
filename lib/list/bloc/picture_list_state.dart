import 'package:apod/list/model/picture_item.dart';
import 'package:equatable/equatable.dart';

enum PictureListStatus { loading, success, error, none }

final class PictureListState extends Equatable {
  final PictureListStatus status;
  final List<PictureItem> pictures;

  const PictureListState({
    this.status = PictureListStatus.none,
    this.pictures = const <PictureItem>[],
  });

  PictureListState copyWith({
    PictureListStatus? status,
    List<PictureItem>? pictures,
  }) {
    return PictureListState(
      status: status ?? this.status,
      pictures: pictures ?? this.pictures,
    );
  }

  @override
  List<Object> get props => [status, pictures];
}
