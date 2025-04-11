// lib/services/article_preview_loader.dart
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import '../models/article.dart';

class ArticlePreviewLoader {
  /// Fetches [url], extracts a clean title & hero image,
  /// and strips boiler‑plate so only the main story is left.
  static Future<Article> load(String url) async {
    try {
      /* ───────────── fetch ───────────── */
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
      final doc = parser.parse(res.body);

      /* ───────────── 1. remove obvious clutter ───────────── */
      const junkSelectors = [
        'script',
        'style',
        'header',
        'footer',
        'nav',
        'aside',
        '[class*="share"]',
        '[class*="social"]',
        '[class*="breadcrumb"]',
        '[class*="author"]',
        '[class*="comment"]',
        '[class*="related"]',
        'button',
        'svg',
        'iframe',
      ];
      doc.querySelectorAll(junkSelectors.join(',')).forEach((e) => e.remove());

      /* ───────────── 4. fix <img src="…"> ───────────── */
      _fixImageUrls(doc.body!, baseUrl: url);

      /* ───────────── 2. choose the biggest text block ───────────── */
      Element? articleNode = doc.querySelector('article');

      // fallback: the <div>/<section> with the most plain‑text characters
      if (articleNode == null) {
        int bestLen = 0;
        for (final e in doc.body!.querySelectorAll('div, section')) {
          final len = _textLen(e.text);
          if (len > bestLen) {
            bestLen = len;
            articleNode = e;
          }
        }
      }

      articleNode ??= doc.body; // absolute fallback

      _removeBlogAndShare(articleNode!);

      /* ───────────── 3. unwrap <a> tags so no blue underlines ───────────── */
      articleNode.querySelectorAll('a').forEach((a) {
        final span = Element.tag('span')..innerHtml = a.innerHtml;
        a.replaceWith(span);
      });

      /* ───────────── 5. meta title / hero image ───────────── */
      final meta = doc;
      final title = meta
              .querySelector('meta[property="og:title"]')
              ?.attributes['content'] ??
          meta.querySelector('title')?.text ??
          'Untitled';

      String? heroImage;
      final ogImg = meta
          .querySelector('meta[property="og:image"]')
          ?.attributes['content'];
      if (ogImg != null && ogImg.trim().isNotEmpty) {
        heroImage = _absoluteUrl(ogImg.trim(), baseUrl: url);
      }

      final cleanedHtml = articleNode.outerHtml;

      /* ───────────── 6. return your model ───────────── */
      return Article(
        url: url,
        title: title.trim(),
        imageUrl: heroImage,
        html: cleanedHtml,
      );
    } catch (_) {
      return Article(
        url: url,
        title: 'Error loading article',
        imageUrl: null,
        html: '<p>Could not load article.</p>',
      );
    }
  }

  /* ───────────── helpers ───────────── */

  // --- 1. delete “Back to Blog” / “Share this Article” blocks ---
  static void _removeBlogAndShare(Element node) {
    final lower = node.text.trim().toLowerCase();
    if (lower.startsWith('back to blog') ||
        lower.startsWith('share this article')) {
      node.remove();
    } else {
      node.children.toList().forEach(_removeBlogAndShare); // recurse
    }
  }

  static int _textLen(String s) =>
      s.replaceAll(RegExp(r'\s+'), ' ').trim().length;

  static void _fixImageUrls(Element root, {required String baseUrl}) {
    root.querySelectorAll('img').forEach((img) {
      final raw = img.attributes['src']?.trim();
      if (raw == null || raw.isEmpty) {
        img.remove(); // nothing to fix → drop
        return;
      }

      final fixed = _absoluteUrl(raw, baseUrl: baseUrl);

      // keep only http/https/data images; anything else is removed
      final scheme = Uri.parse(fixed).scheme;
      if (scheme == 'http' || scheme == 'https' || scheme == 'data') {
        img.attributes['src'] = fixed;
      } else {
        img.remove(); // unsupported → ignore
      }
    });
  }

  static String _absoluteUrl(String raw, {required String baseUrl}) {
    final base = Uri.parse(baseUrl);

    // 1️⃣  normalise the prefix FIRST ---------------------------------
    if (raw.startsWith('file://')) {
      raw = 'https://${raw.substring(7)}'; // file://foo → https://foo
    } else if (raw.startsWith('//')) {
      raw = 'https:$raw'; // //foo → https://foo
    }

    // 2️⃣  now resolve everything else as before ----------------------
    String fixed;
    if (Uri.tryParse(raw)?.hasScheme ?? false) {
      fixed = raw; // already http/https/data…
    } else if (raw.startsWith('/')) {
      fixed = base.replace(path: raw).toString(); // site‑relative
    } else if (RegExp(r'^[\w-]+\.[\w.-]+/').hasMatch(raw)) {
      fixed = 'https://$raw'; // domain w/out scheme
    } else {
      fixed = base.resolve(raw).toString(); // plain relative path
    }
    return Uri.encodeFull(fixed);
  }
}
