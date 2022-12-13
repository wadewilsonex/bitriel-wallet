import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/models/mdw_ticketing/ticket_m.dart';
import 'package:wallet_apps/src/provider/ticket_p.dart';
import 'package:wallet_apps/src/screen/home/events/list_ticket/dates_n_sessions/body_reservation.dart';

class Reservation extends StatefulWidget {

  final int? index;
  final String? eventId;
  final String? ticketTypeId;
  final TicketTypes? ticketTypeModel;
  final DataSubmittion? dataSubmittion;
  final TicketModel? ticketModel;
  final ScrollController? controller;

  const Reservation({
    Key? key,
    required this.index,
    required this.eventId,
    required this.ticketTypeId,
    required this.ticketTypeModel,
    required this.dataSubmittion,
    required this.ticketModel,
    required this.controller
  }) : super(key: key);

  @override
  State<Reservation> createState() => RreservationState();
}

class RreservationState extends State<Reservation> {

  TicketProvider? ticketProvider;

  List<ListMonthYear>? lstMontYear;

  DataSubmittion? dataSubmittion;

  void querySessionsByTicketTypeId() async {
    
    await PostRequest().getTicketTypeGroupedByDate(widget.ticketTypeId!, widget.eventId!).then((res) async {

      (await json.decode(res.body))['sessionsByMonth'].entries.forEach( (MapEntry f){
        lstMontYear!.add(
          ListMonthYear().fromApi(f)
        );
      });

    });

    if (mounted) setState(() { });

  }

  void onDateChange(int index) async {

    dataSubmittion!.date = lstMontYear![ dataSubmittion!.indexMonthYear! ].session!.lstDateAndSessions![index].date;
    dataSubmittion!.indexDate = index;

    if (mounted) setState(() { });
  }

  void onTabShow(bool value){
    setState(() {
      widget.ticketTypeModel!.isShow = value;
    });
  }

  void onSessionChange(int value, Map<String, dynamic> data){

    dataSubmittion!.from = data['from'];
    dataSubmittion!.to = data['to'];

    lstMontYear![ dataSubmittion!.indexMonthYear! ].initSession = value;
    
    widget.controller!.animateTo(150, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    
    if (mounted) setState(() { });

  }

  void onQtyChange(int value){
    if ( value.isNegative && dataSubmittion!.item!.qty! > 0 ){
      dataSubmittion!.item!.qty = dataSubmittion!.item!.qty! - 1;
    }
    if ( !(value.isNegative) && dataSubmittion!.item!.qty! >= 0) {
      dataSubmittion!.item!.qty = dataSubmittion!.item!.qty! + 1;
    }

    if (mounted) setState(() { });
  }

  @override
  initState(){

    lstMontYear = List<ListMonthYear>.empty(growable: true);
    ticketProvider = Provider.of<TicketProvider>(context, listen: false);

    dataSubmittion = widget.dataSubmittion!;

    dataSubmittion!.item!.ticketTypeId = widget.ticketTypeId;
    dataSubmittion!.eventId = widget.eventId;

    querySessionsByTicketTypeId();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReservationBody(
      dataSubmittion: dataSubmittion,
      lstMontYear: lstMontYear,
      ticketTypeModel: widget.ticketTypeModel!,
      onDateChange: onDateChange,
      onTabShow: onTabShow,
      onSessionChange: onSessionChange,
      onQtyChange: onQtyChange
    );
  }
}