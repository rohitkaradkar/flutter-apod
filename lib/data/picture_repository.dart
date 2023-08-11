import 'dart:convert';

import 'package:apod/data/apod_pager.dart';
import 'package:apod/data/model/picture_entity.dart';
import 'package:apod/data/model/picture_response.dart';
import 'package:apod/data/picture_dao.dart';
import 'package:apod/utils/api_key.dart';
import 'package:apod/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PictureRepository {
  final http.Client httpClient;
  final PictureDao pictureDao;
  final ApodPager pager;
  VoidCallback? _dbListener;

  PictureRepository({
    http.Client? httpClient,
    PictureDao? pictureDao,
    int pageSize = 16,
  })  : httpClient = httpClient ?? http.Client(),
        pictureDao = pictureDao ?? PictureDao(),
        pager = ApodPager(pageSize: pageSize);

  Future<void> setListener(Function(List<PictureEntity>) listener) async {
    _dbListener = () async {
      final newEntities =
          await pictureDao.getEntities().then((values) => values.toList());
      if (newEntities.isNotEmpty) {
        final sortedEntities = newEntities
          ..sort((a, b) => b.date.compareTo(a.date));
        listener(sortedEntities);
      }
    };
    await pictureDao.addListener(_dbListener!);
    _dbListener!(); // trigger listener on first set to populate data
  }

  Future<void> clearListener() async {
    await pictureDao.removeListener(_dbListener!);
  }

  Future<void> fetchPictures(int pageIndex) async {
    final pageData = pager.getPageData(pageIndex);
    final queryParams = {
      'api_key': kNasaApiKey,
      'start_date': pageData.startDate,
      'end_date': pageData.endDate,
    };
    final uri = Uri.http(kNasaBaseURL, '/planetary/apod', queryParams);
    final response = await httpClient.get(uri);

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body);
      final responses = (list as List)
          .map((data) => PictureResponse.fromJson(data))
          .toList(growable: false);
      final entities = responses.map(_mapResponseToEntity).toList();
      await pictureDao.save(entities);
    } else {
      throw Exception(response.body);
    }
  }

  // map response to entity
  PictureEntity _mapResponseToEntity(PictureResponse response) {
    return PictureEntity(
      date: response.date,
      copyright: response.copyright,
      explanation: response.explanation,
      hdImageUrl: response.hdImageUrl,
      imageUrl: response.imageUrl,
      title: response.title,
    );
  }
}
