import 'dart:async';

import 'package:apod/data/apod_pager.dart';
import 'package:apod/data/model/picture_entity.dart';
import 'package:apod/data/picture_repository.dart';
import 'package:apod/list/bloc/picture_list_event.dart';
import 'package:apod/list/bloc/picture_list_state.dart';
import 'package:apod/list/model/picture_item.dart';
import 'package:bloc/bloc.dart';
import 'package:stream_transform/stream_transform.dart';

const _debounceTime = Duration(milliseconds: 300);

EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) {
    return events.debounce(duration).switchMap(mapper);
  };
}

class PictureListBloc extends Bloc<PictureListEvent, PictureListState> {
  final PictureRepository repository;
  StreamSubscription<List<PictureEntity>>? _entityStream;

  PictureListBloc({required this.repository})
      : super(const PictureListState()) {
    on<InitialisePictureList>(_onInitialise);
    on<FetchPictures>(
      _onFetchPictures,
      transformer: debounce(_debounceTime),
    );
    on<PicturesLoaded>(
      _onPicturesLoaded,
      transformer: debounce(_debounceTime),
    );
  }

  FutureOr<void> _onFetchPictures(
    FetchPictures event,
    Emitter<PictureListState> emit,
  ) async {
    try {
      emit(state.copyWith(status: PictureListStatus.loading));
      await repository.fetchNextPage();
      emit(state.copyWith(status: PictureListStatus.success));
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
    emit(state.copyWith(pictures: items));

    if (!containsFirstApodEntry(event.entities)) {
      add(FetchPictures());
    }
  }

  FutureOr<void> _onInitialise(
    InitialisePictureList event,
    Emitter<PictureListState> emit,
  ) {
    _entityStream?.cancel();
    _entityStream = repository.getEntities().debounce(_debounceTime).listen(
      (entities) {
        if (entities.isEmpty && state.status != PictureListStatus.error) {
          add(FetchPictures());
        } else if (entities.isNotEmpty) {
          add(PicturesLoaded(entities));
        }
      },
    );
  }

  bool containsFirstApodEntry(List<PictureEntity> entities) {
    return entities.first.date == DateTime.now().withoutTime();
  }

  @override
  Future<void> close() {
    _entityStream?.cancel();
    return super.close();
  }
}
