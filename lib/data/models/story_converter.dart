import 'package:newsily/data/models/news_data_model.dart';

class StoryItem {
  final String id;
  final String type; // 'image', 'text', 'content'
  final String? imageUrl;
  final String? title;
  final String? description;
  final String? content;
  final String? author;
  final String? sourceName;
  final DateTime? publishedAt;
  final Duration duration;
  
  StoryItem({
    required this.id,
    required this.type,
    this.imageUrl,
    this.title,
    this.description,
    this.content,
    this.author,
    this.sourceName,
    this.publishedAt,
    required this.duration,
  });
}

class ArticleStory {
  final Articles article;
  final List<StoryItem> items;
  
  ArticleStory({
    required this.article,
    required this.items,
  });
}

List<ArticleStory> convertArticlesToStories(List<Articles> articles) {
  return articles.map((article) {
    final items = <StoryItem>[];
    
    // Item 1: Image/Top section
    if (article.urlToImage != null && article.urlToImage!.isNotEmpty) {
      items.add(StoryItem(
        id: '${article.url}_image',
        type: 'image',
        imageUrl: article.urlToImage,
        title: article.title,
        author: article.author,
        sourceName: article.source?.name,
        publishedAt: _parseDateTime(article.publishedAt),
        duration: const Duration(seconds: 5),
      ));
    }
    
    // Item 2: Title & Description
    items.add(StoryItem(
      id: '${article.url}_title',
      type: 'text',
      title: article.title,
      description: article.description,
      author: article.author,
      sourceName: article.source?.name,
      publishedAt: _parseDateTime(article.publishedAt),
      duration: const Duration(seconds: 7),
    ));
    
    // Item 3: Full Content
    if (article.content != null && article.content!.isNotEmpty) {
      items.add(StoryItem(
        id: '${article.url}_content',
        type: 'content',
        content: article.content,
        title: article.title,
        author: article.author,
        sourceName: article.source?.name,
        publishedAt: _parseDateTime(article.publishedAt),
        duration: const Duration(seconds: 10),
      ));
    }
    
    return ArticleStory(article: article, items: items);
  }).toList();
}

DateTime? _parseDateTime(String? dateString) {
  if (dateString == null) return null;
  try {
    return DateTime.parse(dateString);
  } catch (e) {
    return null;
  }
}