import 'package:apod/data/picture_repository.dart';
import 'package:apod/details/bloc/picture_details_bloc.dart';
import 'package:apod/details/model/picture_detail_item.dart';
import 'package:apod/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PictureDetailsPage extends StatelessWidget {
  final String selectedItemDate;

  const PictureDetailsPage({super.key, required this.selectedItemDate});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PictureDetailsBloc(
        repository: PictureRepository(pageSize: kApiPageSize),
      )..add(InitialisePictureDetails(selectedItemDate: selectedItemDate)),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => GoRouter.of(context).pop(),
          ),
        ),
        body: const PictureDetailsPageView(),
      ),
    );
  }
}

class PictureDetailsPageView extends StatefulWidget {
  const PictureDetailsPageView({
    super.key,
  });

  @override
  State<PictureDetailsPageView> createState() => _PictureDetailsPageViewState();
}

class _PictureDetailsPageViewState extends State<PictureDetailsPageView> {
  PageController? _pageController;

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

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
        final initialPageIndex = state.selectedPictureIndex;
        if (initialPageIndex >= 0) {
          _pageController = PageController(initialPage: initialPageIndex);
        }
        return PageView.builder(
          itemCount: state.pictures.length,
          controller: _pageController,
          itemBuilder: (context, index) {
            final picture = state.pictures[index];
            // container with width of screen
            return _imagePage(picture);
          },
        );
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
