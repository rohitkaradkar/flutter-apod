import 'dart:convert';

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
  Future<PictureResponse> fetchResponse() async {
    final response = await http
        .get(Uri.parse('https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY'));

    if (response.statusCode == 200) {
      return PictureResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load');
    }
  }

  late Future<PictureResponse> futurePicture;

  @override
  void initState() {
    super.initState();
    futurePicture = fetchResponse();
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
        body: Center(
          child: FutureBuilder<PictureResponse>(
            future: futurePicture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final picture = snapshot.data!;
                return Text('${picture.title} on ${picture.date}');
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
