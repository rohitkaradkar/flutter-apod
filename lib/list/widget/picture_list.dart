import 'package:apod/list/bloc/picture_list_bloc.dart';
import 'package:apod/list/model/picture_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PictureList extends StatefulWidget {
  const PictureList({super.key});

  @override
  State<PictureList> createState() => _PictureListState();
}

class _PictureListState extends State<PictureList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PictureListBloc, PictureListState>(
      listener: (context, state) {
        if (state.status == PictureListStatus.error) {
          _showErrorSnackBar(context);
        }
      },
      builder: (context, state) {
        if (state.pictures.isEmpty) {
          if (state.status == PictureListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('No pictures found'));
          }
        } else {
          final itemCount = (state.status == PictureListStatus.loading
              ? state.pictures.length + 1
              : state.pictures.length);
          return GridView.builder(
            itemCount: itemCount,
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              mainAxisExtent: 240,
            ),
            itemBuilder: (BuildContext context, int index) {
              if (index >= state.pictures.length) {
                return const _GridProgressItem();
              } else {
                final picture = state.pictures[index];
                return _GridImageItem(
                  picture: picture,
                  onTap: () {
                    final path = Uri(
                      path: '/details',
                      queryParameters: {'date': picture.date.toString()},
                    ).toString();
                    GoRouter.of(context).go(path);
                  },
                );
              }
            },
            controller: _scrollController,
          );
        }
      },
    );
  }

  void _showErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(days: 99),
        content: const Text('Error fetching pictures'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            context.read<PictureListBloc>().add(FetchPictures());
          },
        ),
      ),
    );
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PictureListBloc>().add(FetchPictures());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.8);
  }
}

class _GridImageItem extends StatelessWidget {
  const _GridImageItem({
    super.key,
    required this.picture,
    this.onTap,
  });

  final PictureItem picture;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: picture.url,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Icon(Icons.image_outlined),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image_outlined),
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
      ),
    );
  }
}

class _GridProgressItem extends StatelessWidget {
  const _GridProgressItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 32,
        width: 32,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
