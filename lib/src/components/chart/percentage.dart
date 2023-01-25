import 'package:google_fonts/google_fonts.dart';
import 'package:wallet_apps/index.dart';
import 'package:unicons/unicons.dart';

Container profitPercentageWidget(double profitPercent) {
  return Container(
    decoration: BoxDecoration(
      color: profitPercent >= 0 ? Colors.green[600] : Colors.red[600],
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.vmax, vertical: 0.5.vmax),
      child: Row(
        children: [
          Text(
            '(${profitPercent.toStringAsFixed(2).replaceFirst('.', ',')}%)',
            style: GoogleFonts.poppins(
              color: Colors.white,
              letterSpacing: 0.5,
              fontWeight: FontWeight.bold,
              fontSize: 2.vmax,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Icon(
            profitPercent >= 0
                ? UniconsLine.arrow_growth
                : UniconsLine.chart_down,
            color: Colors.white,
            size: 18.sp,
          ),
        ],
      ),
    ),
  );
}
