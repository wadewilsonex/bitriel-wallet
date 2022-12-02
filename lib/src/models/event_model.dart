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

final List<Event> upcomingEvents = [
  Event(
    name: "MetaDoersWorld",
    eventDate: DateTime.now().add(const Duration(days: 7)),
    eventTime: "10AM - 10PM",
    image: 'assets/Singapore_Ticket.png',
    description: "With its roots in Traditional Chinese Medicine, Qigong shares many of the health benefits attributed to Tai Chi. Qigong aims at cultivating and balancing the flow of energy in the body using movement, breathwork, and mental focus. Qigong is valued by many as a body-mind practice used to quiet the mind and promote physical wellness.",
    location: "Online Event",
    organizer: "Meta doers world",
    price: 10,
    priceToken: 1000
  ),
  Event(
    name: "Live Orchestra",
    eventTime: "10AM - 10PM",
    eventDate: DateTime.now().add(const Duration(days: 33)),
    image: 'https://source.unsplash.com/800x600/?band',
    description: "The pretty reckless is an American rock band from New york city, Formed in 2009. The",
    location: "David Geffen Hall",
    organizer: "Westfield Centre",
    price: 30,
    priceToken: 1000
  ),
  Event(
    name: "Local Concert",
    eventTime: "10AM - 10PM",
    eventDate: DateTime.now().add(const Duration(days: 12)),
    image: 'https://source.unsplash.com/800x600/?music',
    description: "The pretty reckless is an American rock band from New york city, Formed in 2009. The",
    location: "The Cutting room",
    organizer: "Westfield Centre",
    price: 30,
    priceToken: 1000
  ),
];
