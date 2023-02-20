import 'package:animate_do/animate_do.dart';
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            if (widget.scModel.chart == null)
            const CircularProgressIndicator()
            
            else if (widget.scModel.chart!.isNotEmpty)
            FadeInUp(
              duration: const Duration(milliseconds: 500),
              child: chartAsset(
                widget.scModel.logo!.contains('http')
                ? Image.network(
                  widget.scModel.logo!,
                  fit: BoxFit.contain,
                )
                : Image.asset(
                  widget.scModel.logo!,
                  fit: BoxFit.contain,
                ),
                widget.scModel.name!,
                widget.scModel.symbol!,
                'USD',
                widget.scModel.marketPrice!,
                widget.scModel.chart!,
              ),
            ),
            // else Container(),

            SizedBox(height: 2.h),
            
            widget.scModel.marketData == null
            ? FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: assetFromJson()
            )
            :
            FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: assetFromApi()
            ),

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
    if (widget.scModel.description != null) {
      return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                MyText(
                  text: "Market cap",
                  hexaColor: AppColors.greyCode,
                ),

                MyText(
                  text: "null",
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ],
            ),

            const Spacer(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                MyText(
                  text: "Circulation supply",
                  hexaColor: AppColors.greyCode,
                ),
                MyText(
                  text: "null",
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 2.h,),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                MyText(
                  text: "Total volume",
                  hexaColor: AppColors.greyCode,
                ),
                MyText(
                  text: "null",
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ],
            ),

            const Spacer(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                MyText(
                  text: "Total supply",
                  hexaColor: AppColors.greyCode,
                ),
                MyText(
                  text: "null",
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ],
            ),

          ],
        ),

        SizedBox(height: 1.5.h),

        line(),

        SizedBox(height: 1.5.h),

        const MyText(
          text: 'Description',
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.left,
        ),

        SizedBox(height: 1.5.h),


        MyText(
          textAlign: TextAlign.start,
          text: '${widget.scModel.description}',
          hexaColor: AppColors.greyCode,
          fontSize: 18,
        ),
      ],
    );
    } else {
      return SizedBox(
      height: 60.sp,
      child: OverflowBox(
        minHeight: 60.h,
        maxHeight: 60.h,
        child: Lottie.asset("${AppConfig.animationPath}no-data.json", width: 60.w, height: 60.w, repeat: false),
      )
    );
    }
  }


  Widget assetFromApi() {
    return widget.scModel.marketData!.description != null ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MyText(
                  text: "Market cap",
                  hexaColor: AppColors.greyCode,
                ),
                MyText(
                  text: "\$${convert("${widget.scModel.marketData!.marketCap}")}",
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ],
            ),

            const Spacer(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const MyText(
                  text: "Circulation supply",
                  hexaColor: AppColors.greyCode,
                ),
                MyText(
                  text: "${convert("${widget.scModel.marketData!.circulatingSupply}")} ${widget.scModel.marketData!.symbol!.toUpperCase()} ",
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 2.h,),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MyText(
                  text: "Total volume",
                  hexaColor: AppColors.greyCode,
                ),
                MyText(
                  text: "\$${convert("${widget.scModel.marketData!.totalVolume}")}",
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ],
            ),

            const Spacer(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const MyText(
                  text: "Total supply",
                  hexaColor: AppColors.greyCode,
                  fontSize: 18,
                ),
                MyText(
                  text: "${convert("${widget.scModel.marketData!.totalSupply}")} ${widget.scModel.marketData!.symbol!.toUpperCase()} ",
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),

          ],
        ),

        SizedBox(height: 1.5.h),

        line(),

        SizedBox(height: 1.5.h),

        const MyText(
          text: 'Description',
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.left,
        ),

        SizedBox(height: 1.5.h),

        widget.scModel.marketData!.description == null ?
        MyText(
          textAlign: TextAlign.start,
          text: '${widget.scModel.marketData!.description}',
          hexaColor: AppColors.greyColor,
          fontSize: 18,
        )
        :
        MyText(
          textAlign: TextAlign.start,
          text: '${widget.scModel.description}',
          hexaColor: AppColors.greyCode,
          fontSize: 18,
        ),
      ],
    )
    :
    Container();
  }

}
