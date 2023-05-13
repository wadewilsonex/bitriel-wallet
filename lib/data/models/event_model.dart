import 'package:wallet_apps/index.dart';

class Event {

  String name;
  String description;
  DateTime eventDate;
  String eventTime;
  String image;
  String location;
  String organizer;
  num price;
  num priceToken;

  Event({
    required this.eventDate,
    required this.eventTime,
    required this.image,
    required this.location,
    required this.name,
    required this.organizer,
    required this.price,
    required this.priceToken,
    required this.description,
  });
}
