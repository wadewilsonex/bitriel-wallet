import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/chart/line_chart.dart';

Padding chartAsset(
    Widget? logo,
    String crypto,
    String cryptoCode,
    String exchangeCurrency,
    String marketPrice,
    List<FlSpot> spots,
    ) {
  Rx<double> minY = 0.0.obs;
  Rx<double> maxY = 0.0.obs;
  List sortedSpots = spots.toList();
  sortedSpots.sort((a, b) => a.y.compareTo(b.y));
  minY.value = sortedSpots.first.y;
  maxY.value = sortedSpots.last.y;

  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Center(
      child: Container(
        decoration: BoxDecoration(
          color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.whiteColorHexa),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 2,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  SizedBox(
                    height: 55,
                    width: 55,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(color: Colors.white, child: logo),
                    ),
                  ),
                  // SizedBox(
                  //   width: 30.sp,
                  //   child: logo!,
                  // ),

                  Padding(
                    padding: EdgeInsets.only(left: 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$crypto ($cryptoCode) - $exchangeCurrency',
                          style: TextStyle(
                            fontSize: 16,
                            color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        MyText(
                          text: "\$$marketPrice",
                          hexaColor: isDarkMode ? AppColors.greyColor : AppColors.textColor,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),

                      ],
                    ),
                  ),

                  Expanded(child: Container()),

                ],
              ),

              Padding(
                padding: EdgeInsets.only(top: 5),
                child: SizedBox(
                  width: double.infinity,
                  height: 20,
                  child: Obx(
                    () => LineChart(chart(spots, minY.value, maxY.value,)
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
