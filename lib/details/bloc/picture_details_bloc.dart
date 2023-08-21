import 'dart:async';
import 'dart:developer';

import 'package:apod/data/model/picture_entity.dart';
import 'package:apod/data/picture_repository.dart';
import 'package:apod/details/model/picture_detail_item.dart';
import 'package:apod/utils/mappers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'picture_details_event.dart';
part 'picture_details_state.dart';

class PictureDetailsBloc
    extends Bloc<PictureDetailsEvent, PictureDetailsState> {
  final PictureRepository repository;
  StreamSubscription<List<PictureEntity>>? _entityStream;

  PictureDetailsBloc({
    required this.repository,
  }) : super(const PictureDetailsState()) {
    _entityStream = repository.getEntities().listen((entities) {
      if (entities.isEmpty) return;
      add(PicturesEntitiesLoaded(entities: entities));
    });
    on<InitialisePictureDetails>(_onInitPictureDetails);
    on<PicturesEntitiesLoaded>(_onPicturesEntitiesLoaded);
    on<FetchPictures>(_onFetchPictures);
    on<SelectedPictureChanged>(_onSelectedPictureChanged);
  }

  @override
  Future<void> close() {
    _entityStream?.cancel();
    return super.close();
  }

  Future<FutureOr<void>> _onInitPictureDetails(
    InitialisePictureDetails event,
    Emitter<PictureDetailsState> emit,
  ) async {
    final date = DateTime.tryParse(event.defaultItemDate);
    final entities = await repository.getEntities().first;
    if (entities.isNotEmpty) {
      // get entities from stream
      final index = entities.indexWhere((element) => element.date == date);
      emit(
        state.copyWith(
          selectedPictureIndex: index.clamp(0, entities.length),
          pictures: entities.map(mapToPictureDetailEntity).toList(),
          status: PictureDetailsStatus.success,
        ),
      );
    }
  }

  FutureOr<void> _onPicturesEntitiesLoaded(
    PicturesEntitiesLoaded event,
    Emitter<PictureDetailsState> emit,
  ) {
    final items = event.entities
        .map((e) => mapToPictureDetailEntity(e))
        .toList(growable: false);
    emit(state.copyWith(pictures: items, status: PictureDetailsStatus.success));
  }

  Future<FutureOr<void>> _onFetchPictures(
    FetchPictures event,
    Emitter<PictureDetailsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: PictureDetailsStatus.loading));
      await repository.fetchNextPage();
      emit(state.copyWith(status: PictureDetailsStatus.success));
    } catch (e, stacktrace) {
      log('error fetching next page', error: e, stackTrace: stacktrace);
      emit(state.copyWith(status: PictureDetailsStatus.error));
    }
  }

  FutureOr<void> _onSelectedPictureChanged(
    SelectedPictureChanged event,
    Emitter<PictureDetailsState> emit,
  ) {
    emit(state.copyWith(selectedPictureIndex: event.index));
  }
}
