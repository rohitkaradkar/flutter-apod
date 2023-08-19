import 'package:apod/data/picture_repository.dart';
import 'package:apod/details/bloc/picture_details_bloc.dart';
import 'package:apod/details/widget/picture_details_page_view.dart';
import 'package:apod/utils/constants.dart';
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
