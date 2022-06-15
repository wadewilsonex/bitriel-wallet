import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../index.dart';

class WalletProvider with ChangeNotifier {
  
  final List<PortfolioM> _portfolioM = [];

  List<Map<String, String>> availableToken = [];

  List<String> listSymbol = [
    'SEL',
    'DOT',
    'BNB',
    'ETH',
    'SEL (BEP-20)',
    'KGO (BEP-20)'
  ];

  List<Color> pieColorList = const [
    Color(0xFFff7675),
    Color(0xFF74b9ff),
    Color(0xFFffeaa7),
    Color(0xFF05ff1a),
    Color(0xFFa29bfe),
    Color(0xFF00b894),
    Color(0xFF55efc4),
    Color(0xFFfd79a8),
  ];

  Map<String, double> dataMap = {};
  List<PortfolioM> get portfolio => _portfolioM;

  // The Formula Find Percentage is
  // 1. Add each data to gether to get total
  // 2. Divide Each Data With Total To Get Float
  // 3. Take Eacher Data Divided To Multple By 100 To Get Percentage
  // For Pie Chart
  Future? fillWithMarketData(BuildContext context) {
    try {

      _portfolioM.clear();
      dataMap.clear();

      double temp = 0.0, total = 0.0, percen = 0.0;

      final market = Provider.of<MarketProvider>(context, listen: false);

      // Find Total Of All Asset
      market.sortDataMarket.forEach((element) {
        if (element['current_price'].runtimeType.toString() == 'int') {
          // To Convert Integer To Double By Plus With .0
          total = total + ((element['current_price']) + .0);
        } else
          total += element['current_price'];
      });

      // Loop Add Eacher Asset From Market
      for (int i = 0; i < market.sortDataMarket.length; i++) {

        // Divide Value With Total Of Asset
        temp = (market.sortDataMarket[i]['current_price'] + .0) / total;
        percen = temp * 100;

        // Use Round To Round Number
        _portfolioM.add(PortfolioM(
          color: pieColorList[i],
          symbol: market.sortDataMarket[i]['symbol'].toUpperCase(),
          percentage: percen.toStringAsFixed(2),
        ));

        // This Variable For Pie Chart Data
        dataMap.addAll({
          market.sortDataMarket[i]['symbol']:double.parse(percen.toStringAsFixed(4))
        });
      }

      notifyListeners();
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error fillWithMarketData $e");
    }
    return null;
  }

  void addTokenSymbol(String symbol) {
    listSymbol.add(symbol);
    notifyListeners();
  }

  void removeTokenSymbol(String symbol) {
    listSymbol.remove(symbol);
    notifyListeners();
  }

  void addAvaibleToken(Map<String, String> token) {
    availableToken.add(token);
    notifyListeners();
  }

  void updateAvailableToken(Map<String, String> token) {
    for (int i = 0; i < availableToken.length; i++) {
      if (availableToken[i]['symbol'] == token['symbol']) {
        availableToken[i].update('balance', (value) => token['balance']!);
      } else {
        addAvaibleToken(token);
      }
    }
    notifyListeners();
  }

  void removeAvailableToken(Map<String, String> token) {
    availableToken.remove(token);
    notifyListeners();
  }

  void setPortfolio(BuildContext context) {
    clearPortfolio();

    Provider.of<WalletProvider>(context, listen: false).getPortfolio();
  }

  void clearPortfolio() {
    availableToken.clear();
    _portfolioM.clear();
    dataMap.clear();
    notifyListeners();
  }

  Future<double> getTotal() async {
    double total = 0.0;

    for (int i = 0; i < availableToken.length; i++) {
      total = total + double.parse(availableToken[i]['balance']!);
    }

    return total;
  }

  void resetDatamap() {
    dataMap.update('SEL', (value) => value = 100);
    dataMap.update('KMPI', (value) => value = 0);
    dataMap.update('ATD', (value) => value = 0);
    notifyListeners();
  }

  Future<void> getPortfolio() async {
    _portfolioM.clear();
    dataMap.clear();

    await getTotal().then((total) {
      double percen = 0.0;

      for (int i = 0; i < availableToken.length; i++) {

        _portfolioM.add(
          PortfolioM(
              color: pieColorList[i],
              symbol: availableToken[i]['symbol']!,
              percentage: percen.toStringAsFixed(2)),
        );
      }
    });

    notifyListeners();
  }
}
