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
  ReservatioinModel? reservatioin;
  DefaultTicketSchemaType? ticketType;
  String? id;

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
    reservatioin = ReservatioinModel.fromApi(data['reservation']);
    ticketType = DefaultTicketSchemaType().fromApi(data['ticketType']);
    id = data['id'];

  }

}

class ReservatioinModel {

  String? ticketId;
  String? eventId;
  String? ticketTypeId;
  String? sessionId;
  String? id;

  ReservatioinModel.fromApi(Map<String, dynamic> dataApi){
    ticketId = dataApi['ticketId'];
    eventId = dataApi['eventId'];
    ticketTypeId = dataApi['ticketTypeId'];
    sessionId = dataApi['sessionId'];
    id = dataApi['id'];
  }
}