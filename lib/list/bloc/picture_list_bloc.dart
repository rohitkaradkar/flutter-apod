import 'dart:async';

import 'package:apod/data/picture_repository.dart';
import 'package:apod/list/bloc/picture_list_event.dart';
import 'package:apod/list/bloc/picture_list_state.dart';
import 'package:apod/list/model/picture_item.dart';
import 'package:bloc/bloc.dart';

class PictureListBloc extends Bloc<PictureListEvent, PictureListState> {
  final PictureRepository repository;

  PictureListBloc({required this.repository})
      : super(const PictureListState()) {
    repository.setListener(
      (newEntities) {
        super.add(PicturesLoaded(newEntities));
      },
    );
    on<FetchPictures>(_onFetchPictures);
    on<PicturesLoaded>(_onPicturesLoaded);
  }

  FutureOr<void> _onFetchPictures(
    FetchPictures event,
    Emitter<PictureListState> emit,
  ) async {
    try {
      await repository.fetchPictures();
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      emit(state.copyWith(status: PictureListStatus.error));
    }
  }

  FutureOr<void> _onPicturesLoaded(
      PicturesLoaded event, Emitter<PictureListState> emit) {
    final items = event.entities
        .map((e) => PictureItem(title: e.title, url: e.imageUrl))
        .toList(growable: false);
    emit(state.copyWith(status: PictureListStatus.success, pictures: items));
  }
}
