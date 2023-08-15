import 'package:bitriel_wallet/index.dart';

class SelectCoin extends StatelessWidget {

  final PaymentUcImpl? paymentUcImpl;

  const SelectCoin({super.key, this.paymentUcImpl, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, title: "Select Token"),
      body: Column(
        children: [
          
          Consumer<WalletProvider>(
            builder: (context, value, wg){
              return ListView.builder(
                itemCount: value.sortListContract!.length,
                shrinkWrap: true,
                itemBuilder: (context, index){
                  return _listTokenItem(
                    context: context,
                    value: value, 
                    index: index, 
                    name:value.sortListContract![index].name!,
                    symbol: value.sortListContract![index].symbol!,
                    balance: "0.00"
                  );
                }
              );
            }
          ),
          
        ],
      ),
    );
  }

  String _getTokenChain({required WalletProvider value, required int index}) {
    return (value.sortListContract![index].isBep20!) ? "BEP20" :
      (value.sortListContract![index].isErc20!) ? "ERC20" :
      (value.sortListContract![index].isEther!) ? "Ethereum" :
      (value.sortListContract![index].isBSC!) ? "BSC" : 
      "Native";
  }  

  Widget _listTokenItem({required BuildContext context, required WalletProvider value, required int index, required String name, required String symbol, required String balance}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      leading: const SizedBox(
        height: 30, 
        width: 30, 
        child: CircleAvatar(),
      ),
      title: Row(
        children: [
          MyTextConstant(
            text: name,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
          ),

          const SizedBox(width: 2.5),

          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: hexaCodeToColor(AppColors.cardColor),
              borderRadius: BorderRadius.circular(5)
            ),
            child: MyTextConstant(
              text: _getTokenChain(value: value, index: index),
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.start,
              fontSize: 12,
            ),
          ),
        ],
      ),
      subtitle: MyTextConstant(
        text: symbol,
        color2: hexaCodeToColor(AppColors.grey),
        fontSize: 12,
        textAlign: TextAlign.start,
      ),
      trailing: MyTextConstant(
          text: balance,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.start,
        ),
      onTap: () {
        paymentUcImpl!.assetChanged(index);

        Navigator.pop(context);
      },
    );
  }

}