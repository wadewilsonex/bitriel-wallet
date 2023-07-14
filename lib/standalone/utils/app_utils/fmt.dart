import 'dart:math';

import 'package:intl/intl.dart';

class Fmt {

  // Convert number commas EX: 10000000 => 10,000,000
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String Function(Match) mathFunc = (Match match) => '${match[1]},';

  // Convert number to word
  final formatter = NumberFormat.compact(locale: "en_US", explicitSign: false);

  static String doubleFormat(
    double? value, {
    int length = 6,
    int round = 0,
  }) {
    if (value == null) {
      return '~';
    }
    final NumberFormat f =
        NumberFormat(",##0${length > 0 ? '.' : ''}${'#' * length}", "en_US");
    return f.format(value);
  }

  static String balance(
    String? raw,
    int decimals, {
    int length = 6,
  }) {
    if (raw == null || raw.isEmpty) {
      return '~';
    }
    return doubleFormat(bigIntToDouble(balanceInt(raw), decimals),
        length: length);
  }

  static String token(
    BigInt? value,
    int decimals, {
    int length = 6,
  }) {
    if (value == null) {
      return '~';
    }
    return doubleFormat(bigIntToDouble(value, decimals), length: length);
  }

  static BigInt balanceInt(String? raw) {
    if (raw == null || raw.isEmpty) {
      return BigInt.zero;
    }
    if (raw.contains(',') || raw.contains('.')) {
      return BigInt.from(NumberFormat(",##0.000").parse(raw));
    } else {
      return BigInt.parse(raw);
    }
  }

  static BigInt tokenInt(String? value, int decimals) {
    if (value == null) {
      return BigInt.zero;
    }
    double v = 0;
    try {
      if (value.contains(',') || value.contains('.')) {
        v = NumberFormat(",##0.${"0" * decimals}").parse(value).toDouble();
      } else {
        v = double.parse(value);
      }
      // ignore: empty_catches
    } catch (err) {}
    return BigInt.from(v * pow(10, decimals));
  }

  static double bigIntToDouble(BigInt? value, int decimals) {
    if (value == null) {
      return 0;
    }
    return value / BigInt.from(pow(10, decimals));
  }

}
