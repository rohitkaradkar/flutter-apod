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
            return GridView.builder(
              itemCount: state.pictures.length,
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  mainAxisExtent: 240),
              itemBuilder: (BuildContext context, int index) {
                final picture = state.pictures[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          picture.url,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          picture.title,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
        }
      },
    );
  }
}
