import 'package:apod/list/bloc/picture_list_bloc.dart';
import 'package:apod/list/bloc/picture_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PictureList extends StatefulWidget {
  const PictureList({super.key});

  @override
  State<PictureList> createState() => _PictureListState();
}

class _PictureListState extends State<PictureList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PictureListBloc, PictureListState>(
      builder: (context, state) {
        switch (state.status) {
          case PictureListStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case PictureListStatus.error:
            return const Center(child: Text('Something went wrong'));
          case PictureListStatus.success:
            return Center(
              child: Text('Success - received ${state.pictures.length} items'),
            );
        }
      },
    );
  }
}
