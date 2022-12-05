import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/cards/nft_c.dart';

class GiftTab extends StatelessWidget {

  const GiftTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index){
        return GiftCardComponent(giftName: 'Claim Free SEL Tokens', index: index, length: 20,);
      }
    );
  }
}