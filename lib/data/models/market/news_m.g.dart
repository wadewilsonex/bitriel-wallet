// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_m.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsModel _$NewsModelFromJson(Map<String, dynamic> json) => NewsModel(
      id: json['id'] as String?,
      guid: json['guid'] as String?,
      published_on: json['published_on'] as int?,
      imageurl: json['imageurl'] as String?,
      title: json['title'] as String?,
      url: json['url'] as String?,
      body: json['body'] as String?,
      tags: json['tags'] as String?,
      lang: json['lang'] as String?,
      upvotes: json['upvotes'] as String?,
      downvotes: json['downvotes'] as String?,
      categories: json['categories'] as String?,
      source: json['source'] as String?,
      source_info: json['source_info'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NewsModelToJson(NewsModel instance) => <String, dynamic>{
      'id': instance.id,
      'guid': instance.guid,
      'published_on': instance.published_on,
      'imageurl': instance.imageurl,
      'title': instance.title,
      'url': instance.url,
      'body': instance.body,
      'tags': instance.tags,
      'lang': instance.lang,
      'upvotes': instance.upvotes,
      'downvotes': instance.downvotes,
      'categories': instance.categories,
      'source': instance.source,
      'source_info': instance.source_info,
    };
