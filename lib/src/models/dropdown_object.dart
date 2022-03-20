import 'package:wallet_apps/index.dart';

class DropdownObject {
  String assetName;
  String assetImg;

  DropdownObject(this.assetName, this.assetImg);
}

List<DropdownObject> dropDownObjectList = [
  DropdownObject('BNB', AppConfig.assetsPath+'token_logo/bnb.png'),
  DropdownObject('BUSD', AppConfig.assetsPath+'token_logo/busd.png'),
  DropdownObject('USDT', AppConfig.assetsPath+'token_logo/dai.png'),
  DropdownObject('DAI', AppConfig.assetsPath+'token_logo/usdt.png'),
  DropdownObject('ETH', AppConfig.assetsPath+'token_logo/eth.png'),
];
