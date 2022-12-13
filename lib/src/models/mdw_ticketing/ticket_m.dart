import 'package:wallet_apps/index.dart';

class DataSubmittion {

  ScrollController scrollCon = ScrollController();

  String? ticketTypeImage;
  String? ticketTypeName;
  String? eventName;

  /// Process 1
  int? indexMonthYear;

  /// Index Of Date Inside Month - Year;
  /// 
  /// Process 2
  int? indexDate;

  bool? isFinishInfo;

  DataSubmittion.assignAboveData(String name, String img, int index, int pc){

    ticketTypeName = name;
    ticketTypeImage = img;
    indexMonthYear = index;

    price = pc;
    name = "";
    phoneNumber = "";
    email = "";
    date = "";
    from = "";
    to = "";

    item = Items();
  }

  // --------------------

  int? price;
  String? eventId;
  String? name;
  String? phoneNumber;
  String? email;
  String? date;
  String? from;
  String? to;

  Items? item;
  
  DataSubmittion(){
    
    price = 0;
    name = "";
    phoneNumber = "";
    email = "";
    date = "";
    from = "";
    to = "";

    item = Items();
  }

  Map<String, dynamic> toJson(DataSubmittion data){
    return {
      "code": "",
      "items": [
        {
          "ticketTypeId": data.item!.ticketTypeId,
          "qty": data.item!.qty
        }
      ],
      "info": {
        "name": data.name,
        "phoneNumber": data.phoneNumber,
        "email": data.email
      },
      "reservation": {
        "admission": {
          "date": data.date,
          "from": data.from,
          "to": data.to
        },
        "eventId": "637ff66d4903dd71e36fd4cd"
      }
    };
  }
}

class Items {

  String? ticketTypeId;
  int? qty;

  Items(){
    ticketTypeId = "";
    qty = 0;
  }
}

class TicketModel {

  String? eventId;
  int? tkTypeIndex;

  ScrollController? scrollController;

  /// [ {name: Early Bird}, {name: standard} ... ]
  List<Map<String, dynamic>>? ticketTypesFromApi;
  List<TicketTypes>? lsTicketTypes;

  Map<String, dynamic>? montYearFromApi;

  TicketModel(){

    tkTypeIndex = -1;
    eventId = '';
    ticketTypesFromApi = [];
    lsTicketTypes = List<TicketTypes>.empty(growable: true);

    montYearFromApi = {};

    scrollController = ScrollController();
  }
  
}

class TicketTypes {
  
  bool? isShow;
  int? joinDateIndex;
  int? mmYYIndex;
  String? selectDate;

  bool? isAmtTicket;
  int? amtTicket;
  bool? enable;

  DefaultTicketSchemaType? defaultTicketSchemaType;

  // TicketTypes(){}
  
  TicketTypes.fromApi(Map<String, dynamic> data){
    isShow = false;
    joinDateIndex = -1;
    mmYYIndex = -1;

    isAmtTicket = false;
    amtTicket = 0;
    
    defaultTicketSchemaType = DefaultTicketSchemaType().fromApi(data);
  }
}

class DefaultTicketSchemaType {

  String? id;
  String? name;
  String? description;
  String? image;
  List<String>? eventIds;
  int? price;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;
  int? __v;
  String? status;

  DefaultTicketSchemaType fromApi(Map<String, dynamic> data){
    id = data['id'];
    name = data['name'];
    description = data['description'];
    image = data['image'];
    eventIds = List<String>.from(data['eventIds']);
    price = data['price'];
    startDate = data['startDate'];
    endDate = data['endDate'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
    __v = data['__v'];
    status = data['status'];
    return this;

  }
}

class ListMonthYear {
  
  bool? isSession;
  bool? isShow;
  int? initSession;
  
  DateReservation? session;

  Map<String, dynamic>? selectSession;

  String? dateReservation;

  ListMonthYear(){

    isSession = false;
    isShow = false;
    initSession = -1;

    session = DateReservation();
    
    selectSession = {};

  }

  ListMonthYear fromApi(MapEntry mapEntry){
    
    session = DateReservation().modelingSession(mmyy: mapEntry.key, ss: List<Map<String, dynamic>>.from(mapEntry.value));

    return this;
  }

}

class DateReservation {

  String? mmYY;
  
  List<DateAndSessions>? lstDateAndSessions;

  DateReservation(){
    mmYY = '';
    
    lstDateAndSessions = List<DateAndSessions>.empty(growable: true);
  }

  DateReservation modelingSession({String? mmyy, List<Map<String, dynamic>>? ss}){
   

    // Define Month - Year Of Event
    mmYY = mmyy;
    
    // Loop of Data's sessionsByMonth
    lstDateAndSessions!.add(DateAndSessions());
    
    for (int i = 0; i < ss!.length; i ++){
      
      lstDateAndSessions![i].date = ss[i]['date'];
      
      lstDateAndSessions![i].sessions = List<Session>.empty(growable: true);
      
      for (Map<String, dynamic> s2 in ss[i]['sessions']){
        
        // Loop of Data's sessions
        lstDateAndSessions![i].sessions!.add(Session().fromApi(s2)); 
          
      }
      
      // Add New Object To List DateAndSessions
      if (i != ss.length-1)lstDateAndSessions!.add(DateAndSessions());
    }
    return this;
  }

}

class DateAndSessions{
  
  String? date;
  
  List<Session>? sessions;
  
  DaetAndSessions(){
    sessions = [];
  }
}

class Session {
  
  String? from;
  String? to;
  String? id;
  String? eventId;
  String? ticketTypeId;
  String? date;
  int? availability;
  bool? active;
  String? status;
  int? reservations;
  
  Session fromApi(Map<String, dynamic> data){
    from = data['time']["from"];
    to = data['time']["to"];
    id = data["id"];
    eventId = data["eventId"];
    ticketTypeId = data["ticketTypeId"];
    date = data["date"];
    availability = data["availability"];
    active = data["active"];
    status = data["status"];
    reservations = data["reservations"];
    return this;
  }

}