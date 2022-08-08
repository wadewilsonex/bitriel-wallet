import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
// import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_apps/src/components/component.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/tx_history.dart';
import 'package:wallet_apps/src/screen/home/asset_info/activity_list.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import '../../../../index.dart';
import 'asset_detail.dart';

class AssetInfo extends StatefulWidget {
  final int? index;
  final SmartContractModel? scModel;
  final List<TransactionInfo>? transactionInfo;
  final bool? showActivity;

  const AssetInfo({
    @required this.index,
    @required this.scModel,
    this.transactionInfo,
    this.showActivity
  });

  @override
  _AssetInfoState createState() => _AssetInfoState();
}

class _AssetInfoState extends State<AssetInfo> {
  
  PageController controller = PageController();
  String totalUsd = '';

  int _tabIndex = 0;

  double logoSize = 8.w;

  GlobalKey<ScaffoldState>? _globalKey;

  String onSubmit(String value) {
    return value;
  }

  void onPageChange(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  void onTabChange(int tabIndex) {
    controller.animateToPage(
      tabIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {

    _globalKey = GlobalKey<ScaffoldState>();

    if (widget.showActivity != null) {
      _tabIndex = 1;
      controller = PageController(initialPage: 1);
    }
    AppServices.noInternetConnection(context: context);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Color bg = Colors.white.withOpacity(0.06);

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      key: _globalKey,
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
                  ? bg
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
                                child: widget.scModel!.logo!.contains('http') 
                                ? Image.network(
                                  widget.scModel!.logo!,
                                  fit: BoxFit.contain,
                                  width: logoSize,
                                  height: logoSize,
                                )
                                : Image.asset(
                                    widget.scModel!.logo!,
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
                                  text: widget.scModel!.symbol!
                                  // widget.scModel!.id! == null
                                  //     ? widget.scModel!.symbol!
                                  //     : widget.scModel!.id!.toUpperCase(),
                                ),

                                Expanded(child: Container()),

                                // Right Text
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: MyText(
                                    text: ApiProvider().isMainnet ? widget.scModel!.org : widget.scModel!.orgTest,
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
                        ? bg
                        : hexaCodeToColor(AppColors.whiteHexaColor),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          MyText(
                            text: '${widget.scModel!.balance}${' ${widget.scModel!.symbol}'}',
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
                            text: "≈ \$ ${widget.scModel!.money!.toStringAsFixed(2)}",
                            // widget.scModel!.balance != AppString.loadingPattern && widget.scModel!.marketPrice != null
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
                            child: _operationRequest(context, widget.scModel!),
                          ),
                            
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [

                          //     const SizedBox(width: 6.0),
                          //     widget.scModel!.change24h != null && widget.scModel!.change24h != ''
                          //     ? MyText(
                          //       text: "≈ \$ ${widget.scModel!.money!.toStringAsFixed(2)}",
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.bold,
                          //       color: double.parse(widget.scModel!.change24h!).isNegative
                          //         ? '#FF0000'
                          //         : isDarkTheme
                          //           ? '#00FF00'
                          //           : '#66CD00',
                          //     )
                          //     : Flexible(
                          //       child: MyText(
                          //         text: widget.scModel!.change24h!,
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
                              onTabChange(0);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isDarkTheme
                                    ? bg
                                    : hexaCodeToColor(
                                        AppColors.whiteHexaColor),
                                border: Border(
                                  bottom: BorderSide(
                                    color: _tabIndex == 0
                                        ? hexaCodeToColor("#D4D6E3")
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: MyText(
                                fontWeight: FontWeight.bold,
                                text: "Activity",
                                color: _tabIndex == 0
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
                              onTabChange(1);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isDarkTheme
                                  ? bg
                                  : hexaCodeToColor(AppColors.whiteHexaColor),
                                border: Border(
                                  bottom: BorderSide(
                                    color: _tabIndex == 1
                                      ? hexaCodeToColor("#D4D6E3")
                                      : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: MyText(
                                fontWeight: FontWeight.w600,
                                text: "Details",
                                color: _tabIndex == 1
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
            controller: controller,
            onPageChanged: (index) {
              onPageChange(index);
            },
            children: <Widget>[
              Consumer<ContractProvider>(builder: (context, value, child) {
                return widget.transactionInfo == null
                    ? Container(
                        color: isDarkTheme
                          ? bg
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
                        transactionInfo: widget.transactionInfo,
                      ),
                    );
              }),

              Container(
                color: isDarkTheme
                  ? bg
                  : hexaCodeToColor(AppColors.whiteHexaColor),
                  child: AssetDetail(widget.scModel!),
                // child: AssetDetail(widget.scModel!.marketData!, widget.scModel!),
              )
              // else if (widget.scModel!.description != "")
              //   Container(
              //     color: isDarkTheme
              //       ? bg
              //       : hexaCodeToColor(AppColors.whiteHexaColor),
              //     child: Center(
              //       child: MyText(text: widget.scModel!.description,)
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
              //     ? bg
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
              Transition(child: ReceiveWallet(assetIndex: widget.index, scModel: widget.scModel,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
            );
          }
        )
      ],
    );
  }
}
