import 'dart:async';

import 'package:apod/data/apod_pager.dart';
import 'package:apod/data/model/picture_entity.dart';
import 'package:apod/data/picture_repository.dart';
import 'package:apod/list/model/picture_item.dart';
import 'package:apod/utils/logger.dart';
import 'package:apod/utils/mappers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

part 'picture_list_event.dart';
part 'picture_list_state.dart';

EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) {
    return events.debounce(duration).switchMap(mapper);
  };
}

class PictureListBloc extends Bloc<PictureListEvent, PictureListState> {
  final PictureRepository repository;
  final Duration _debounceTime;
  StreamSubscription<List<PictureEntity>>? _entityStream;

  PictureListBloc({
    required this.repository,
    Duration? debounceTime,
  })  : _debounceTime = debounceTime ?? const Duration(milliseconds: 300),
        super(const PictureListState()) {
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
      logger.e('error fetching next page', error: e, stackTrace: stacktrace);
      emit(state.copyWith(status: PictureListStatus.error));
    }
  }

  FutureOr<void> _onPicturesLoaded(
      PicturesLoaded event, Emitter<PictureListState> emit) {
    final items = event.entities
        .map((e) => mapPictureEntityToItem(e))
        .toList(growable: false);
    emit(state.copyWith(pictures: items, status: PictureListStatus.success));
  }

  Future<FutureOr<void>> _onInitialise(
    InitialisePictureList event,
    Emitter<PictureListState> emit,
  ) async {
    final stream = repository.getEntities().asBroadcastStream();
    final entities = await stream.first;
    if (entities.isEmpty) {
      add(FetchPictures());
    } else {
      add(PicturesLoaded(entities));
      if (!_containsFirstApodEntry(entities)) {
        add(FetchPictures());
      }
    }
    _entityStream?.cancel();
    _entityStream = stream.listen((entities) {
      if (entities.isNotEmpty) {
        add(PicturesLoaded(entities));
      }
    });
  }

  bool _containsFirstApodEntry(List<PictureEntity> entities) {
    return entities.first.date == DateTime.now().withoutTime();
  }

  @override
  Future<void> close() {
    _entityStream?.cancel();
    return super.close();
  }
}
