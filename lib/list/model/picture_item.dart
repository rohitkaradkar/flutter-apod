import 'package:equatable/equatable.dart';

final class PictureItem extends Equatable {
  final String title;
  final String url;

  const PictureItem({required this.title, required this.url});

  @override
  List<Object> get props => [title, url];
}
