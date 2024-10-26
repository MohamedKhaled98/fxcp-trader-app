import 'dart:convert';

class News {
  String category;
  int datetime;
  String headline;
  int id;
  String image;
  String related;
  String source;
  String summary;
  String url;
  News({
    required this.category,
    required this.datetime,
    required this.headline,
    required this.id,
    required this.image,
    required this.related,
    required this.source,
    required this.summary,
    required this.url,
  });

  News copyWith({
    String? category,
    int? datetime,
    String? headline,
    int? id,
    String? image,
    String? related,
    String? source,
    String? summary,
    String? url,
  }) {
    return News(
      category: category ?? this.category,
      datetime: datetime ?? this.datetime,
      headline: headline ?? this.headline,
      id: id ?? this.id,
      image: image ?? this.image,
      related: related ?? this.related,
      source: source ?? this.source,
      summary: summary ?? this.summary,
      url: url ?? this.url,
    );
  }


  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      category: map['category'] as String,
      datetime: map['datetime'] as int,
      headline: map['headline'] as String,
      id: map['id'] as int,
      image: map['image'] as String,
      related: map['related'] as String,
      source: map['source'] as String,
      summary: map['summary'] as String,
      url: map['url'] as String,
    );
  }

  factory News.fromJson(String source) => News.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MarketNews(category: $category, datetime: $datetime, headline: $headline, id: $id, image: $image, related: $related, source: $source, summary: $summary, url: $url)';
  }

}
