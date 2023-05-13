import 'package:json_annotation/json_annotation.dart';

part 'news_m.g.dart';

@JsonSerializable()
class NewsModel {
  String? id;
  String? guid;
  int? published_on;
  String? imageurl;
  String? title;
  String? url;
  String? body;
  String? tags;
  String? lang;
  String? upvotes;
  String? downvotes;
  String? categories;
  String? source;
  Map<String, dynamic>? source_info;

  NewsModel({
    this.id,
    this.guid,
    this.published_on,
    this.imageurl,
    this.title,
    this.url,
    this.body,
    this.tags,
    this.lang,
    this.upvotes,
    this.downvotes,
    this.categories,
    this.source,
    this.source_info,
  });

  factory NewsModel.fromJson(Map<String, dynamic> jsn) => _$NewsModelFromJson(jsn);
  Map<String, dynamic> toJson() => _$NewsModelToJson(this);
}