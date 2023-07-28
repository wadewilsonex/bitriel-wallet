import 'package:bitriel_wallet/index.dart';

class TokenPayment extends StatelessWidget {
  
  const TokenPayment({Key? key, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) { 

    final PaymentUcImpl paymentUcImpl = PaymentUcImpl();

    paymentUcImpl.setBuildContext = context;

    return Scaffold(
      backgroundColor: hexaCodeToColor(AppColors.background),
      appBar: appBar(context, title: "Send"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Consumer<WalletProvider>(
            builder: (context, pro, wg){
              return dropDown(pro.sortListContract!, paymentUcImpl.index);
            },
          ),

          _getEnterAddrSection(paymentUcImpl.recipientController, paymentUcImpl.onChanged),
          
          _getEnterAmountSection(paymentUcImpl.amountController),

          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: MyButton(
                    edgeMargin: const EdgeInsets.all(10),
                    textButton: "Send",
                    fontWeight: FontWeight.w600,
                    buttonColor: AppColors.primary,
                    opacity: 0.9,
                    action: () async {
                      
                      await paymentUcImpl.submitTrx();

                    },
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}

Widget _getEnterAddrSection(TextEditingController addrController, void Function(String?) onChanged) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Card(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding:
                  EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
              child: Text(
                'Enter Address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              child: TextFormField(
                controller: addrController,
                onChanged: onChanged,
                style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
                decoration: const InputDecoration(
                    hintText: 'Address',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _getEnterAmountSection(TextEditingController amountController) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Card(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding:
                  EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
              child: Text(
                'Enter Amount',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset("assets/logo/bitriel-logo.png", height: 30, width: 30,),
                  ),
                  // const Text(
                  //   '\$',
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.bold, fontSize: 30.0),
                  // ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                        decoration: const InputDecoration(
                            hintText: 'Amount',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30.0)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
