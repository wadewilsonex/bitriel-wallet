import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/appbar_c.dart';
import 'package:wallet_apps/src/components/component.dart';
import 'package:wallet_apps/src/models/presale_m.dart';
import 'package:wallet_apps/src/screen/home/menu/presale/des_presale.dart';

class BodyPresale extends StatelessWidget {
  final PresaleModel? model;
  final Function? onChanged;
  final Function? onChangedDropDown;
  final Function? rateChange;
  final Function? submitPresale;

  BodyPresale(
    { this.model,
      this.onChanged,
      this.onChangedDropDown,
      this.rateChange,
      this.submitPresale});

  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    final contract = Provider.of<ContractProvider>(context);

    return BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Column(
              children: [
                MyAppBar(
                  title: "Presale",
                  color: isDarkTheme
                      ? hexaCodeToColor(AppColors.darkCard)
                      : hexaCodeToColor(AppColors.whiteHexaColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 16.0),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MyText(
                        width: double.infinity,
                        text: "Contribute:",
                        // contract.listContract[0].balance == null
                        //     ? 'Available Balance:  ${AppString.loadingPattern} SEL v1'
                        //     : 'Available Balance:  ${contract.listContract[0].balance} SEL v1',
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme
                            ? AppColors.darkSecondaryText
                            : AppColors.textColor,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        bottom: 20.0,
                        top: 16.0,
                        left: 16.0,
                      ),

                      MyText(
                        width: double.infinity,
                        text:
                            "1 year vesting: 10% discount \n2 year vesting: 20% discount \n3 year vesting: 30% discount:",
                        // contract.listContract[0].balance == null
                        //     ? 'Available Balance:  ${AppString.loadingPattern} SEL v1'
                        //     : 'Available Balance:  ${contract.listContract[0].balance} SEL v1',
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme
                            ? AppColors.darkSecondaryText
                            : AppColors.textColor,
                        textAlign: TextAlign.left,
                        bottom: 20.0,
                        left: 16.0,
                        right: 16.0,
                      ),

                      Container(
                          // width: double.infinity,
                          margin: const EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 42),
                          height: 60,
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                    onTap: () {
                                      rateChange!(1);
                                    },
                                    child: Card(
                                      color: model!.rateIndex == 1
                                          ? hexaCodeToColor(AppColors.secondary)
                                          : hexaCodeToColor(AppColors.secondary)
                                              .withOpacity(0),
                                      margin: EdgeInsets.zero,
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: MyText(
                                              fontWeight: FontWeight.bold,
                                              color: model!.rateIndex == 1
                                                  ? AppColors.whiteColorHexa
                                                  : AppColors.greyCode,
                                              text: "10%")),
                                    )),
                              ),
                              Expanded(
                                  child: InkWell(
                                      onTap: () {
                                        rateChange!(2);
                                      },
                                      child: Card(
                                        color: model!.rateIndex == 2
                                            ? hexaCodeToColor(
                                                AppColors.secondary)
                                            : hexaCodeToColor(
                                                    AppColors.secondary)
                                                .withOpacity(0),
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: MyText(
                                                fontWeight: FontWeight.bold,
                                                color: model!.rateIndex == 2
                                                    ? AppColors.whiteColorHexa
                                                    : AppColors.blackColor,
                                                text: "20%")),
                                      ))),
                              Expanded(
                                  child: InkWell(
                                      onTap: () {
                                        rateChange!(3);
                                      },
                                      child: Card(
                                        color: model!.rateIndex == 3
                                            ? hexaCodeToColor(
                                                AppColors.secondary)
                                            : hexaCodeToColor(
                                                    AppColors.secondary)
                                                .withOpacity(0),
                                        margin: EdgeInsets.zero,
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: MyText(
                                                color: model!.rateIndex == 3
                                                    ? AppColors.whiteColorHexa
                                                    : AppColors.blackColor,
                                                fontWeight: FontWeight.bold,
                                                text: "30%")),
                                      )))
                            ],
                          )),

                      // Presale Contents
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            color: isDarkTheme
                                ? hexaCodeToColor(AppColors.darkCard)
                                : hexaCodeToColor(AppColors.whiteHexaColor),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [shadow(context)]),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                    top: 16.0,
                                    bottom: 16.0),
                                alignment: Alignment.centerLeft,
                                child: MyText(
                                    textAlign: TextAlign.left,
                                    color: AppColors.greyCode,
                                    fontWeight: FontWeight.w700,
                                    text: "Balance: ${contract.listContract[ApiProvider().bnbIndex].balance}"),
                              ),

                              // Field Amount And Token Symbol
                              Container(
                                // height: 150,
                                width: double.infinity,
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: isDarkTheme
                                      ? hexaCodeToColor(AppColors.darkBgd)
                                      : hexaCodeToColor(
                                          AppColors.whiteColorHexa),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Form(
                                  key: model!.presaleKey,
                                  child: TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(
                                        TextField.noMaxLength,
                                      ),
                                      FilteringTextInputFormatter(
                                          RegExp(r"^\d+\.?\d{0,8}"),
                                          allow: true)
                                    ],
                                    controller: model!.amountController,
                                    keyboardType: Platform.isAndroid
                                        ? TextInputType.number
                                        : TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    style: TextStyle(
                                        color: isDarkTheme
                                            ? hexaCodeToColor(
                                                AppColors.whiteColorHexa)
                                            : hexaCodeToColor(
                                                AppColors.textColor),
                                        fontSize: 18.0),
                                    decoration: InputDecoration(
                                      prefixIconConstraints: BoxConstraints(
                                        minWidth: 0,
                                        minHeight: 0,
                                      ),
                                      border: InputBorder.none,
                                      hintText: 'Input balance',
                                      hintStyle: TextStyle(
                                        fontSize: 20.0,
                                        color: isDarkTheme
                                            ? hexaCodeToColor(
                                                AppColors.darkSecondaryText)
                                            : hexaCodeToColor(
                                                    AppColors.textColor)
                                                .withOpacity(0.3),
                                      ),
                                      // contentPadding:
                                    ),
                                    validator: (value) => value!.isEmpty
                                        ? 'Please fill in amount'
                                        : null,
                                    /* Limit Length Of Text Input */
                                    onChanged: (String? value){
                                      return onChanged!(value);
                                    },
                                    onFieldSubmitted: (value) {},
                                  ),
                                ),
                              ),

                              Divider(),

                              Row(children: [
                                Expanded(
                                  child: MyText(
                                      left: 16,
                                      text:
                                          "Price: ${model!.listSupportToken![model!.tokenIndex]['price'] ?? ''}",
                                      color: AppColors.blackColor,
                                      textAlign: TextAlign.left,
                                      fontWeight: FontWeight.bold),
                                ),
                                Flexible(
                                    flex: 0,
                                    child: Theme(
                                        data: ThemeData(
                                            canvasColor: hexaCodeToColor(
                                                isDarkTheme
                                                    ? AppColors.darkCard
                                                    : AppColors
                                                        .whiteColorHexa)),
                                        child: Container(
                                            margin: EdgeInsets.only(right: 16),
                                            child: DropdownButton(
                                              underline: Container(),
                                              value: model!.symbol,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: isDarkTheme
                                                    ? hexaCodeToColor(AppColors
                                                        .darkSecondaryText)
                                                    : hexaCodeToColor(
                                                        AppColors.textColor),
                                              ),
                                              items: model!.listSupportToken!.map<
                                                      DropdownMenuItem<String>>(
                                                  (e) {
                                                return DropdownMenuItem(
                                                    value: "${e['symbol']}",
                                                    child:
                                                        Text("${e['symbol']}"));
                                              }).toList(),
                                              onChanged: (String? value) {
                                                onChangedDropDown!(value);
                                              },
                                            ))))
                              ]),

                              Container(
                                  padding: EdgeInsets.only(
                                      left: 16, right: 16, top: 10, bottom: 10),
                                  child: Row(children: [
                                    MyText(
                                        text: "Discount Rate:",
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.bold),
                                    Expanded(child: Container()),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: MyText(
                                            color: AppColors.blackColor,
                                            text: "${model!.rate}%"))
                                  ])),
                            ],
                          ),
                        ),
                      ),

                      // Presale Button
                      MyFlatButton(
                          edgeMargin: const EdgeInsets.only(
                              bottom: 16, top: 42, left: 32, right: 32),
                          textButton: 'CONTRIBUTE',
                          action: () async {
                            await submitPresale!();
                          }
                          // submitPresale
                          // !model.enableBtn
                          //   ? null
                          //   : () async {
                          //   if (model.presaleKey.currentState.validate()) {
                          //     FocusScopeNode currentFocus =
                          //         FocusScope.of(context);

                          //     if (!currentFocus.hasPrimaryFocus) {
                          //       currentFocus.unfocus();
                          //     }

                          //     validatePresale();
                          //   }
                          // },
                          ),
                      PresaleDescription(),
                    ],
                  ),
                )),
                PresaleDescription(),
              ],
            ),

            // if (_success == false)
            //   Container()
            // else
            //   BackdropFilter(
            //     // Fill Blur Background
            //     filter: ImageFilter.blur(
            //       sigmaX: 5.0,
            //       sigmaY: 5.0,
            //     ),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: <Widget>[
            //         Expanded(
            //           child: CustomAnimation.flareAnimation(
            //             flareController,
            //             "assets/animation/check.flr",
            //             "Checkmark",
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
          ],
        ));
  }
}
