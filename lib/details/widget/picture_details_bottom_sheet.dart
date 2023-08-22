import 'package:apod/details/bloc/picture_details_bloc.dart';
import 'package:apod/details/model/picture_detail_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PictureDetailsBottomSheet extends StatefulWidget {
  const PictureDetailsBottomSheet({super.key});

  @override
  State<PictureDetailsBottomSheet> createState() =>
      _PictureDetailsBottomSheetState();
}

class _PictureDetailsBottomSheetState extends State<PictureDetailsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PictureDetailsBloc, PictureDetailsState>(
      builder: (context, state) {
        final picture = state.selectedPicture;
        if (picture == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return DraggableScrollableSheet(
          expand: false,
          snap: true,
          initialChildSize: 0.15,
          minChildSize: 0.15,
          builder: (context, controller) {
            final children = <Widget>[
              Text(
                picture.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              _getSubtitleWidget(context, picture),
              const SizedBox(height: 8),
              Text(
                picture.explanation,
                style: Theme.of(context).textTheme.bodyLarge,
              )
            ];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                controller: controller,
                children: children,
              ),
            );
          },
        );
      },
    );
  }

  String _getFormattedDate(PictureDetailItem picture) {
    return DateFormat('dd MMMM yyyy').format(picture.date);
  }

  String? _getCopyright(PictureDetailItem picture) {
    return picture.copyright?.trim().replaceAll(RegExp(r'\n'), ' ');
  }

  _getSubtitleWidget(BuildContext context, PictureDetailItem picture) {
    final children = <Widget>[];
    final copyRight = _getCopyright(picture);
    if (copyRight != null) {
      children.add(
        Text(copyRight, style: Theme.of(context).textTheme.titleMedium),
      );
    }
    children.add(
      Text(
        _getFormattedDate(picture),
        style: Theme.of(context).textTheme.bodyMedium,
        softWrap: false,
        overflow: TextOverflow.fade,
      ),
    );
    return Wrap(spacing: 6, runSpacing: 6, children: children);
  }
}
