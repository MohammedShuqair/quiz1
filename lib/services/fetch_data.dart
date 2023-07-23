import 'package:quiz1/models/image.dart';
import 'package:quiz1/models/quote.dart';

import 'networking.dart';

class ApiHelper {
  Future<Quote> fetchQuote() async {
    Map<String, dynamic> quoteMap = await NetworkHelper(
      url: 'https://api.quotable.io/random',
    ).getData();
    return Quote.fromJson(quoteMap);
  }

  Future<QImage> fetchImage(String category) async {
    Map<String, dynamic> quoteMap = await NetworkHelper(
      url:
          'https://random.imagecdn.app/v1/image?category=$category&format=json',
    ).getData();
    return QImage.fromJson(quoteMap);
  }
}
