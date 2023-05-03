import 'package:wallet_apps/index.dart';

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
  final Function? onChangedQuery;
  final Function? setResults;
  final Function? onTapGetResult;
  final Function? onTapGetContractData;
  final List<dynamic>? getContractData;
  final String? queryContractAddress;
  final List<dynamic>? searchResultsData;

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
    this.onChangedQuery,
    this.setResults,
    this.onTapGetResult,
    this.onTapGetContractData,
    this.getContractData,
    this.queryContractAddress,
    this.searchResultsData
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        Expanded(
          child: BodyScaffold(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [

                SizedBox(
                  height: 2.h,
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
                                assetM!.controllerAssetCode.clear();
                                
                                onChangeNetwork!(value);

                                onChangedQuery!(value);
                                
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
                                Expanded(
                                  child: MyText(
                                    pTop: paddingSize,
                                    pBottom: paddingSize,
                                    text: "Network",
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
                                    Image.file(File("${networkSymbol![initialValue!]["logo"]}"), height: 22.sp, width: 22.sp,),

                                    SizedBox(width: 2.5.w,),

                                    MyText(
                                      text: "${networkSymbol![initialValue!]["symbol"]}",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),

                                    SizedBox(width: 5.w,),

                                    Icon(Iconsax.arrow_right_3, color: hexaCodeToColor(AppColors.primaryColor),),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      Stack(
                        children: [
                          Column(
                            children: [
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
                                onChanged: (v) {
                                  onChangedQuery!(v);
                                },
                                onSubmit: onSubmit,
                                
                                suffixIcon: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    assetM!.controllerAssetCode.value.text.isNotEmpty ? GestureDetector(
                                      onTap: () async {
                                        assetM!.controllerAssetCode.clear();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(right: 16.0),
                                        child: Icon(Iconsax.close_circle, color: hexaCodeToColor(AppColors.iconGreyColor)),
                                      ),
                                    )
                                    : Container(),

                                    GestureDetector(
                                      onTap: () async {
                                        final response = await Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const QrScanner(isShowSendFund: false, isShowWC: false)
                                          )
                                        );
                                        
                                        if (response != null) {
                                          qrRes!(response.toString());
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(right: 16.0),
                                        child: Icon(Iconsax.scan, color: hexaCodeToColor(AppColors.primaryColor)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: paddingSize),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.white,
                                ),
                                
                                child: queryContractAddress!.isEmpty
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: getContractData!.length < 6 ? getContractData!.length : 6,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            leading: CircleAvatar(
                                              maxRadius: 25,
                                              backgroundColor: Colors.grey,
                                              child: MyText(text: initialValue == 0 ? "BEP20" : "ERC20", fontSize: 14,),
                                            ),
                                            title: MyText(
                                              text: "${getContractData![index]['name']} (${getContractData![index]['symbol']})",
                                              textAlign: TextAlign.start,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            subtitle: MyText(
                                              text: initialValue == 0 ? 
                                              getContractData![index]['platforms']["binance_smart_chain"].replaceRange(10, getContractData![index]['platforms']["binance_smart_chain"].length - 10, "........") 
                                              : getContractData![index]['platforms']["ethereum"].replaceRange(10, getContractData![index]['platforms']["ethereum"].length - 10, "........"),
                                              textAlign: TextAlign.start,
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            onTap: () {
                                              onTapGetContractData!(index);
                                            },
                                          );
                                        },
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: searchResultsData!.length < 6 ? searchResultsData!.length : 6,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            leading: CircleAvatar(
                                              maxRadius: 25,
                                              backgroundColor: Colors.grey,
                                              child: MyText(text: initialValue == 0 ? "BEP20" : "ERC20", fontSize: 14,),
                                            ),
                                            title: MyText(
                                              text: "${searchResultsData![index]['name']} (${searchResultsData![index]['symbol']})",
                                              textAlign: TextAlign.start,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            subtitle: MyText(
                                              text: 
                                              initialValue == 0 ? 
                                              searchResultsData![index]['platforms']["binance_smart_chain"].replaceRange(10, searchResultsData![index]['platforms']["binance_smart_chain"].length - 10, "........") 
                                              : searchResultsData![index]['platforms']["ethereum"].replaceRange(10, searchResultsData![index]['platforms']["ethereum"].length - 10, "........"),
                                              textAlign: TextAlign.start,
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            onTap: () {
                                              onTapGetResult!(index);
                                            },
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // if (tokenSymbol == 'KGO')
                      //   portFolioItemRow(
                      //     context,
                      //     isDarkMode,
                      //     ContractProvider().listContract[api.kgoIndex].logo!,
                      //     tokenSymbol!,
                      //     Colors.black,
                      //     addAsset!,
                      //   )
                      // else if (tokenSymbol != '')
                      //   portFolioItemRow(
                      //     context,
                      //     isDarkMode,
                      //     assetM!.logo ?? '${AppConfig.assetsPath}circle.png',
                      //     tokenSymbol!,
                      //     Colors.white,
                      //     addAsset!,
                      //   )
                      // else
                      //   Container(),
                      // if (assetM!.loading)
                      //   const CircularProgressIndicator()
                      // else
                      //   Container(),

                    ],
                  ),
                ),

                MyGradientButton(
                  edgeMargin: const EdgeInsets.only(top: paddingSize, left: paddingSize, right: paddingSize),
                  textButton: "Add",
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: () async {
                    // addAsset!();
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
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: tokenSymbol,
                    fontWeight: FontWeight.bold,
                  ),
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
                      text: 'Add',
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
              size: 25.sp,
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
                                child: Image.file(File("${listNetwork[index]["logo"]}"), height: 27.sp, width: 27.sp,)
                              ),
                                          
                              SizedBox(width: 2.w,),
                                          
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
