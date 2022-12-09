class DataSubmittion {

  String? name;
  String? phoneNumber;
  String? email;
  String? date;
  String? from;
  String? to;

  Items? item;
  
  DataSubmittion(){
    
    name = "";
    phoneNumber = "";
    email = "";
    date = "";
    from = "";
    to = "";

    item = Items();
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

  /// [ {name: Early Bird}, {name: standard} ... ]
  List<Map<String, dynamic>>? ticketTypesFromApi;
  List<TicketTypes>? lsTicketTypes;

  // List<Map<String, dynamic>>? lsTicketTypes;

  Map<String, dynamic>? montYearFromApi;
  List<ListMonthYear>? lstMontYear;

  TicketModel(){

    ticketTypesFromApi = [];
    lsTicketTypes = List<TicketTypes>.empty(growable: true);

    montYearFromApi = {};
    lstMontYear = List<ListMonthYear>.empty(growable: true);
  }
  
}

class TicketTypes {

  int? tkTypeIndex;

  bool? isDate;
  int? joinDateIndex;
  int? mmYYIndex;
  String? selectDate;

  bool? isAmtTicket;
  int? amtTicket;
  bool? enable;

  DefaultTicketSchema? defaultTicketSchema;

  // TicketTypes(){}
  
  TicketTypes.fromApi(Map<String, dynamic> data){

    isDate = false;
    joinDateIndex = -1;
    tkTypeIndex = -1;
    mmYYIndex = -1;

    isAmtTicket = false;
    amtTicket = 0;
    
    defaultTicketSchema = DefaultTicketSchema().fromApi(data);
  }
}

class DefaultTicketSchema {

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

  DefaultTicketSchema fromApi(Map<String, dynamic> data){
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
  SessionModel? session;
  Map<String, dynamic>? selectSession;
  List<SessionModel>? lstSessionsByMonth;

  ListMonthYear(){

    isSession = false;
    isShow = false;
    initSession = 0;

    lstSessionsByMonth = List<SessionModel>.empty(growable: true);
    session = SessionModel();
    selectSession = {};
  }

}


class SessionModel {

  String? mmYY;
  
  List<DateAndSessions>? lstDateAndSessions;

  SessionModel(){
    mmYY = '';
    
    lstDateAndSessions = List<DateAndSessions>.empty(growable: true);
  }

  SessionModel modelingSession({String? mmyy, List<Map<String, dynamic>>? ss}){
   
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