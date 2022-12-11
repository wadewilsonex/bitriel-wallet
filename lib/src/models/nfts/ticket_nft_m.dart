import 'package:wallet_apps/src/models/mdw_ticketing/ticket_m.dart';

class TicketNFTModel{

  bool? redeemed;
  int? __v;
  String? ticketTypeId;
  String? eventId;
  String? accountId;
  String? ticketCode;
  String? vendor;
  String? qrContent;
  String? qrUrl;
  String? createdAt;
  String? updatedAt;
  ReservatioinModel? reservation;
  DefaultTicketSchemaType? ticketType;
  String? id;
  EventData? eventData;

  TicketNFTModel.fromApi(Map<String, dynamic> data){

    redeemed = false;
    __v = 0;
    ticketTypeId = data['ticketTypeId'];
    eventId = data['eventId'];
    accountId = data['accountId'];
    ticketCode = data['ticketCode'];
    vendor = data['vendor'];
    qrContent = data['qrContent'];
    qrUrl = data['qrUrl'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
    reservation = ReservatioinModel.fromApi(data['reservation']);
    ticketType = DefaultTicketSchemaType().fromApi(data['ticketType']);
    id = data['id'];
    eventData = EventData.fromJson(data['event']);

  }

}

class EventData {

	String? name;
	String? description;
	String? shortDescription;
	String? location;
	String? image;
	String? address;
	String? openHour;
	String? startDate;
	String? endDate;
	String? createdAt;
	String? updatedAt;
	String? status;
	String? id;
	int? __v;

  EventData.fromJson(Map<String, dynamic> data){
    name = data['name'];
    description = data['description'];
    shortDescription = data['shortDescription'];
    location = data['location'];
    image = data['image'];
    address = data['address'];
    openHour = data['openHour'];
    startDate = data['startDate'];
    endDate = data['endDate'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
    status = data['status'];
    id = data['id'];
    __v = data['__v'];
  }

}

class ReservatioinModel {

  String? ticketId;
  String? eventId;
  String? ticketTypeId;
  String? sessionId;
  String? id;
  int? __v;
  String? createdAt;
  String? updatedAt;
  Session? session;

  ReservatioinModel.fromApi(Map<String, dynamic> dataApi){
    print("ReservatioinModel");
    print("dataApi $dataApi");
    ticketId = dataApi['ticketId'];
    eventId = dataApi['eventId'];
    ticketTypeId = dataApi['ticketTypeId'];
    sessionId = dataApi['sessionId'];
    id = dataApi['id'];
    __v = dataApi['__v'];
    createdAt = dataApi['createdAt'];
    updatedAt = dataApi['updatedAt'];
    session = Session().fromApi(dataApi['session']);
  }
}