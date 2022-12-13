// This file hold Calculation And Data Convertion
import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:wallet_apps/index.dart';
import 'package:web3dart/web3dart.dart';


// ignore: avoid_classes_with_only_static_members
class AppUtils {

  static final globalKey = GlobalKey<NavigatorState>();

  static Color? txtColor;

  static Future<DeployedContract> contractfromAssets(String path, String contractAddr, {String? contractName}) async {
    final String contractJson = await rootBundle.loadString(path);
    return DeployedContract(
      ContractAbi.fromJson(contractJson, contractName ?? 'contract'),
      EthereumAddress.fromHex(contractAddr),
    );
  }

  static addrFmt(String address) {
    return '${address.substring(0, 6)}...${address.substring(address.length - 6, address.length)}';
  }

  static EthereumAddress getEthAddr(String address) =>
      EthereumAddress.fromHex(address);

  static int timeStampConvertor(String userDate) {
    /* Convert date to timestamp */
    final dateFormat = DateFormat('yyyy-MM-dd');
    final dateTime = dateFormat.parse(userDate);
    return dateTime.millisecondsSinceEpoch;
  }

  static String timeStampToDateTime(String timeStamp) {
    /* Convert Time Stamp To Date time ( Format yyyy-MM-ddTHH:mm:ssZ ) */
    final parse = DateTime.parse(timeStamp).toLocal(); /* Parse Time Stamp String to DateTime Format */
    return formatDate(parse, [
      yyyy,
      '-',
      mm,
      '-',
      dd,
      '   ',
      hh,
      ':',
      nn,
      ':',
      ss,
      ' ',
      am
    ]); /* Return Real Date Time */
  }

  String timeStampToDate(int timeStamp) {
    try {

      // final parse = DateTime.parse(timeStamp).toLocal(); /* Parse Time Stamp String to DateTime Format */
      final parse = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
      
      return formatDate(parse, [
        yyyy,
        '-',
        mm,
        '-',
        dd,
        '   ',
        hh,
        ':',
        nn,
        ':',
        ss,
        ' ',
        am
      ]);//formatDate(parse, [yyyy, '/', mm, '/', dd]); /* Return Real Date Time */
    } catch (e) {
      
      if (kDebugMode) {
        print("Error timeStampToDate $e");
      }
    }
    return '';
  }

  static String timeZoneToDateTime(String tz) {
    try {

      // final parse = DateTime.parse(timeStamp).toLocal(); /* Parse Time Stamp String to DateTime Format */
      final parse = DateTime.parse(tz);
      
      return formatDate(parse, [
        yyyy,
        '-',
        mm,
        '-',
        dd,
        '   ',
        hh,
        ':',
        nn,
        ':',
        ss,
        ' ',
        am
      ]);//formatDate(parse, [yyyy, '/', mm, '/', dd]); /* Return Real Date Time */
    } catch (e) {
      
      if (kDebugMode) {
        print("Error timeStampToDate $e");
      }
    }
    return '';
  }
  static String timeZoneToDate(String tz, {bool? isSpace = true}) {
    try {

      // final parse = DateTime.parse(timeStamp).toLocal(); /* Parse Time Stamp String to DateTime Format */
      final parse = DateTime.parse(tz);
      
      return formatDate(parse, [
        yyyy,
        '-',
        mm,
        '-',
        dd,
        isSpace! ? '   ' : '' 
      ]);//formatDate(parse, [yyyy, '/', mm, '/', dd]); /* Return Real Date Time */
    } catch (e) {
      
      if (kDebugMode) {
        print("Error timeStampToDate $e");
      }
    }
    return '';
  }

  static String stringDateToDateTime(String stringData) {
    /* Convert Time Stamp To Date time ( Format yyyy-MM-ddTHH:mm:ssZ ) */
    List<String> tmp = stringData.split(" ");
    
    return formatDate(DateTime.parse(tmp[0]), [
      yyyy,
      '-',
      mm,
      '-',
      dd
    ]); /* Return Real Date Time */
  }

  static String dateTimeToDateOnly(DateTime timeStamp) {
    /* Convert Time Stamp To Date time ( Format yyyy-MM-ddTHH:mm:ssZ ) */
    
    return formatDate(timeStamp, [
      yyyy,
      '-',
      mm,
      '-',
      dd
    ]); /* Return Real Date Time */
  }

  static String dateTimeToTimeOnly(DateTime timeStamp) {
    /* Convert Time Stamp To Date time ( Format yyyy-MM-ddTHH:mm:ssZ ) */
    
    return formatDate(timeStamp, [
      hh,
      ':',
      nn,
      ':',
      ss,
      ' ',
      am
    ]); /* Return Real Date Time */
  }

  static int convertHexaColor(String colorhexcode) {
    /* Convert Hexa Color */
    String colornew = '0xFF$colorhexcode';
    colornew = colornew.replaceAll('#', '');
    final colorint = int.parse(colornew);
    return colorint;
  }

  static int versionConverter(String version) {
    String convert = version.replaceAll(".", '');
    convert = convert.replaceAll('+', '');
    final parse = int.parse(convert);
    return parse;
  }

  List<String> randomThreeEachNumber(){
    // First Number
    String rd1 = Random().nextInt(12).toString();
    while(rd1 == "0"){
      rd1 = Random().nextInt(12).toString();
    }

    // Second Number
    String rd2 = Random().nextInt(12).toString();
    while(rd2 == rd1 || rd2 == "0"){
      rd2 = Random().nextInt(12).toString();
      if (rd2 != rd1) break;
    }

    // Third Number
    String rd3 = Random().nextInt(12).toString();
    while(rd3 == rd1 || rd3 == rd2 || rd3 == "0"){
      rd3 = Random().nextInt(12).toString();
      if (rd3 != rd1 && rd3 != rd2) break;
    }

    return [rd1, rd2, rd3];
  }

  /// Text Color Selector By Theme Mode
  static Color colorSelector({bool? isDark, String? hexaColor, Color? enumColor}){
    if (hexaColor != null){
      txtColor = hexaCodeToColor(hexaColor);
    }
    else if (enumColor != null){
      txtColor = enumColor;
    }
    // Default Black White
    else if (isDark!) {
      txtColor = hexaCodeToColor(AppColors.whiteColorHexa);
    } else {
      txtColor = hexaCodeToColor(AppColors.textColor);
    }
    
    return txtColor!;
  }

  static Color backgroundTheme(){
    return hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightBg);
  }
}

double offsetToOpacity({
  required double currentOffset,
  required double maxOffset,
  double returnMax = 1,
}) {
  return (currentOffset * returnMax) / maxOffset;
}


class ContractParser {}
