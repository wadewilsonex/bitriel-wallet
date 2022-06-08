import 'dart:ui';

import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/appbar_c.dart';
import 'package:wallet_apps/src/models/swap_m.dart';

class SwapBody extends StatelessWidget{

  final SwapModel? swapModel;
  final Function? onChanged;
  final Function? validateSwap;
  final Function? fetchMax;

  SwapBody({this.swapModel, this.onChanged, this.validateSwap, this.fetchMax});

  Widget build(BuildContext context){
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    final contract = Provider.of<ContractProvider>(context, listen: false);
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [

            Column(
              children: [

                MyAppBar(
                  title: "Swap SEL v2",
                  color: isDarkTheme
                    ? hexaCodeToColor(AppColors.darkCard)
                    : hexaCodeToColor(AppColors.whiteHexaColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                

                Column(
                  children: [
                    MyText(
                      width: double.infinity,
                      text: contract.listContract[1].balance == null
                        ? 'Available Balance:  ${AppString.loadingPattern} SEL v1'
                        : 'Available Balance:  ${contract.listContract[ApiProvider().selV1Index].balance} SEL v1',
                      fontWeight: FontWeight.bold,
                      color: isDarkTheme
                        ? AppColors.darkSecondaryText
                        : AppColors.textColor,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      bottom: 20.0,
                      top: 16.0,
                      left: 16,
                    ),

                    // Swap Contents
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: paddingSize),
                      padding: const EdgeInsets.symmetric(vertical: paddingSize),
                      decoration: BoxDecoration(
                        color: isDarkTheme
                          ? Colors.white.withOpacity(0.06)
                          : hexaCodeToColor(AppColors.whiteHexaColor),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [shadow(context)]
                      ),
                      child: Column(
                        children: [

                          MyText(
                            left: 16,
                            width: double.infinity,
                            text: 'Amount',
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme
                              ? AppColors.darkSecondaryText
                              : AppColors.textColor,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            bottom: 1.5.h,
                          ),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(left: 10),
                            margin: const EdgeInsets.symmetric(horizontal: paddingSize),
                            decoration: BoxDecoration(
                              color: isDarkTheme
                                ? hexaCodeToColor(AppColors.darkBgd)
                                : hexaCodeToColor(AppColors.whiteColorHexa),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(TextField.noMaxLength),
                                      FilteringTextInputFormatter(RegExp(r"^\d+\.?\d{0,8}"), allow: true)
                                    ],
                                    controller: swapModel!.amountController,
                                    keyboardType: Platform.isAndroid
                                      ? TextInputType.number
                                      : TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    style: TextStyle(
                                      color: isDarkTheme
                                        ? hexaCodeToColor(AppColors.whiteColorHexa)
                                        : hexaCodeToColor(AppColors.textColor),
                                      fontSize: 15.sp
                                    ),
                                    decoration: InputDecoration(
                                      
                                      prefixIconConstraints: BoxConstraints(
                                        minWidth: 0,
                                        minHeight: 0,
                                      ),
                                      border: InputBorder.none,
                                      hintText: '0.00',
                                      hintStyle: TextStyle(
                                        fontSize: 15.sp,
                                        color: isDarkTheme
                                          ? hexaCodeToColor(AppColors.darkSecondaryText)
                                          : hexaCodeToColor(AppColors.textColor).withOpacity(0.3),
                                      ),
                                    ),
                                    validator: (value) => value!.isEmpty
                                      ? 'Please fill in amount'
                                      : null,
                                    /* Limit Length Of Text Input */
                                    onChanged: (String value) {
                                      onChanged!(value);
                                    },
                                    onFieldSubmitted: (value) {},
                                  )
                                ),

                                TextButton(
                                  onPressed: () async {
                                    await fetchMax!(context);
                                  },
                                  child: MyText(
                                    text: 'Max',
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondarytext,
                                  ),
                                )
                              ]
                            ),
                          ),

                          // Swap Button
                          MyGradientButton(
                            edgeMargin: EdgeInsets.only(top: paddingSize, left: paddingSize, right: paddingSize),
                            textButton: "Swap",
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            action: !swapModel!.enableBtn
                              ? null
                              : () async {
                                
                              FocusScopeNode currentFocus = FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }

                              validateSwap!();
                            }
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SwapDescription(),
                ),
              ],
            ),
            if (swapModel!.success == false)
              Container()
            else
              BackdropFilter(
                // Fill Blur Background
                filter: ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: CustomAnimation.flareAnimation(
                        swapModel!.flareController!,
                        AppConfig.animationPath+"check.flr",
                        "Checkmark",
                      ),
                    ),
                  ],
                ),
              ),
          ],
        )
      ),
    );
  }
}