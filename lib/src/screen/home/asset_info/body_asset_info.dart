import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
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

  double logoSize = 15.w;

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

                          // Logo
                          GestureDetector(
                            onTap: assetInfoModel!.smartContractModel!.org != "BEP-20" && assetInfoModel!.smartContractModel!.org != "ERC-20" ? null : () async {
                              print("Index ${assetInfoModel!.index}");
                              final image = ImagePicker();
                              await image.pickImage(source: ImageSource.gallery).then((value) async {
                                print(value!.path);
                                if (value != null){
                                  
                                  Provider.of<ContractProvider>(context, listen: false).listContract.where((element) {
                                    if (element.contract == assetInfoModel!.smartContractModel!.contract){
                                      // element.logo = value.path;
                                      // If found
                                      return true;
                                    }
                                    // Not found
                                    return false;
                                  });
                                }
                              });
                            },
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
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

                                assetInfoModel!.smartContractModel!.org == "BEP-20" || assetInfoModel!.smartContractModel!.org == "ERC-20" ? Positioned(
                                  right: 0,
                                  child: Icon(
                                    Icons.edit, 
                                    size: 18.sp,
                                    color: hexaCodeToColor(
                                      // isDarkTheme
                                      // ? AppColors.greyCode
                                      // : 
                                      AppColors.whiteColorHexa
                                    ),
                                  ),
                                ) : Container()
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          MyText(
                            text: '${assetInfoModel!.smartContractModel!.balance}${' ${assetInfoModel!.smartContractModel!.symbol}'}',
                            //AppColors.secondarytext,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            color: isDarkTheme
                              ? AppColors.whiteColorHexa
                              : AppColors.textColor,
                          ),
                          
                          MyText(
                            top: 8.0,
                            text: "≈ \$ ${assetInfoModel!.smartContractModel!.money!.toStringAsFixed(2)}",
                            color: isDarkTheme
                              ? AppColors.greyCode
                              : AppColors.textColor,
                            //fontWeight: FontWeight.bold,
                          ),

                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: _operationRequest(context, assetInfoModel!.smartContractModel!),
                          ),
                            
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
                            width: 15.w,
                            height: 15.h,
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