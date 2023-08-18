import 'package:apod/data/picture_repository.dart';
import 'package:apod/details/bloc/picture_details_bloc.dart';
import 'package:apod/details/model/picture_detail_item.dart';
import 'package:apod/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PictureDetailsPage extends StatelessWidget {
  const PictureDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PictureDetailsBloc(
        repository: PictureRepository(pageSize: kApiPageSize),
      )..add(InitialisePictureDetails()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => GoRouter.of(context).pop(),
          ),
        ),
        body: PictureDetails(),
      ),
    );
  }
}

class PictureDetails extends StatelessWidget {
  const PictureDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PictureDetailsBloc, PictureDetailsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state.pictures.isEmpty) {
          if (state.status == PictureDetailsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('No pictures found'));
          }
        }
        return PageView.builder(itemBuilder: (context, index) {
          final picture = state.pictures[index];
          // container with width of screen
          return _imagePage(picture);
        });
      },
    );
  }

  Widget _imagePage(PictureDetailItem picture) {
    return CachedNetworkImage(
      imageUrl: picture.imageUrl,
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return _progressIndicator(downloadProgress);
      },
    );
  }

  Widget _progressIndicator(DownloadProgress downloadProgress) {
    final children = <Widget>[const CircularProgressIndicator()];
    if (downloadProgress.progress != null) {
      children.addAll([
        const SizedBox(height: 4),
        Text('${(downloadProgress.progress! * 100).round()}%')
      ]);
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}
