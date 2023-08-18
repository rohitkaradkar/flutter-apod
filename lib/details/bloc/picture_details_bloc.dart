import 'dart:async';

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
    on<InitialisePictureDetails>(_onInitPictureDetails);
    on<PicturesEntitiesLoaded>(_onPicturesEntitiesLoaded);
  }

  @override
  Future<void> close() {
    _entityStream?.cancel();
    return super.close();
  }

  FutureOr<void> _onInitPictureDetails(
    InitialisePictureDetails event,
    Emitter<PictureDetailsState> emit,
  ) {
    _entityStream = repository.getEntities().listen((entities) {
      if (entities.isEmpty) return;
      add(PicturesEntitiesLoaded(entities: entities));
    });
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
}
