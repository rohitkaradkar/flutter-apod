import 'package:apod/data/model/picture_entity.dart';
import 'package:apod/data/picture_repository.dart';
import 'package:apod/list/bloc/picture_list_bloc.dart';
import 'package:apod/utils/mappers.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'picture_list_bloc_test.mocks.dart';

@GenerateMocks([PictureRepository])
void main() {
  group('PictureListBloc', () {
    final fakeEntities = [
      PictureEntity(
        date: DateTime(2021, 1, 1),
        explanation: 'explanation',
        hdImageUrl: 'hdImageUrl',
        imageUrl: 'imageUrl',
        title: 'title',
        copyright: 'nasa',
      ),
      PictureEntity(
        date: DateTime(2021, 1, 2),
        explanation: 'explanation',
        hdImageUrl: 'hdImageUrl',
        imageUrl: 'imageUrl',
        title: 'title',
        copyright: 'nasa',
      ),
    ];
    final fakeItems = fakeEntities.map(mapPictureEntityToItem).toList();

    late PictureRepository repository;
    late PictureListBloc bloc;

    setUp(() {
      repository = MockPictureRepository();
      bloc = PictureListBloc(
        repository: repository,
        debounceTime: Duration.zero,
      );
    });

    test('initial state', () {
      expect(bloc.state.status, PictureListStatus.loading);
      expect(bloc.state.pictures, isEmpty);
    });

    group('InitialisePictureList event', () {
      blocTest(
        'emits local picture items while fetching new apod entries',
        setUp: () {
          when(repository.getEntities()).thenAnswer(
            (_) => Stream.value(fakeEntities),
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(InitialisePictureList()),
        wait: Duration.zero,
        expect: () {
          final state = PictureListState(
            status: PictureListStatus.success,
            pictures: fakeItems,
          );
          return [
            state,
            state.copyWith(status: PictureListStatus.loading),
            state.copyWith(status: PictureListStatus.success),
          ];
        },
        verify: (_) {
          verify(repository.fetchNextPage()).called(1);
        },
      );
    });

    blocTest(
      'fetches new items when local entities are absent',
      setUp: () {
        when(repository.getEntities()).thenAnswer((_) => Stream.value([]));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(InitialisePictureList()),
      wait: Duration.zero,
      verify: (_) {
        verify(repository.fetchNextPage()).called(1);
      },
    );

    blocTest('', build: () => bloc);
  });
}
