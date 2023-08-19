import 'package:equatable/equatable.dart';

class PictureDetailItem extends Equatable {
  final DateTime date;
  final String explanation;
  final String imageUrl;
  final String title;
  final String? copyright;

  const PictureDetailItem({
    required this.date,
    required this.explanation,
    required this.imageUrl,
    required this.title,
    this.copyright,
  });

  @override
  List<Object?> get props => [date, explanation, imageUrl, title, copyright];
}
