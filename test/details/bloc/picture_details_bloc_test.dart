import 'package:apod/data/model/picture_entity.dart';
import 'package:apod/data/picture_repository.dart';
import 'package:apod/details/bloc/picture_details_bloc.dart';
import 'package:apod/details/model/picture_detail_item.dart';
import 'package:apod/utils/mappers.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'picture_details_bloc_test.mocks.dart';

@GenerateMocks([PictureRepository])
void main() {
  group('PictureDetailsBloc', () {
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
    final List<PictureDetailItem> fakePictureDetailItems =
        fakeEntities.map(mapPictureEntityToDetailItem).toList();

    late PictureDetailsBloc bloc;
    late PictureRepository repository;

    setUp(() {
      repository = MockPictureRepository();
      when(repository.getEntities()).thenAnswer(
        (_) => Stream.value([]),
      );
      bloc = PictureDetailsBloc(repository: repository);
    });

    test('initial state', () {
      expect(bloc.state.status, PictureDetailsStatus.loading);
      expect(bloc.state.pictures, isEmpty);
      expect(bloc.state.selectedPictureIndex, 0);
    });

    group('InitialisePictureDetails event', () {
      blocTest<PictureDetailsBloc, PictureDetailsState>(
        'should load entities when not empty',
        setUp: () {
          when(repository.getEntities()).thenAnswer(
            (_) => Stream.value(fakeEntities),
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(InitialisePictureDetails(defaultItemDate: '')),
        expect: () => <PictureDetailsState>[
          PictureDetailsState(
            status: PictureDetailsStatus.success,
            pictures: fakePictureDetailItems,
          ),
        ],
      );

      blocTest<PictureDetailsBloc, PictureDetailsState>(
        'should not load entities when empty',
        setUp: () {
          when(repository.getEntities()).thenAnswer(
            (_) => Stream.value([]),
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(InitialisePictureDetails(defaultItemDate: '')),
        expect: () => <PictureDetailsState>[],
      );

      blocTest<PictureDetailsBloc, PictureDetailsState>(
        'when valid defaultItemDate is provided selectedPictureIndex is set',
        setUp: () {
          when(repository.getEntities()).thenAnswer(
            (_) => Stream.value(fakeEntities),
          );
        },
        build: () => bloc,
        act: (bloc) =>
            bloc.add(InitialisePictureDetails(defaultItemDate: '2021-01-02')),
        expect: () => <PictureDetailsState>[
          PictureDetailsState(
            status: PictureDetailsStatus.success,
            pictures: fakePictureDetailItems,
            selectedPictureIndex: 1,
          ),
        ],
      );
    });

    blocTest<PictureDetailsBloc, PictureDetailsState>(
      'FetchPictures starts with loading then success',
      build: () => bloc,
      act: (bloc) => bloc.add(FetchPictures()),
      expect: () => <PictureDetailsState>[
        const PictureDetailsState(status: PictureDetailsStatus.loading),
        const PictureDetailsState(status: PictureDetailsStatus.success),
      ],
    );

    blocTest<PictureDetailsBloc, PictureDetailsState>(
      'FetchPictures starts with loading then error',
      setUp: () {
        when(repository.fetchNextPage()).thenThrow(Exception());
      },
      build: () => bloc,
      act: (bloc) => bloc.add(FetchPictures()),
      expect: () => <PictureDetailsState>[
        const PictureDetailsState(status: PictureDetailsStatus.loading),
        const PictureDetailsState(status: PictureDetailsStatus.error),
      ],
    );
  });
}
