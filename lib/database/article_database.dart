import "../models/article.dart";

class ArticleDatabase {
  List<Article> getRecommendedArticles() {
    return [
      Article(
        id: 'a1',
        title: 'How to Keep Your Plants Healthy',
        imageUrl: 'https://source.unsplash.com/600x400/?plant,green',
        contentUrl: 'https://example.com/article1',
      ),
      Article(
        id: 'a2',
        title: 'Top 5 Indoor Plants for Your Home',
        imageUrl: 'https://source.unsplash.com/600x400/?indoor,plant',
        contentUrl: 'https://example.com/article2',
      ),
    ];
  }
}
