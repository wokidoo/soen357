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
              child: Html(data: content ?? ''),
            ),
    );
  }
}
