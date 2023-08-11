import 'package:bitriel_wallet/index.dart';

class SelectCoin extends StatelessWidget {

  final PaymentUcImpl? paymentUcImpl;

  const SelectCoin({super.key, this.paymentUcImpl, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          
          Consumer<WalletProvider>(
            builder: (context, value, wg){
              return ListView.builder(
                itemCount: value.sortListContract!.length,
                shrinkWrap: true,
                itemBuilder: (context, index){
                  return InkWell(
                    child: Row(
                      children: [
                        Text(value.sortListContract![index].symbol!),

                        if (value.sortListContract![index].isBep20!)
                        const Text("BEP20")

                        else if (value.sortListContract![index].isErc20!)
                        const Text("BEP20")

                        else if (value.sortListContract![index].isNative!)
                        const Text("Native")

                        else if (value.sortListContract![index].isEther!)
                        const Text("Ethereum")

                        else if (value.sortListContract![index].isBSC!)
                        const Text("BSC"),
                      ],
                    ),
                    onTap: (){
                      paymentUcImpl!.assetChanged(index);

                      Navigator.pop(context);
                    },
                  );
                }
              );
            }
          )
        ],
      ),
    );
  }
}