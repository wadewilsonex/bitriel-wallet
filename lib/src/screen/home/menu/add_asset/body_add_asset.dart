import 'package:wallet_apps/index.dart';

import '../../receive_wallet/appbar_wallet.dart';

class AddAssetBody extends StatelessWidget {

  final ModelAsset? assetM;
  final String? tokenSymbol;
  final int? initialValue;
  final List<Map<String, dynamic>>? networkSymbol;
  final Function? validateIssuer;
  final Function? popScreen;
  final Function? onChanged;
  final Function? validateField;
  final Function? onSubmit;
  final Function? submitAsset;
  final Function? addAsset;
  final Function? qrRes;
  final Function? onChangeNetwork;

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
    this.onChangeNetwork,
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

                SizedBox(
                  height: 2,
                ),
                
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      GestureDetector(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          await showModalBottomSheet(
                            context: context,
                            isDismissible: true,
                            backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical( 
                                top: Radius.circular(25.0),
                              ),
                            ),
                            builder: (context) => _listNetwork(
                              isValue: true,
                              listNetwork: networkSymbol,
                              initialValue: initialValue,
                              onChanged: (value) {
                                onChangeNetwork!(value);
                              },
                            ),
                          );
        
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            bottom: 8,
                            left: paddingSize,
                            right: paddingSize,
                          ),
                          
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(
                              paddingSize, 0, paddingSize, 0
                            ), 
                            decoration: BoxDecoration(
                              color: isDarkMode
                                ? Colors.white.withOpacity(0.06)
                                : hexaCodeToColor(AppColors.whiteHexaColor),
                              borderRadius: BorderRadius.circular(size5),
                            ),
                            child: Row(
                              children: <Widget>[
                                // provider.sortListContract[scanPayM!.assetValue].logo.toString().contains("http") 
                                // ? Image.network("${provider.sortListContract[scanPayM!.assetValue].logo}", height: 25, width: 25,) 
                                // : Image.asset("${provider.sortListContract[scanPayM!.assetValue].logo}", height: 25, width: 25,),

                                Expanded(
                                  child: MyText(
                                    pTop: paddingSize,
                                    pBottom: paddingSize,
                                    text: "Network",
                                    // text: "${ (ContractService.getConByIndex( context, provider.sortListContract, scanPayM!.assetValue ))['symbol'] }",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    textAlign: TextAlign.left,
                                    hexaColor: isDarkMode
                                      ? AppColors.darkSecondaryText
                                      : AppColors.textColor,
                                  ),
                                ),

                                Row(
                                  children: [
                                    Image.asset("${networkSymbol![initialValue!]["logo"]}", height: 22, width: 22,),

                                    SizedBox(width: 2.5,),

                                    MyText(
                                      text: "${networkSymbol![initialValue!]["symbol"]}",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),

                                    SizedBox(width: 5,),

                                    Icon(Iconsax.arrow_right_3, color: hexaCodeToColor(AppColors.primaryColor),),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Container(
                      //   margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      //   // height: 65,
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //     color: isDarkMode ? Colors.white.withOpacity(0.06) : Colors.white,
                      //     borderRadius: BorderRadius.circular(8.0),
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [

                      //       const MyText(
                      //         left: 16.0,
                      //         text: 'Network',
                      //         fontWeight: FontWeight.bold,
                      //       ),

                      //       Expanded(child: Container()),

                      //       Flexible(
                      //         child:  DropdownList(
                      //           isValue: true,
                      //           // assetInfo: provider.assetInfo,
                      //           listContract: networkSymbol,
                      //           initialValue: initialValue,
                      //           onChanged: (value) {
                      //             onChangeNetwork!(value);
                      //           },
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

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
                            child: Icon(Iconsax.scan, color: hexaCodeToColor(AppColors.primaryColor), size: 20),
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

                // const SizedBox(height: 40.0),

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
      ]
    );
  }

  Widget portFolioItemRow(BuildContext context, bool isDark, String logo, String tokenSymbol, Color color, Function addAsset) {
    return rowDecorationStyle(
      context,
      child: Row(
        children: <Widget>[
          Container(
            height: 9,
            width: 9,
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
                    fontWeight: FontWeight.bold,
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

  Widget rowDecorationStyle(BuildContext context, {Widget? child, double mTop = 0, double mBottom = 16}) {
    return Container(
      margin: EdgeInsets.only(top: mTop, left: 16, right: 16, bottom: 16),
      padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
      decoration: BoxDecoration(
        boxShadow: [shadow(context)],
        color: isDarkMode ? Colors.white.withOpacity(0.06) : Colors.white,
        // hexaCodeToColor(
        //     isDark ? AppColors.darkCard : AppColors.whiteHexaColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child
    );
  }

  Widget _listNetwork(
    {
      final bool? isValue,
      final int? initialValue,
      final Function? onChanged,
      final List<Map<String, dynamic>>? listNetwork,
    }
  ){
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) {
        return Column(
          children: [
            Icon(
              Icons.remove,
              color: Colors.grey[600],
              size: 25,
            ),

            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: listNetwork!.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          onChanged!(index.toString());
                          Navigator.pop(context, listNetwork[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 5),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset("${listNetwork[index]["logo"]}", height: 27, width: 27,)
                              ),
                                          
                              SizedBox(width: 2,),
                                          
                              MyText(text: listNetwork[index]["symbol"], fontSize: 18, fontWeight: FontWeight.bold,),
                                          
                            ],
                          ),
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                        child: Divider(
                          thickness: 0.05,
                          color: hexaCodeToColor(AppColors.darkGrey),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      }
    );
  }

}
