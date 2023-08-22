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
                    balance: value.sortListContract![index].balance!.replaceAll(",", "")
                  );
                }
              );
            }
          ),
          
        ],
      ),
    );
  }

  Widget _listTokenItem({required BuildContext context, required WalletProvider value, required int index, required String name, required String symbol, required String balance}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      leading: SizedBox(
        height: 35,
        width: 35,
        child: value.sortListContract![index].logo != null ? 
          Image.network(value.sortListContract![index].logo!, height: 35, width: 35,) : 
          CircleAvatar(
            child: MyTextConstant(
              text: value.sortListContract![index].isBep20 == true ? "BEP20" : "ERC20",
              fontSize: 9,
            ),
          ),
      ),
      title: Row(
        children: [
          MyTextConstant(
            text: name,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
          ),
    
          value.sortListContract![index].isNative == true || 
          value.sortListContract![index].isEther == true ||
          value.sortListContract![index].isBSC == true ?
          Container() :
          Card(
            color: hexaCodeToColor(AppColors.cardColor),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: MyTextConstant(
                text: value.sortListContract![index].isBep20 == true ? "BNB Smart Chain" : "Ethereum",
                textAlign: TextAlign.start,
                fontSize: 10,
              ),
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
          text: double.parse(balance).toStringAsFixed(2),
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