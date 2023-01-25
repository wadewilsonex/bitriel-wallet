import 'package:wallet_apps/index.dart';

import '../../receive_wallet/appbar_wallet.dart';

class AddAssetBody extends StatelessWidget {

  final ModelAsset? assetM;
  final String? tokenSymbol;
  final String? initialValue;
  final List<Map<String, dynamic>>? networkSymbol;
  final Function? validateIssuer;
  final Function? popScreen;
  final Function? onChanged;
  final Function? validateField;
  final Function? onSubmit;
  final Function? submitAsset;
  final Function? addAsset;
  final Function? qrRes;
  final Function? onChangeDropDown;

  const AddAssetBody({
    Key? key, 
    this.assetM,
    this.tokenSymbol,
    this.initialValue,
    this.networkSymbol,
    this.validateIssuer,
    this.popScreen,
    this.onChanged,
    this.validateField,
    this.onSubmit,
    this.submitAsset,
    this.addAsset,
    this.qrRes,
    this.onChangeDropDown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     
    final api = Provider.of<ApiProvider>(context);
    return Column(
      children: [
        Expanded(
          child: BodyScaffold(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [

                // const SizedBox(
                //   height: 20.0,
                // ),
                // SvgPicture.asset(
                //   '${AppConfig.iconsPath}contract.svg',
                //   width: 20.w,
                //   height: 20.h,
                // ),
                
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 8.0.sp),
                        // height: 65,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.white.withOpacity(0.06) : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            MyText(
                              left: 20.sp,
                              text: 'Select Network',
                            ),

                            Expanded(child: Container()),

                            Flexible(
                              child:  QrViewTitle(
                                isValue: true,
                                // assetInfo: provider.assetInfo,
                                listContract: networkSymbol,
                                initialValue: initialValue,
                                onChanged: (value) {
                                  onChangeDropDown!(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      MyInputField(
                        pBottom: 20.sp,
                        hintText: "Token Contract Address",
                        textInputFormatter: [
                          LengthLimitingTextInputFormatter(TextField.noMaxLength)
                        ],
                        controller: assetM!.controllerAssetCode,
                        focusNode: assetM!.nodeAssetCode,
                        validateField: (value) => value.isEmpty
                          ? 'Please fill in token contract address'
                          : null,
                        onChanged: onChanged,
                        onSubmit: onSubmit,
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            final response = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const QrScanner()
                              )
                            );
                            
                            if (response != null) {
                              qrRes!(response.toString());
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Icon(Iconsax.scan, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor), size: 20),
                          ),
                        ),
                      ),

                      if (tokenSymbol == 'KGO')
                        portFolioItemRow(
                          context,
                          isDarkMode,
                          ContractProvider().listContract[api.kgoIndex].logo!,
                          tokenSymbol!,
                          Colors.black,
                          addAsset!,
                        )
                      else if (tokenSymbol != '')
                        portFolioItemRow(
                          context,
                          isDarkMode,
                          assetM!.logo ?? '${AppConfig.assetsPath}circle.png',
                          tokenSymbol!,
                          Colors.white,
                          addAsset!,
                        )
                      else
                        Container(),
                      if (assetM!.loading)
                        const CircularProgressIndicator()
                      else
                        Container(),

                    ],
                  ),
                ),

                const SizedBox(height: 40.0),

                MyGradientButton(
                  edgeMargin: EdgeInsets.only(top: paddingSize, left: paddingSize, right: paddingSize),
                  textButton: "Search",
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: !assetM!.enable ? null : () async {
                    await submitAsset!();
                  }
                ),
              ],
            ),
          ),
        ),
      ]
    );
  }

  Widget portFolioItemRow(BuildContext context, bool isDark, String logo, String tokenSymbol, Color color, Function addAsset) {
    return rowDecorationStyle(
      context,
      child: Row(
        children: <Widget>[
          Container(
            height: 9.w,
            width: 9.w,
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(40)),
            child: logo.contains('http') ? Image.network(logo) : Image.asset(logo),
          ),

          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 20.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: tokenSymbol,
                  ),
                  //MyText(text: org, fontSize: 15),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                addAsset();
              },
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    MyText(
                      width: double.infinity,
                      text: 'Add', //portfolioData[0]["data"]['balance'],
                      hexaColor: AppColors.secondary,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w700
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowDecorationStyle(BuildContext context, {Widget? child, double mTop = 0, double mBottom = 20}) {
    return Container(
      margin: EdgeInsets.only(top: mTop.sp, left: 20.sp, right: 20.sp, bottom: 20.sp),
      padding: EdgeInsets.fromLTRB(15.sp, 9.sp, 15.sp, 9.sp),
      decoration: BoxDecoration(
        boxShadow: [shadow(context)],
        color: isDarkMode ? Colors.white.withOpacity(0.06) : Colors.white,
        // hexaCodeToColor(
        //     isDark ? AppColors.darkCard : AppColors.whiteHexaColor),
        borderRadius: BorderRadius.circular(8.sp),
      ),
      child: child
    );
  }
}
