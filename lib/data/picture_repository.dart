import 'dart:convert';

import 'package:apod/data/apod_pager.dart';
import 'package:apod/data/model/picture_entity.dart';
import 'package:apod/data/model/picture_response.dart';
import 'package:apod/data/picture_dao.dart';
import 'package:apod/utils/api_key.dart';
import 'package:apod/utils/constants.dart';
import 'package:apod/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

class PictureRepository {
  final http.Client httpClient;
  final PictureDao pictureDao;
  final ApodPager pager;

  PictureRepository({
    http.Client? httpClient,
    PictureDao? pictureDao,
    int pageSize = 10,
  })  : httpClient = httpClient ?? http.Client(),
        pictureDao = pictureDao ?? PictureDao(),
        pager = ApodPager(pageSize: pageSize);

  Stream<List<PictureEntity>> getEntities() {
    return pictureDao
        .getEntitiesSteam()
        .startWith(pictureDao.getEntities())
        .map((iterable) {
      return _sortEntitiesByLatestDate(iterable);
    });
  }

  List<PictureEntity> _sortEntitiesByLatestDate(
    Iterable<PictureEntity> entities,
  ) {
    return entities.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> fetchNextPage() async {
    final localDateRange = pictureDao.getEntityDateRange();
    final pageData = pager.getNextPage(
      latestEntityDate: localDateRange?.latest,
      oldestEntityDate: localDateRange?.oldest,
    );

    final queryParams = {
      'api_key': kNasaApiKey,
      'start_date': pageData.startDate,
      'end_date': pageData.endDate,
    };
    final uri = Uri.https(kNasaBaseURL, '/planetary/apod', queryParams);
    logger.i('fetching $uri');
    final response = await httpClient.get(uri);

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body);
      final responses = (list as List)
          .map((data) => PictureResponse.fromJson(data))
          .toList(growable: false);
      final entities = responses.map(_mapResponseToEntity).toList();
      await pictureDao.save(entities);
    } else {
      logger.e('error in api $uri', error: response.body);
      throw Exception(response.body);
    }
  }

  // map response to entity
  PictureEntity _mapResponseToEntity(PictureResponse response) {
    return PictureEntity(
      date: response.date,
      copyright: response.copyright?.trim(),
      explanation: response.explanation.trim(),
      hdImageUrl: response.hdImageUrl,
      imageUrl: response.imageUrl,
      title: response.title,
    );
  }
}
