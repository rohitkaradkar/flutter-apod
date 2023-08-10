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
    on<FetchPictures>(_onFetchPictures);
  }

  FutureOr<void> _onFetchPictures(
    FetchPictures event,
    Emitter<PictureListState> emit,
  ) async {
    try {
      final responseList = await repository.fetchPictures();
      final pictureItems = responseList.map((response) {
        return PictureItem(title: response.title, url: response.imageUrl);
      }).toList();
      return emit(
        state.copyWith(
          status: PictureListStatus.success,
          pictures: pictureItems,
        ),
      );
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return emit(state.copyWith(status: PictureListStatus.error));
    }
  }
}
