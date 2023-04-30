// To parse this JSON data, do
//
//     final newsArticle = newsArticleFromJson(jsonString);

import 'dart:convert';

NewsArticle newsArticleFromJson(String str) => NewsArticle.fromJson(json.decode(str));

String newsArticleToJson(NewsArticle data) => json.encode(data.toJson());

class NewsArticle {
    NewsArticle({
        required this.type,
        required this.message,
        required this.promoted,
        required this.data,
        required this.rateLimit,
        required this.hasWarning,
    });

    int type;
    String message;
    List<dynamic> promoted;
    List<Datum> data;
    RateLimit rateLimit;
    bool hasWarning;

    factory NewsArticle.fromJson(Map<String, dynamic> json) => NewsArticle(
        type: json["Type"],
        message: json["Message"],
        promoted: List<dynamic>.from(json["Promoted"].map((x) => x)),
        data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
        rateLimit: RateLimit.fromJson(json["RateLimit"]),
        hasWarning: json["HasWarning"],
    );

    Map<String, dynamic> toJson() => {
        "Type": type,
        "Message": message,
        "Promoted": List<dynamic>.from(promoted.map((x) => x)),
        "Data": List<dynamic>.from(data.map((x) => x.toJson())),
        "RateLimit": rateLimit.toJson(),
        "HasWarning": hasWarning,
    };
}

class Datum {
    Datum({
        required this.id,
        required this.guid,
        required this.publishedOn,
        required this.imageurl,
        required this.title,
        required this.url,
        required this.body,
        required this.tags,
        required this.lang,
        required this.upvotes,
        required this.downvotes,
        required this.categories,
        required this.sourceInfo,
        required this.source,
    });

    String id;
    String guid;
    int publishedOn;
    String imageurl;
    String title;
    String url;
    String body;
    String tags;
    Lang lang;
    String upvotes;
    String downvotes;
    String categories;
    SourceInfo sourceInfo;
    String source;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        guid: json["guid"],
        publishedOn: json["published_on"],
        imageurl: json["imageurl"],
        title: json["title"],
        url: json["url"],
        body: json["body"],
        tags: json["tags"],
        lang: langValues.map[json["lang"]]!,
        upvotes: json["upvotes"],
        downvotes: json["downvotes"],
        categories: json["categories"],
        sourceInfo: SourceInfo.fromJson(json["source_info"]),
        source: json["source"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "guid": guid,
        "published_on": publishedOn,
        "imageurl": imageurl,
        "title": title,
        "url": url,
        "body": body,
        "tags": tags,
        "lang": langValues.reverse[lang],
        "upvotes": upvotes,
        "downvotes": downvotes,
        "categories": categories,
        "source_info": sourceInfo.toJson(),
        "source": source,
    };
}

enum Lang { en }

final langValues = EnumValues({
    "EN": Lang.en
});

class SourceInfo {
    SourceInfo({
        required this.name,
        required this.img,
        required this.lang,
    });

    String name;
    String img;
    Lang lang;

    factory SourceInfo.fromJson(Map<String, dynamic> json) => SourceInfo(
        name: json["name"],
        img: json["img"],
        lang: langValues.map[json["lang"]]!,
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "img": img,
        "lang": langValues.reverse[lang],
    };
}

class RateLimit {
    RateLimit();

    factory RateLimit.fromJson(Map<String, dynamic> json) => RateLimit(
    );

    Map<String, dynamic> toJson() => {
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
