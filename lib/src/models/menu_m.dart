import 'package:wallet_apps/index.dart';

class MenuModel {
  bool switchBio = false;
  bool switchPasscode = false;
  bool? authenticated;

  GlobalKey<ScaffoldState>? globalKey;

  Map result = {};

  /// (0) History, (0.1) History, (0.2) Acitivity
  /// 
  /// (1) Wallet, (1.1) Wallet, (1.2) Asset
  /// 
  /// (2) SEL event, (2.1) Claim, (2.2) Swap, (2.3) Presale
  /// 
  /// (3) Security, (3.1) Password, (3.2) FingerdebugPrint
  /// 
  /// (4) Display, (4.1) Darkmode
  /// 
  /// (5) About, (4.1) About
  static List listTile = [
    {
      'title': "History",
      'sub': [
        {'icon': "${AppConfig.iconsPath}history.svg", 'subTitle': 'History'},
        {'icon': "${AppConfig.iconsPath}history.svg", 'subTitle': 'Activity'}
      ]
    },
    {
      'title': "Wallet",
      'sub': [
        {'icon': "${AppConfig.iconsPath}wallet.svg", 'subTitle': 'Wallet'},
        {'icon': "${AppConfig.iconsPath}plus.svg", 'subTitle': 'Asset'},
        {'icon': "${AppConfig.iconsPath}wallet-connect.png", 'subTitle': 'Wallet Connect'}
      ]
    },
    {
      'title': "SEL Events",
      'sub': [
        {'icon': "${AppConfig.iconsPath}swap.svg", 'subTitle': 'Swap SEL v2'},
        {'icon': "${AppConfig.iconsPath}presale.svg", 'subTitle': 'Presale SEL'},
      ]
    },
    {
      'title': "Security",
      'sub': [
        {'icon': "${AppConfig.iconsPath}password.svg", 'subTitle': 'Passcode'},
        {'icon': "${AppConfig.iconsPath}finger_debugPrint.svg", 'subTitle': 'FingerdebugPrint'}
      ]
    },
    {
      'title': "Display",
      'sub': [
        {'icon': "${AppConfig.iconsPath}moon.svg", 'subTitle': 'Night Mode'},
        {'icon': "${AppConfig.iconsPath}moon.svg", 'subTitle': 'Network'},
      ]
    },
    {
      'title': "About",
      'sub': [
        {'icon': "${AppConfig.iconsPath}info.svg", 'subTitle': 'About'},
        {'icon': "${AppConfig.iconsPath}info.svg", 'subTitle': 'Terms of Service'},
        {'icon': "${AppConfig.iconsPath}info.svg", 'subTitle': 'Privacy Policy'},
      ]
    },
  ];
}
