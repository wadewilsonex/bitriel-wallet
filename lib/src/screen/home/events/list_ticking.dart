import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/components/appbar/event_c.dart';
import 'package:wallet_apps/src/components/cards/ticket_card_c.dart';
import 'package:wallet_apps/src/models/ticket_m.dart';

class ListTicket extends StatefulWidget {

  final String? eventName;
  final String? eventId;
  const ListTicket({Key? key, required this.eventName, required this.eventId}) : super(key: key);

  @override
  State<ListTicket> createState() => _ListTicketState();
}

class _ListTicketState extends State<ListTicket> {

  String? imageUrl;
  
  TicketModel _tkModel = TicketModel();
  
  DataSubmittion dataSubmition = DataSubmittion();

  @override
  void initState() {

    imageUrl = dotenv.get('IPFS_API');
    queryTicket();
    super.initState();
  }

  void queryTicket() async {

    print("queryTicket}");
    await PostRequest().getTicketsByEventId(widget.eventId!).then((value) async{
      
      _tkModel.ticketTypesFromApi = List<Map<String, dynamic>>.from(await json.decode(value.body));

      _tkModel.ticketTypesFromApi!.forEach( (element){

        _tkModel.lsTicketTypes!.add(
          TicketTypes.fromApi(element)
        );

      });

      print("_tkModel.lsTicketTypes ${_tkModel.lsTicketTypes}");
      querySessionsByTicketTypeId();
    });

  }

  void querySessionsByTicketTypeId() async {
    print("querySessionsByTicketTypeId");
    for (int i = 0; i < _tkModel.lsTicketTypes!.length; i++){

      // Initialize First List With Empty Data
      _tkModel.lstMontYear!.add(ListMonthYear());

      await PostRequest().getTicketTypeGroupedByDate(_tkModel.lsTicketTypes![i].defaultTicketSchema!.id!, widget.eventId!).then((res) async {

        _tkModel.montYearFromApi = (await json.decode(res.body))['sessionsByMonth'];

        _tkModel.montYearFromApi!.entries.forEach( (f){
          _tkModel.lstMontYear![i].lstSessionsByMonth!.add(
            SessionModel().modelingSession(mmyy: f.key, ss: List<Map<String, dynamic>>.from(f.value))
          );
        });

      });
    }

    setState(() { });
  }

  void onValueChange(String type, dynamic value) async {
    
    print("onValueChange");
    print("type $type");
    print("value $value");
    print("value.runtimeType ${value.runtimeType}");
    
    if (type == "join_date"){

      // {
      //   'date': data[tkTypeIndex].lstSessionsByMonth![index].sessions![i].date, 
      //   /// Index of TicketType
      //   '1_tkType_index': tkTypeIndex,
      //   /// Index Of Date - Year 
      //   '2_ddyy_index': index,
      //   /// Session Index
      //   '3_date_index': i,
      // }

      setState(() {
        _tkModel.lsTicketTypes![value['1_tkType_index']].tkTypeIndex = value['1_tkType_index'];//DateTime.parse(AppUtils.stringDateToDateTime());
        _tkModel.lsTicketTypes![value['1_tkType_index']].mmYYIndex = value['2_ddyy_index'];//DateTime.parse(AppUtils.stringDateToDateTime());
        _tkModel.lsTicketTypes![value['1_tkType_index']].joinDateIndex = value['3_date_index'];//DateTime.parse(AppUtils.stringDateToDateTime());

        _tkModel.lsTicketTypes![value['1_tkType_index']].isDate = true;
        _tkModel.lsTicketTypes![value['1_tkType_index']].selectDate = value['date'];//List<Map<String, dynamic>>.from(value['sessions']);
        
        // Assgin Data
        dataSubmition.date = value['date'];

      });

    }
  }

  void onChangeSession(int ticketTypeIndex, int sessionIndex, Map<String, dynamic> data){
    print("onChangeSession");
    // Update Session Select
    _tkModel.lstMontYear![ _tkModel.lsTicketTypes![ ticketTypeIndex ].tkTypeIndex! ].initSession = sessionIndex;

    dataSubmition.from = data['from'];
    dataSubmition.to = data['to'];

    setState(() { });

  }

  void onChangeQty(int value){
    if ( value.isNegative && dataSubmition.item!.qty! > 0 ){
      dataSubmition.item!.qty = dataSubmition.item!.qty! - 1;
    }
    if ( !(value.isNegative) && dataSubmition.item!.qty! >= 0) {
      dataSubmition.item!.qty = dataSubmition.item!.qty! + 1;
    }

    setState(() { });
  }

  void onTabShow(bool value, int? index){
    setState(() {
      _tkModel.lstMontYear![index!].isShow = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: eventAppBar(context: context, title: widget.eventName!),
      body: _tkModel.lsTicketTypes != null 
      ? ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: _tkModel.lsTicketTypes!.length,
        itemBuilder: (context, index){

          return TicketCardComponent(
            dataSubmittion: dataSubmition,
            ticketTypeIndex: index,
            ticketModel: _tkModel,
            ticketObj: _tkModel.ticketTypesFromApi![index], 
            imageUrl: imageUrl,
            mgLeft: index == 0 ? 20 : 0,
            mgRight: 20,
            lstLenght: _tkModel.lsTicketTypes!.length,
            onValueChange: onValueChange,
            onChangeSession: onChangeSession,
            onTabShow: onTabShow,
            onChangeQty: onChangeQty
          );
        }
      ) 
      : const Center(
        child: CircularProgressIndicator(),
      ),

    );
  }
}