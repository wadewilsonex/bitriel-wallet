import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/doers_event_ticket/details_event_ticket/body_details_event_ticket.dart';

class DetailEventTicket extends StatefulWidget {
  const DetailEventTicket({Key? key}) : super(key: key);

  @override
  State<DetailEventTicket> createState() => _DetailEventTicketState();
}

class _DetailEventTicketState extends State<DetailEventTicket> {
  @override
  Widget build(BuildContext context) {
    return DetailsEventTicketBody();
  }
}