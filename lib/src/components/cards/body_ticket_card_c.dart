import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TicketCardBody extends StatefulWidget {
  const TicketCardBody({Key? key}) : super(key: key);

  @override
  State<TicketCardBody> createState() => _TicketCardBodyState();
}

class _TicketCardBodyState extends State<TicketCardBody> {

  // String? imageUrl;
  
  // TicketModel _tkModel = TicketModel();
  
  // DataSubmittion dataSubmition = DataSubmittion();

  // @override
  // void initState() {

  //   imageUrl = dotenv.get('IPFS_API');

  //   _tkModel.scrollController = ScrollController();

  //   _tkModel.scrollController!.addListener(() {
  //     print(" _tkModel.scrollController ${ _tkModel.scrollController!.initialScrollOffset}");
  //     if (_tkModel.scrollController!.offset == 0.0){
  //       _tkModel.tkTypeIndex = 0;
  //     } else {
  //       _tkModel.tkTypeIndex = 1;
  //     }
  //   });
    
  //   queryTicket();
  //   super.initState();
  // }

  // void queryTicket() async {

  //   print("queryTicket}");
  //   await PostRequest().getTicketsByEventId(widget.eventId!).then((value) async{
      
  //     _tkModel.ticketTypesFromApi = List<Map<String, dynamic>>.from(await json.decode(value.body));

  //     _tkModel.ticketTypesFromApi!.forEach( (element){

  //       _tkModel.lsTicketTypes!.add(
  //         TicketTypes.fromApi(element)
  //       );

  //     });

  //     print("_tkModel.lsTicketTypes ${_tkModel.lsTicketTypes}");
  //     querySessionsByTicketTypeId();
  //   });

  // }

  // void querySessionsByTicketTypeId() async {
    
  //   print("querySessionsByTicketTypeId");
  //   for (int i = 0; i < _tkModel.lsTicketTypes!.length; i++){

  //     // Initialize First List With Empty Data
  //     _tkModel.lsTicketTypes![i].lstMontYear!.add(ListMonthYear());

  //     await PostRequest().getTicketTypeGroupedByDate(_tkModel.lsTicketTypes![i].defaultTicketSchema!.id!, widget.eventId!).then((res) async {

  //       _tkModel.montYearFromApi = (await json.decode(res.body))['sessionsByMonth'];

  //       _tkModel.montYearFromApi!.entries.forEach( (f){

  //         // _tkModel.lsTicketTypes![i].lstMontYear![i].lstSessionsByMonth!.add(
  //         //   SessionModel().modelingSession(mmyy: f.key, ss: List<Map<String, dynamic>>.from(f.value))
  //         // );

  //       });

  //     });
  //   }

  //   setState(() { });
  // }

  // void onValueChange(String type, dynamic value) async {
    
  //   print("onValueChange");
  //   print("type $type");
  //   print("value $value");
  //   print("value.runtimeType ${value.runtimeType}");
    
  //   if (type == "join_date"){

  //     // {
  //     //   'date': data[tkTypeIndex].lstSessionsByMonth![index].sessions![i].date, 
  //     //   /// Index of TicketType
  //     //   '1_tkType_index': tkTypeIndex,
  //     //   /// Index Of Date - Year 
  //     //   '2_ddyy_index': index,
  //     //   /// Session Index
  //     //   '3_date_index': i,
  //     // }

  //     setState(() {
  //       _tkModel.lsTicketTypes![value['1_tkType_index']].mmYYIndex = value['2_ddyy_index'];//DateTime.parse(AppUtils.stringDateToDateTime());
  //       _tkModel.lsTicketTypes![value['1_tkType_index']].joinDateIndex = value['3_date_index'];//DateTime.parse(AppUtils.stringDateToDateTime());

  //       _tkModel.lsTicketTypes![value['1_tkType_index']].isDate = true;
  //       _tkModel.lsTicketTypes![value['1_tkType_index']].selectDate = value['date'];//List<Map<String, dynamic>>.from(value['sessions']);
        
  //       // Assgin Data
  //       dataSubmition.date = value['date'];

  //     });

  //   }
  // }

  // // void onChangeSession(int ticketTypeIndex, int sessionIndex, Map<String, dynamic> data){
  // //   print("onChangeSession");
  // //   // Update Session Select
  // //   _tkModel.lstMontYear![ _tkModel.lsTicketTypes![ ticketTypeIndex ].tkTypeIndex! ].initSession = sessionIndex;

  // //   dataSubmition.from = data['from'];
  // //   dataSubmition.to = data['to'];

  // //   setState(() { });

  // // }

  // void onChangeQty(int value){
  //   if ( value.isNegative && dataSubmition.item!.qty! > 0 ){
  //     dataSubmition.item!.qty = dataSubmition.item!.qty! - 1;
  //   }
  //   if ( !(value.isNegative) && dataSubmition.item!.qty! >= 0) {
  //     dataSubmition.item!.qty = dataSubmition.item!.qty! + 1;
  //   }

  //   setState(() { });
  // }

  // // void onTabShow(bool value, int? index){
  // //   setState(() {
  // //     _tkModel.lstMontYear![index!].isShow = value;
  // //   });
  // // }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}