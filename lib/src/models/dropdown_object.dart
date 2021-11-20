class DropdownObject {
  String assetName;
  String assetImg;

  DropdownObject(this.assetName, this.assetImg);
}

List<DropdownObject> dropDownObjectList = [
  DropdownObject('BNB', 'assets/token_logo/bnb.png'),
  DropdownObject('BUSD', 'assets/token_logo/busd.png'),
  DropdownObject('USDT', 'assets/token_logo/dai.png'),
  DropdownObject('DAI', 'assets/token_logo/usdt.png'),
  DropdownObject('ETH', 'assets/token_logo/eth.png'),
];
