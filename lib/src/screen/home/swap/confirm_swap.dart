

import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/swap_m.dart';

class ConfirmSwap extends StatefulWidget {

  final SwapResponseObj? res;

  const ConfirmSwap({Key? key, this.res}) : super(key: key);

  @override
  State<ConfirmSwap> createState() => _ConfirmSwapState();
}

class _ConfirmSwapState extends State<ConfirmSwap> {

  @override
  initState(){
    
    super.initState();
  }
  
  Future<void> confirmSwapMethod()async {
    print("Submit");

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black,),
          onPressed: () => Navigator.pop(context),
        ),
        title: const MyText(text: "Confirm Transaction"),
      ),
      body: Column(
        children: [

          MyText(
            text: widget.res!.status,
          ),
          SvgPicture.network(widget.res!.coin_from_icon!.replaceAll("\/", "\\")),
          
          MyText(
            text: widget.res!.coin_from,
          ),
          SvgPicture.network(widget.res!.coin_to_icon!.replaceAll("\/", "\\")),
          MyText(
            text: widget.res!.coin_to,
          ),
          MyText(
            text: widget.res!.deposit_amount,
          ),
          MyText(
            text: widget.res!.coin_from_network,
          ),
          MyText(
            text: widget.res!.coin_to_network,
          ),
          MyText(
            text: widget.res!.withdrawal_amount,
          ),
          MyText(
            text: widget.res!.transaction_id,
          ),

          MyGradientButton(
            edgeMargin: const EdgeInsets.all(paddingSize),
            textButton: "Confirm Swap",
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            action: () async {
              // underContstuctionAnimationDailog(context: context);
              confirmSwapMethod();
            },
          ),
        ],
      ),
    );
  }
}