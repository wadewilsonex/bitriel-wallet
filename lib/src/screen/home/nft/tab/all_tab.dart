import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/cards/nft_c.dart';

class AllTab extends StatelessWidget {

  final List<Map<String,dynamic>>? lstTicket;

  const AllTab({Key? key, this.lstTicket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return lstTicket!.isNotEmpty 
    ? ListView.builder(
      itemCount: 20,
      shrinkWrap: true,
      itemBuilder: (context, index){
        return Column(
          children: [

            TicketCardComponent(giftName: 'Claim Free SEL Tokens', index: index, length: 20,)
          ],
        );
      }
    ) : const Center(
      child: MyText(
        text: "No Ticket",
      ),
    );
  }
}