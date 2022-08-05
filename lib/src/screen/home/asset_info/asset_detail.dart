import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../index.dart';

class AssetDetail extends StatefulWidget {
  // final Market marketData;
  final SmartContractModel scModel;
  const AssetDetail(
    // this.marketData, 
    this.scModel
  );

  @override
  _AssetDetailState createState() => _AssetDetailState();
}

class _AssetDetailState extends State<AssetDetail> {
  
  String totalSupply = '';

  String circulatingSupply = '';

  String marketCap = '';

  String marketCapChange24h = '';

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

  @override
  void initState() {
    // print("widget.scModel.marketData!.description: ${widget.scModel.marketData!.description}");
    // print("asset detail market data: ${widget.scModel.marketData!.name}");
    // print("asset detail json: ${widget.scModel.name}");
    // if (widget.marketData.totalSupply != null) {
    //   totalSupply = convert(widget.marketData.totalSupply!);
    // }
    // if (widget.marketData.circulatingSupply != null) {
    //   circulatingSupply = convert(widget.marketData.circulatingSupply!);
    // }

    // if (widget.marketData.marketCap != null) {
    //   marketCap = convert(widget.marketData.marketCap!);
    // }

    // if (widget.marketData.marketCapChange24H != null) {
    //   marketCapChange24h = convert(widget.marketData.marketCapChange24H!);
    // }
    // totalSupply = convert(widget.marketData.totalSupply);
    // circulatingSupply = convert(widget.marketData.circulatingSupply);
    // marketCap = convert(widget.marketData.marketCap);
    // marketCapChange24h = convert(widget.marketData.marketCapChange24H);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            widget.scModel.marketData == null 
            ? assetFromJson()
            : assetFromApi(),

          ],
        )
      ),
    );
  }

  Widget line() {
    final isDarkTheme =
        Provider.of<ThemeProvider>(context, listen: false).isDark;
    return Container(
      height: 1,
      color: isDarkTheme
          ? hexaCodeToColor(AppColors.titleAssetColor)
          : hexaCodeToColor(AppColors.textColor),
    );
  }

  Widget textRow(String leadingText, String trailingText, String endingText) {
    final isDarkTheme =
        Provider.of<ThemeProvider>(context, listen: false).isDark;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(
            text: leadingText,
            color: isDarkTheme ? "#C1C1C1" : AppColors.textColor,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              MyText(
                text: trailingText,
                color: isDarkTheme
                    ? AppColors.whiteColorHexa
                    : AppColors.textColor,
                overflow: TextOverflow.ellipsis,
              ),
              MyText(
                text: endingText,
                color: endingText != '' && endingText.substring(1, 2) == '-'
                    ? '#FF0000'
                    : isDarkTheme
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
        MyText(
          text: 'Token Info',
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.left,
          color: AppColors.whiteColorHexa
        ),

        SizedBox(height: 16.0),

        textRow('Token Name', '${widget.scModel.symbol!.toUpperCase()}', ''),

        textRow('Project Name', '${widget.scModel.name}', ''),

        textRow('Max Supply', '${widget.scModel.maxSupply}', ''),

        line(),

        SizedBox(height: 10.0),

        MyText(
          text: 'About ${widget.scModel.name}',
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.left,
          color: AppColors.whiteColorHexa,
        ),

        SizedBox(height: 16.0),

        MyText(
          textAlign: TextAlign.start,
          text: '${widget.scModel.description}',
          color: AppColors.whiteColorHexa,
        ),
      ],
    )
    :
    SizedBox(
      height: 60.sp,
      child: OverflowBox(
        minHeight: 60.h,
        maxHeight: 60.h,
        child: Lottie.asset(AppConfig.animationPath+"no-data.json", width: 60.w, height: 60.w, repeat: false),
      )
    );
  }


  Widget assetFromApi() {
    return widget.scModel.marketData!.description != null ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: 'Token Info',
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.left,
          color: AppColors.whiteColorHexa
        ),

        SizedBox(height: 16.0),

        textRow('Token Name', '${(widget.scModel.marketData!.symbol)!.toUpperCase()}', ''),

        textRow('Project Name', '${widget.scModel.marketData!.name}', ''),

        textRow('Max Supply', '${widget.scModel.marketData!.maxSupply}', ''),

        line(),

        SizedBox(height: 10.0),

        MyText(
          text: 'About ${widget.scModel.marketData!.name}',
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.left,
          color: AppColors.whiteColorHexa,
        ),

        SizedBox(height: 16.0),

        widget.scModel.marketData!.description == null ?
        MyText(
          textAlign: TextAlign.start,
          text: '${widget.scModel.marketData!.description}',
          color: AppColors.whiteColorHexa,
        )
        :
        MyText(
          textAlign: TextAlign.start,
          text: '${widget.scModel.description}',
          color: AppColors.whiteColorHexa,
        ),
      ],
    )
    :
    SizedBox(
      height: 60.sp,
      child: OverflowBox(
        minHeight: 60.h,
        maxHeight: 60.h,
        child: Lottie.asset(AppConfig.animationPath+"no-data.json", width: 60.w, height: 60.w, repeat: false),
      )
    );
  }
}
