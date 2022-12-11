import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/cards/nft_c.dart';

class AllTab extends StatelessWidget {

  const AllTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      shrinkWrap: true,
      itemBuilder: (context, index){
        return Column(
          children: [

            TicketCardComponent(giftName: 'Claim Free SEL Tokens', index: index, length: 20,),
            // NFTCardComponent(eventName: 'Night Music Festival', index: index, length: 20,),
          ],
        );
      }
    );
  }
}