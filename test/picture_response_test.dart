import 'dart:convert';

import 'package:apod/picture_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('json decoding', () {
    const json = """
    {
    "copyright": "\\nAbe Jones\\n",
    "date": "2023-08-07",
    "explanation": "Some explanation",
    "hdurl": "https://apod.nasa.gov/apod/image/2308/LDN935_Jones_1840.jpg",
    "title": "The Pelican Nebula in Gas, Dust, and Stars",
    "url": "https://apod.nasa.gov/apod/image/2308/LDN935_Jones_960.jpg"
    }
    """;
    final response = PictureResponse.fromJson(
      jsonDecode(json.replaceAll("\\n", "")),
    );
    final expected = PictureResponse(
      date: DateTime(2023, 8, 7),
      explanation: "Some explanation",
      hdImageUrl: "https://apod.nasa.gov/apod/image/2308/LDN935_Jones_1840.jpg",
      imageUrl: "https://apod.nasa.gov/apod/image/2308/LDN935_Jones_960.jpg",
      title: "The Pelican Nebula in Gas, Dust, and Stars",
      copyright: "Abe Jones",
    );

    expect(response.date, expected.date);
    expect(response.explanation, expected.explanation);
    expect(response.hdImageUrl, expected.hdImageUrl);
    expect(response.imageUrl, expected.imageUrl);
    expect(response.title, expected.title);
    expect(response.copyright, expected.copyright);
  });

  test('decoding optional parameters', () {
    // missing copyright field
    const json = """
    {
    "date": "2023-08-07",
    "explanation": "Some explanation",
    "hdurl": "https://apod.nasa.gov/apod/image/2308/LDN935_Jones_1840.jpg",
    "title": "The Pelican Nebula in Gas, Dust, and Stars",
    "url": "https://apod.nasa.gov/apod/image/2308/LDN935_Jones_960.jpg"
    }
    """;
    final response = PictureResponse.fromJson(jsonDecode(json));
    expect(response.copyright, isNull);
  });
}
