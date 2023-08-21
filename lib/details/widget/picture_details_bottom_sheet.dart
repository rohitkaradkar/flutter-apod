import 'package:apod/details/bloc/picture_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        String subtitle = _formattedDate(picture.date);
        if (picture.copyright != null) {
          subtitle += ' ${picture.copyright}';
        }
        return DraggableScrollableSheet(
          expand: false,
          snap: true,
          initialChildSize: 0.25,
          builder: (context, controller) {
            final children = <Widget>[
              Text(
                picture.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
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

  String _formattedDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }
}
