import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/chart/line_chart.dart';

Padding chartAsset(
    bool isHomePage,
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
  double profitPercent =
      ((spots.last.y - spots[spots.length - 2].y) / spots[spots.length - 2].y) *
          100;

  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Center(
      child: Container(
        decoration: BoxDecoration(
          color: hexaCodeToColor(AppColors.bluebgColor),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 2.h,
            horizontal: 2.w,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 25.sp,
                    child: logo!,
                  ),

                  SizedBox(
                    width: 50.w,
                    child: Text(
                      '$crypto ($cryptoCode) - $exchangeCurrency',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Expanded(child: Container()),

                  MyText(
                    text: "\$$marketPrice",
                    color: AppColors.greyColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  
                  // Column(
                  //   children: [
                  //     // Transform.scale(
                  //     //   child: profitPercentageWidget(profitPercent),
                  //     //   scale: 0.9
                  //     // ),
                  //   ],
                  // ),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
                child: SizedBox(
                  width: 90.w,
                  height: 10.h,
                  child: Obx(
                    () => LineChart(chart(isHomePage, spots, minY.value,
                      maxY.value, profitPercent >= 0)
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
