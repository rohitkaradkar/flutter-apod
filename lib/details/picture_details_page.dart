import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PictureDetailsPage extends StatelessWidget {
  const PictureDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: const Text('Picture Details'),
      ),
      body: const Center(
        child: Text('Picture Details'),
      ),
    );
  }
}
