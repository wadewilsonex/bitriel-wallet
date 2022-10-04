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
    return Column(children: [

      MyAppBar(
        title: "Add Asset",
        onPressed: () async {
          Navigator.pop(context);
          // Timer(const Duration(seconds: 1), () {
          //   // Navigator.pushNamedAndRemoveUntil(context, Home.route, ModalRoute.withName('/'));
          //   Navigator.pushReplacement(context, Transition(child: HomePage(), transitionEffect: TransitionEffect.LEFT_TO_RIGHT,));
          // });
        },
      ),

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
                      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      // height: 65,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          MyText(
                            left: 16.0,
                            text: 'Select Network',
                            hexaColor: isDarkMode
                              ? AppColors.whiteHexaColor
                              : AppColors.darkCard,
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
                      pBottom: 16.0,
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
                          child: const Icon(Iconsax.scan, color: Colors.white, size: 20),
                        ),
                      ),
                    ),

                    // if (tokenSymbol == 'SEL')
                    //   portFolioItemRow(
                    //     context,
                    //     isDarkMode,
                    //     "assets/SelendraCircle-Blue.png",
                    //     tokenSymbol!,
                    //     Colors.black,
                    //     addAsset!,
                    //   )
                    // else 
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
                edgeMargin: const EdgeInsets.only(top: paddingSize, left: paddingSize, right: paddingSize),
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
    ]);
  }

  Widget portFolioItemRow(BuildContext context, bool isDark, String logo, String tokenSymbol, Color color, Function addAsset) {
    return rowDecorationStyle(
      context,
      isDark,
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
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: tokenSymbol,
                    hexaColor: isDark ? "#FFFFFF" : AppColors.darkText,
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

  Widget rowDecorationStyle(BuildContext context, bool isDark, {Widget? child, double mTop = 0, double mBottom = 16}) {
    return Container(
      margin: EdgeInsets.only(top: mTop, left: 16, right: 16, bottom: 16),
      padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
      decoration: BoxDecoration(
        boxShadow: [shadow(context)],
        color: Colors.white.withOpacity(0.06),
        // hexaCodeToColor(
        //     isDark ? AppColors.darkCard : AppColors.whiteHexaColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child
    );
  }
}
