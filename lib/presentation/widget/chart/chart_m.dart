import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/widget/chart/line_chart.dart';
import 'package:get/get.dart';

Padding chartAsset(
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
          color: hexaCodeToColor(AppColors.cardColor),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.blueGrey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$crypto ($cryptoCode) - $exchangeCurrency',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                    ],
                  ),

                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: SizedBox(
                  width: double.infinity,
                  height: 100,
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
