import 'dart:convert';

import 'package:apod/data/model/picture_response.dart';
import 'package:apod/utils/api_key.dart';
import 'package:apod/utils/constants.dart';
import 'package:http/http.dart' as http;

class PictureRepository {
  final http.Client httpClient;

  PictureRepository({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  Future<List<PictureResponse>> fetchPictures() async {
    final queryParams = {
      'api_key': kNasaApiKey,
      'start_date': '2023-08-01',
      'end_date': '2023-08-10',
    };
    final uri = Uri.http(kNasaBaseURL, '/planetary/apod', queryParams);
    final response = await httpClient.get(uri);

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body);
      return (list as List)
          .map((data) => PictureResponse.fromJson(data))
          .toList(growable: false);
    } else {
      throw Exception(response.body);
    }
  }
}
