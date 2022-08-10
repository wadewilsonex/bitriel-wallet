import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/asset_info.dart';
import 'package:wallet_apps/src/screen/home/asset_info/activity_list.dart';
import 'package:wallet_apps/src/screen/home/asset_info/asset_detail.dart';

class AssetInfoBody extends StatelessWidget {

  final AssetInfoModel? assetInfoModel;
  final Function? onTabChange;
  final Function? onPageChange;
  
  AssetInfoBody({
    Key? key, 
    this.assetInfoModel, 
    required this.onTabChange,
    required this.onPageChange
  }) : super(key: key);

  double logoSize = 8.w;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      key: assetInfoModel!.globalKey,
      body: BodyScaffold(
        isSafeArea: true,
        bottom: 0,
        height: MediaQuery.of(context).size.height,
        child: NestedScrollView(
          // floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBox) {
            return [

              SliverAppBar(
                elevation: 0,
                // pinned: true,
                floating: true,
                snap: true,
                forceElevated: innerBox,
                automaticallyImplyLeading: false,
                leading: Container(),
                backgroundColor: isDarkTheme
                  ? assetInfoModel!.bg
                  : Colors.white,
                flexibleSpace: Column(children: [

                  // AppBar
                  Expanded(
                      child: Container(
                        color: hexaCodeToColor(AppColors.bluebgColor),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Icon(
                                      Platform.isAndroid
                                        ? Icons.arrow_back
                                        : Icons.arrow_back_ios,
                                      color: isDarkTheme
                                        ? Colors.white
                                        : Colors.black,
                                      size: 22.5.sp
                                    )
                                  )
                                ),

                                ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: assetInfoModel!.smartContractModel!.logo!.contains('http') 
                                ? Image.network(
                                  assetInfoModel!.smartContractModel!.logo!,
                                  fit: BoxFit.contain,
                                  width: logoSize,
                                  height: logoSize,
                                )
                                : Image.asset(
                                    assetInfoModel!.smartContractModel!.logo!,
                                    fit: BoxFit.contain,
                                    width: logoSize,
                                    height: logoSize,
                                  )
                                ),

                                MyText(
                                  left: 2.w,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkTheme
                                    ? AppColors.whiteHexaColor
                                    : AppColors.blackColor,
                                  text: assetInfoModel!.smartContractModel!.symbol!
                                  // assetInfoModel!.smartContractModel!.id! == null
                                  //     ? assetInfoModel!.smartContractModel!.symbol!
                                  //     : assetInfoModel!.smartContractModel!.id!.toUpperCase(),
                                ),

                                Expanded(child: Container()),

                                // Right Text
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: MyText(
                                    text: ApiProvider().isMainnet ? assetInfoModel!.smartContractModel!.org : assetInfoModel!.smartContractModel!.orgTest,
                                    fontWeight: FontWeight.w700,
                                    color: isDarkTheme
                                      ? AppColors.whiteHexaColor
                                      : AppColors.darkCard,
                                  )
                                ),
                              ],
                            )
                          ),
                      )
                      ),
                ]),
              ),

              // Body
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    Container(
                      color: isDarkTheme
                        ? assetInfoModel!.bg
                        : hexaCodeToColor(AppColors.whiteHexaColor),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          MyText(
                            text: '${assetInfoModel!.smartContractModel!.balance}${' ${assetInfoModel!.smartContractModel!.symbol}'}',
                            //AppColors.secondarytext,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            color: isDarkTheme
                              ? AppColors.whiteColorHexa
                              : AppColors.textColor,
                          ),
                          
                          MyText(
                            top: 8.0,
                            text: "≈ \$ ${assetInfoModel!.smartContractModel!.money!.toStringAsFixed(2)}",
                            // assetInfoModel!.smartContractModel!.balance != AppString.loadingPattern && assetInfoModel!.smartContractModel!.marketPrice != null
                            //   ? '≈ \$$totalUsd'
                            //   : '≈ \$0.00',

                            fontSize: 18,
                            color: isDarkTheme
                              ? AppColors.whiteColorHexa
                              : AppColors.textColor,
                            //fontWeight: FontWeight.bold,
                          ),


                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: _operationRequest(context, assetInfoModel!.smartContractModel!),
                          ),
                            
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [

                          //     const SizedBox(width: 6.0),
                          //     assetInfoModel!.smartContractModel!.change24h != null && assetInfoModel!.smartContractModel!.change24h != ''
                          //     ? MyText(
                          //       text: "≈ \$ ${assetInfoModel!.smartContractModel!.money!.toStringAsFixed(2)}",
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.bold,
                          //       color: double.parse(assetInfoModel!.smartContractModel!.change24h!).isNegative
                          //         ? '#FF0000'
                          //         : isDarkTheme
                          //           ? '#00FF00'
                          //           : '#66CD00',
                          //     )
                          //     : Flexible(
                          //       child: MyText(
                          //         text: assetInfoModel!.smartContractModel!.change24h!,
                          //         fontSize: 16,
                          //         fontWeight: FontWeight.bold,
                          //         color: isDarkTheme
                          //           ? '#00FF00'
                          //           : '#66CD00',
                          //       )
                          //     )
                          //   ],
                          // ),

                        ],
                      ),
                    ),
                    
                    // TabBar
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              onTabChange!(0);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isDarkTheme
                                    ? assetInfoModel!.bg
                                    : hexaCodeToColor(
                                        AppColors.whiteHexaColor),
                                border: Border(
                                  bottom: BorderSide(
                                    color: assetInfoModel!.tabIndex == 0
                                        ? hexaCodeToColor("#D4D6E3")
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: MyText(
                                fontWeight: FontWeight.bold,
                                text: "Activity",
                                color: assetInfoModel!.tabIndex == 0
                                    ? AppColors.whiteColorHexa
                                    : isDarkTheme
                                        ? AppColors.iconColor
                                        : AppColors.textColor,
                              ),
                            ),
                          ),
                        ),
                        
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              onTabChange!(1);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isDarkTheme
                                  ? assetInfoModel!.bg
                                  : hexaCodeToColor(AppColors.whiteHexaColor),
                                border: Border(
                                  bottom: BorderSide(
                                    color: assetInfoModel!.tabIndex == 1
                                      ? hexaCodeToColor("#D4D6E3")
                                      : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: MyText(
                                fontWeight: FontWeight.w600,
                                text: "Details",
                                color: assetInfoModel!.tabIndex == 1
                                    ? AppColors.whiteColorHexa
                                    : AppColors.iconColor
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ];
          },

          body: PageView(
            controller: assetInfoModel!.controller,
            onPageChanged: (index) {
              onPageChange!(index);
            },
            children: <Widget>[
              Consumer<ContractProvider>(builder: (context, value, child) {
                return assetInfoModel!.lsTxInfo == null
                    ? Container(
                        color: isDarkTheme
                          ? assetInfoModel!.bg
                          : hexaCodeToColor(AppColors.whiteHexaColor),
                        child: Center(
                          child: SvgPicture.asset(
                            AppConfig.iconsPath+'no_data.svg',
                            width: 150,
                            height: 150,
                          )
                        ),
                      )
                    : Container(
                      color: isDarkTheme ? hexaCodeToColor(AppColors.darkCard) : hexaCodeToColor(AppColors.whiteColorHexa),
                      child: ActivityList(
                        transactionInfo: assetInfoModel!.lsTxInfo,
                      ),
                    );
              }),

              Container(
                color: isDarkTheme
                  ? assetInfoModel!.bg
                  : hexaCodeToColor(AppColors.whiteHexaColor),
                  child: AssetDetail(assetInfoModel!.smartContractModel!),
                // child: AssetDetail(assetInfoModel!.smartContractModel!.marketData!, assetInfoModel!.smartContractModel!),
              )
              // else if (assetInfoModel!.smartContractModel!.description != "")
              //   Container(
              //     color: isDarkTheme
              //       ? assetInfoModel!.bg
              //       : hexaCodeToColor(AppColors.whiteHexaColor),
              //     child: Center(
              //       child: MyText(text: assetInfoModel!.smartContractModel!.description,)
              //       // SvgPicture.asset(
              //       //   AppConfig.iconsPath+'no_data.svg',
              //       //   width: 150,
              //       //   height: 150,
              //       // ),
              //     ),
              //   )
              // : 
              // Container(
              //   color: isDarkTheme
              //     ? assetInfoModel!.bg
              //     : hexaCodeToColor(AppColors.whiteHexaColor),
              //   child: Center(
              //     child: SvgPicture.asset(
              //       AppConfig.iconsPath+'no_data.svg',
              //       width: 150,
              //       height: 150,
              //     ),
              //   ),
              // ),
              // Container(
              //   color: isDarkTheme
              //       ? hexaCodeToColor(AppColors.darkCard)
              //       : hexaCodeToColor(AppColors.whiteHexaColor),
              //   child: Center(
              //       child: SvgPicture.asset(
              //     'assets/icons/no_data.svg',
              //     width: 150,
              //     height: 150,
              //   )),
              // ),
            ],
          ),
        ),
      ),
      );
  }

  Widget _operationRequest(BuildContext context, SmartContractModel scModel) {
    double width = 30.w;
    double height = 7.h;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        MyGradientButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              MyText(
                text: "Send",
                color: AppColors.whiteColorHexa,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          height: height,
          width: width,
          lsColor: ["#035A8F", "#035A8F"],
          begin: Alignment.bottomRight, 
          end: Alignment.topLeft, 
          action: (){
            Navigator.push(
              context, 
              Transition(child: SubmitTrx("", true, [], scModel: scModel,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
            );
          }
        ),

        SizedBox(width: 10,),
        
        MyGradientButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              MyText(
                text: "Receive",
                color: AppColors.whiteColorHexa,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          height: height,
          width: width,
          lsColor: ["#035A8F", "#035A8F"],
          begin: Alignment.bottomRight, 
          end: Alignment.topLeft, 
          action: (){
            Navigator.push(
              context, 
              Transition(child: ReceiveWallet(assetIndex: assetInfoModel!.index, scModel: assetInfoModel!.smartContractModel,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
            );
          }
        )
      ],
    );
  }
}