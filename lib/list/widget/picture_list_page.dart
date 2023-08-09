import 'package:apod/list/bloc/picture_list_bloc.dart';
import 'package:apod/list/bloc/picture_list_event.dart';
import 'package:apod/list/widget/picture_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class PictureListPage extends StatelessWidget {
  const PictureListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Astronomy Picture of the Day'),
      ),
      body: BlocProvider(
        create: (_) {
          return PictureListBloc(httpClient: http.Client())
            ..add(FetchPictures());
        },
        child: const PictureList(),
      ),
    );
  }
}
