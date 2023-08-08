import 'dart:convert';

import 'package:apod/api_key.dart';
import 'package:apod/picture_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //TODO: move it to repository
  Future<List<PictureResponse>> fetchResponse() async {
    final response = await http.get(Uri.parse(
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

  late Future<List<PictureResponse>> futurePictures;

  @override
  void initState() {
    super.initState();
    futurePictures = fetchResponse();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('APOD'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: FutureBuilder<List<PictureResponse>>(
          future: futurePictures,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Widget> children = [];
              for (final picture in snapshot.data!) {
                children.add(Text(
                    '${picture.title.trim()}\nby ${picture.copyright?.trim()}\non ${picture.date}'));
                children.add(const SizedBox(height: 16.0));
              }
              return Column(children: children);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
