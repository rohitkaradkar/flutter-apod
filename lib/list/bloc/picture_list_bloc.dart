import 'dart:async';
import 'dart:convert';

import 'package:apod/api_key.dart';
import 'package:apod/data/model/picture_response.dart';
import 'package:apod/list/bloc/picture_list_event.dart';
import 'package:apod/list/bloc/picture_list_state.dart';
import 'package:apod/list/models/picture_item.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

class PictureListBloc extends Bloc<PictureListEvent, PictureListState> {
  final http.Client httpClient;

  PictureListBloc({required this.httpClient})
      : super(const PictureListState()) {
    on<FetchPictures>(_onFetchPictures);
  }

  FutureOr<void> _onFetchPictures(
    FetchPictures event,
    Emitter<PictureListState> emit,
  ) async {
    try {
      final responseList = await _fetchResponse();
      final pictureItems = responseList.map(
        (response) {
          return PictureItem(title: response.title, url: response.imageUrl);
        },
      ).toList();
      return emit(
        state.copyWith(
          status: PictureListStatus.success,
          pictures: pictureItems,
        ),
      );
    } catch (e, stacktrace) {
      return emit(state.copyWith(status: PictureListStatus.error));
    }
  }

  Future<List<PictureResponse>> _fetchResponse() async {
    final response = await httpClient.get(Uri.parse(
      'https://api.nasa.gov/planetary/apod?api_key=$nasaApiKey&end_date=2023-08-08&start_date=2023-08-01',
    ));

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body);
      return (list as List)
          .map((data) => PictureResponse.fromJson(data))
          .toList(growable: false);
    } else {
      throw Exception('Failed to load');
    }
  }
}
