// models/story_model.dart
class Story {
  final String id;
  final String userName;
  final String userAvatarUrl;
  final DateTime publishedAt;
  final List<StoryItem> items;
  
  Story({
    required this.id,
    required this.userName,
    required this.userAvatarUrl,
    required this.publishedAt,
    required this.items,
  });
}

class StoryItem {
  final String id;
  final String type; // 'image', 'video', 'text'
  final String contentUrl;
  final String? text;
  final Duration duration;
  final bool hasSeen;
  final DateTime timestamp;
  
  StoryItem({
    required this.id,
    required this.type,
    required this.contentUrl,
    this.text,
    required this.duration,
    this.hasSeen = false,
    required this.timestamp,
  });
}