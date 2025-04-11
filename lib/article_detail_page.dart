import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:flutter_html/flutter_html.dart';
import '../models/article.dart';

class ArticleDetailPage extends StatefulWidget {
  final Article article;
  const ArticleDetailPage({super.key, required this.article});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  String? content;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadArticle();
  }

  Future<void> loadArticle() async {
    try {
      final res = await http.get(Uri.parse(widget.article.url));
      final document = parser.parse(res.body);

      final extractedContent = document.querySelector('article')?.innerHtml ??
          document.querySelector('body')?.innerHtml ??
          'Could not extract content.';

      setState(() {
        content = extractedContent;
        loading = false;
      });
    } catch (e) {
      setState(() {
        content = 'Failed to load content.';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.article.title ?? 'Article')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Html(
                data: content ?? '',
                style: {
                  "a": Style(
                    textDecoration: TextDecoration.none,
                    color: Colors
                        .black, // or Theme.of(context).textTheme.bodyMedium?.color
                  ),
                  "body": Style(
                      fontSize: FontSize(16.0),
                      lineHeight: LineHeight.number(1.0)),
                  "h1": Style(
                      fontSize: FontSize(28), fontWeight: FontWeight.bold),
                  "h2": Style(
                      fontSize: FontSize(26), fontWeight: FontWeight.bold),
                  "h3": Style(
                      fontSize: FontSize(24), fontWeight: FontWeight.bold),
                  "h4": Style(
                      fontSize: FontSize(22), fontWeight: FontWeight.bold),
                  "h5": Style(
                      fontSize: FontSize(20), fontWeight: FontWeight.bold),
                  "p": Style(
                      margin: Margins.only(bottom: 14),
                      textAlign: TextAlign.justify),
                  "span": Style(
                      fontSize: FontSize(16),
                      lineHeight: LineHeight.number(1.5),
                      margin: Margins.only(bottom: 14),
                      textAlign: TextAlign.justify),
                },
                extensions: [
                  TagExtension(
                    tagsToExtend: {"img"},
                    builder: (context) {
                      final attrs = context.attributes;
                      final src = attrs["src"];
                      if (src == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            src,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
