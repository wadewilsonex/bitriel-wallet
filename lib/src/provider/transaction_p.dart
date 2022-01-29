import 'package:wallet_apps/index.dart';

class TrxProvider with ChangeNotifier{

  double totalValue = 0.0;

  bool isTotal = true;
  
  double assetToUSD({@required String? value, @required double? assetPrice}){

    print("assetToUSD");
    print("valueInput $value");
    print("assetPrice $assetPrice");
    double parse = double.parse(value!);
    double price = parse * assetPrice!;
    price = double.parse(price.toStringAsPrecision(7));
    return price;
  }

  double usdToAsset({@required String? value, @required double? assetPrice}){
    double parse = double.parse(value!);
    print("usdToAsset");
    print("valueInput $value");
    print("assetPrice $assetPrice");
    double price = parse / assetPrice!;
    price = double.parse(price.toStringAsPrecision(7));
    print("Price $price");
    return price;
  }

  void totalAssetValue ({@required BuildContext? context}){
    print("totalAssetValue");
    final lsAsset = Provider.of<ContractProvider>(context!, listen: false).sortListContract;
    for (int i = 0; i < lsAsset.length; i++){

      print(lsAsset[i].symbol);
      print(lsAsset[i].balance);
      print(lsAsset[i].marketPrice);
      totalValue = totalValue + Provider.of<TrxProvider>(context, listen: false).assetToUSD(value: lsAsset[i].balance, assetPrice: double.parse(lsAsset[i].marketPrice!));
    }
    isTotal = false;

    notifyListeners();
  }
}