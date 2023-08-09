import 'package:equatable/equatable.dart';

import '../models/picture_item.dart';

enum PictureListStatus { loading, success, error }

final class PictureListState extends Equatable {
  final PictureListStatus status;
  final List<PictureItem> pictures;

  const PictureListState({
    this.status = PictureListStatus.loading,
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
