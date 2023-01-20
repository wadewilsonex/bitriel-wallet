import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet_apps/src/api/api_chart.dart';

import '../../../../index.dart';
import '../../../components/chart/chart_m.dart';

class AssetDetail extends StatefulWidget {
  // final Market marketData;
  final SmartContractModel scModel;
  const AssetDetail(
    // this.marketData, 
    this.scModel, {Key? key}
  ) : super(key: key);

  @override
  AssetDetailState createState() => AssetDetailState();
}

class AssetDetailState extends State<AssetDetail> {

  bool _isLoaded = false;
 


  String convert(String? supply) {
    var formatter = NumberFormat.decimalPattern();

    if (supply != null) {
      if (supply.contains('.')) {
        var value = supply.replaceFirst(RegExp(r"\.[^]*"), "");
        return formatter.format(int.parse(value));
      }
    }

    return formatter.format(int.parse(supply!));
  }

  String periodID = '1DAY';
  void queryAssetChart() async {
    await ApiCalls().getChart(
      widget.scModel.symbol!, 
      'usd', periodID, 
      DateTime.now().subtract(const Duration(days: 6)), 
      DateTime.now()
    ).then((value) {

      widget.scModel.chart = value;

      setState(() {
        
      });
    });
  }

  @override
  void initState() {
    queryAssetChart();

    // make _isLoaded true after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoaded = true;
      });
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            if (widget.scModel.chart == null)
            const CircularProgressIndicator()
            
            else if (widget.scModel.chart!.isNotEmpty) 
            FadeInUp(
              duration: const Duration(milliseconds: 1000),
              child: SizedBox(
                width: double.infinity,
                height: 250,
                child: LineChart(
                  mainData(widget.scModel.chart!),
                  swapAnimationDuration: const Duration(milliseconds: 1000), // Optional
                  swapAnimationCurve: Curves.linear, // Optional
                ),
              ),
            ),
            chartAsset(
              true,
              ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: widget.scModel.logo!.contains('http') 
                ? Image.network(
                  widget.scModel.logo!,
                  fit: BoxFit.contain,
                )
                : Image.asset(
                  widget.scModel.logo!,
                  fit: BoxFit.contain,
                )
              ),
              widget.scModel.name!,
              widget.scModel.symbol!,
              'USD',
              widget.scModel.marketPrice!,
              widget.scModel.chart!,
            ),
            // else Container(),

            SizedBox(height: 2.h),
            
            widget.scModel.marketData == null 
            ? assetFromJson()
            : assetFromApi(),

          ],
        )
      ),
    );
  }

  Widget line() {
    return Container(
      height: 1,
      color: hexaCodeToColor("#C1C1C1").withOpacity(0.5)
    );
  }

  Widget textRow(String leadingText, String trailingText, String endingText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(
            text: leadingText,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              MyText(
                text: trailingText,
                hexaColor: isDarkMode
                  ? AppColors.whiteColorHexa
                  : AppColors.textColor,
                overflow: TextOverflow.ellipsis,
              ),
              MyText(
                text: endingText,
                hexaColor: endingText != '' && endingText.substring(1, 2) == '-'
                  ? '#FF0000'
                  : isDarkMode
                      ? '#00FF00'
                      : '#66CD00',
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget assetFromJson() {
    return widget.scModel.description != null ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MyText(
          text: 'Token Info',
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.left,
          hexaColor: AppColors.primaryColor,
        ),

        const SizedBox(height: 16.0),

        textRow('Token Name', widget.scModel.symbol!.toUpperCase(), ''),

        textRow('Project Name', '${widget.scModel.name}', ''),

        textRow('Token Standard', '${widget.scModel.org}', ''),

        textRow('Max Supply', '${widget.scModel.maxSupply}', ''),

        SizedBox(height: 1.5.h), 

        line(),

        SizedBox(height: 1.5.h),

        MyText(
          text: 'About ${widget.scModel.name}',
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.left,
          hexaColor: AppColors.primaryColor,
        ),

        const SizedBox(height: 16.0),

        MyText(
          textAlign: TextAlign.start,
          text: '${widget.scModel.description}',
        ),
      ],
    )
    :
    SizedBox(
      height: 60.sp,
      child: OverflowBox(
        minHeight: 60.h,
        maxHeight: 60.h,
        child: Lottie.asset("${AppConfig.animationPath}no-data.json", width: 60.w, height: 60.w, repeat: false),
      )
    );
  }


  Widget assetFromApi() {
    return widget.scModel.marketData!.description != null ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MyText(
          text: 'Token Info',
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.left,
        ),

        const SizedBox(height: 16.0),

        textRow('Token Name', (widget.scModel.marketData!.symbol)!.toUpperCase(), ''),

        textRow('Project Name', '${widget.scModel.marketData!.name}', ''),

        textRow('Max Supply', '${widget.scModel.marketData!.maxSupply}', ''),

        SizedBox(height: 1.5.h),

        line(),

        SizedBox(height: 1.5.h),

        MyText(
          text: 'About ${widget.scModel.marketData!.name}',
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.left,
        ),

        const SizedBox(height: 16.0),

        widget.scModel.marketData!.description == null ?
        MyText(
          textAlign: TextAlign.start,
          text: '${widget.scModel.marketData!.description}',
        )
        :
        MyText(
          textAlign: TextAlign.start,
          text: '${widget.scModel.description}',
        ),
      ],
    )
    :
    SizedBox(
      height: 60.sp,
      child: OverflowBox(
        minHeight: 60.h,
        maxHeight: 60.h,
        child: Lottie.asset("${AppConfig.animationPath}no-data.json", width: 60.w, height: 60.w, repeat: false),
      )
    );
  }

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  LineChartData mainData(List<FlSpot> spots) {
    return LineChartData(
      borderData: FlBorderData(
        show: false,
      ),
      gridData: FlGridData(
        show: true,
        horizontalInterval: 1.6,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            dashArray: const [3, 3],
            color: const Color(0xff37434d).withOpacity(0.2),
            strokeWidth: 2,
          );
        },
        drawVerticalLine: false
      ),
      titlesData: FlTitlesData(
        show: false,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 11),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return 'MAR';
              case 4:
                return 'JUN';
              case 8:
                return 'SEP';
              case 11:
                return 'OCT';
            }
            return '';
          },
          margin: 10,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 25,
          margin: 12,
        ),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: _isLoaded ? [

            const FlSpot(0, 3),
            const FlSpot(2.4, 2),
            const FlSpot(4.4, 3),
            const FlSpot(6.4, 3.1),
            const FlSpot(8, 4),
            const FlSpot(9.5, 4),
            const FlSpot(11, 5),
          ] : spots,
          isCurved: true,
          colors: gradientColors,
          barWidth: 2,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradientFrom: const Offset(0, 0),
            gradientTo: const Offset(0, 1),
            colors: [
              const Color(0xff02d39a).withOpacity(0.1),
              const Color(0xff02d39a).withOpacity(0),
            ]
          ),
        ),
      ],
    );
  }
}
