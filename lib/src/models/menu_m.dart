import 'package:wallet_apps/index.dart';

class MenuModel {
  bool switchBio = false;
  bool switchPasscode = false;
  bool? authenticated;

  GlobalKey<ScaffoldState>? globalKey;

  Map result = {};

  static List listTile = [
    {
      'title': "History",
      'sub': [
        {'icon': AppConfig.iconsPath+"history.svg", 'subTitle': 'History'},
        {'icon': AppConfig.iconsPath+"history.svg", 'subTitle': 'Activity'}
      ]
    },
    {
      'title': "Wallet",
      'sub': [
        {'icon': AppConfig.iconsPath+"wallet.svg", 'subTitle': 'Wallet'},
        {'icon': AppConfig.iconsPath+"plus.svg", 'subTitle': 'Asset'}
      ]
    },
    {
      'title': "SEL Events",
      'sub': [
        {'icon': AppConfig.iconsPath+"form.svg", 'subTitle': 'Claim SEL'},
        {'icon': AppConfig.iconsPath+"form.svg", 'subTitle': 'Claim KGO'},
        {'icon': AppConfig.iconsPath+"add_people.svg", 'subTitle': 'Invite Friends'},
        {'icon': AppConfig.iconsPath+"swap.svg", 'subTitle': 'Swap SEL v2'},
        {'icon': AppConfig.iconsPath+"presale.svg", 'subTitle': 'Presale SEL'},
      ]
    },
    {
      'title': "Security",
      'sub': [
        {'icon': AppConfig.iconsPath+"password.svg", 'subTitle': 'Passcode'},
        {'icon': AppConfig.iconsPath+"finger_print.svg", 'subTitle': 'Fingerprint'}
      ]
    },
    {
      'title': "Display",
      'sub': [
        {'icon': AppConfig.iconsPath+"moon.svg", 'subTitle': 'Dark Mode'},
      ]
    },
    {
      'title': "About",
      'sub': [
        {'icon': AppConfig.iconsPath+"info.svg", 'subTitle': 'About'},
        // {'icon': AppConfig.iconsPath+"edit_user.svg", 'subTitle': 'Term of Use'},
      ]
    },
  ];
}
