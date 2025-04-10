import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import '../models/article.dart';

class ArticlePreviewLoader {
  static Future<Article> load(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final document = parser.parse(response.body);

      final metaTitle = document
              .querySelector('meta[property="og:title"]')
              ?.attributes['content'] ??
          document.querySelector('title')?.text ??
          'Untitled';

      final metaImage = document
          .querySelector('meta[property="og:image"]')
          ?.attributes['content'];

      return Article(
        url: url,
        title: metaTitle,
        imageUrl: metaImage,
      );
    } catch (e) {
      return Article(
        url: url,
        title: 'Error loading article',
        imageUrl: null,
      );
    }
  }
}
