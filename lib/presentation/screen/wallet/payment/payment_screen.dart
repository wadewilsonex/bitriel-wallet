import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/wallet/payment/coin_select_screen.dart';

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
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
      
            ValueListenableBuilder(
              valueListenable: paymentUcImpl.index, 
              builder: (context, value, wg){
                if (paymentUcImpl.lstContractDropDown.isEmpty) return const SizedBox();
                return Column(
                  children: [
                    Text(paymentUcImpl.lstContractDropDown[value].balance ?? 0.toString(), style: const TextStyle(fontSize: 30),),
                    Text(paymentUcImpl.lstContractDropDown[value].symbol!)
                  ],
                );
              }
            ),
      
            // Consumer<WalletProvider>(
            //   builder: (context, pro, wg){
            // //     return dropDown(pro.sortListContract!, paymentUcImpl);
            //   },
            // ),

            InkWell(
              onTap: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (builder) => SelectCoin(paymentUcImpl: paymentUcImpl) )
                );
              },
              child: const Text("Select Token")
            ),
      
            _getEnterAddrSection(paymentUcImpl),
            
            _getEnterAmountSection(paymentUcImpl),
            
            ValueListenableBuilder(
              valueListenable: paymentUcImpl.trxMessage, 
              builder: (context, value, wg){
                return Text(value, style: const TextStyle(color: Colors.red),);
              }
            ),
      
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
      
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: paymentUcImpl.isReady,
                      builder: (context, value, wg) {
                        return MyButton(
                          edgeMargin: const EdgeInsets.all(10),
                          textButton: "Send",
                          fontWeight: FontWeight.w600,
                          buttonColor: value == false ? AppColors.grey : AppColors.primary,
                          opacity: 0.9,
                          action: value == false ? null : () async {
                            
                            await paymentUcImpl.submitTrx();
      
                          },
                        );
                      }
                    ),
                  ),
                ],
              ),
            )
      
          ],
        ),
      ),
    );
  }
}

Widget _getEnterAddrSection(PaymentUcImpl paymentUcImpl) {
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
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
              child: Text(
                'Enter Address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              child: TextFormField(
                controller: paymentUcImpl.recipientController,
                onChanged: paymentUcImpl.onChanged,
                validator: paymentUcImpl.addressValidator,
                focusNode: paymentUcImpl.addrNode,
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

Widget _getEnterAmountSection(PaymentUcImpl paymentUcImpl) {
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
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
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
                      child: TextFormField(
                        controller: paymentUcImpl.amountController,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: paymentUcImpl.amtValidator,
                        focusNode: paymentUcImpl.amtNode,
                        onChanged: paymentUcImpl.onChanged,
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black
                        ),
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
