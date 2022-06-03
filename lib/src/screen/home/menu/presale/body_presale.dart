import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/appbar_c.dart';
import 'package:wallet_apps/src/models/presale_m.dart';
import 'package:wallet_apps/src/provider/presale_p.dart';
import 'package:wallet_apps/src/screen/home/menu/presale/des_presale.dart';
import 'package:wallet_apps/src/screen/home/menu/presale/presale_list.dart';

class PresaleBody extends StatefulWidget {
  final PresaleModel? model;
  final Function? onRateChange;
  final Function? onChange;
  final Function? submitPresale;

  PresaleBody({
    this.model,
    this.onRateChange,
    this.onChange,
    this.submitPresale,
  });
  @override
  _PresaleBodyState createState() => _PresaleBodyState();
}

class _PresaleBodyState extends State<PresaleBody> {
  String initialValue = 'BNB';

  // PresaleModel model = PresaleModel();

  onChanged(String value) async {
    initialValue = value;
    final presale = Provider.of<PresaleProvider>(context, listen: false);

    for (int i = 0; i < widget.model!.listSupportToken!.length; i++) {
      if (widget.model!.listSupportToken![i]['symbol'] == value) {
        widget.model!.tokenIndex = i;
      }
    }

    if (widget.model!.tokenIndex == 0) {
      final contract = Provider.of<ContractProvider>(context, listen: false);
      // await contract.getBnbBalance();

      widget.model!.balance = double.parse(contract.listContract[4].balance!);
    } else {
      final tokenBalance = await presale.checkTokenBalance(widget .model!.listSupportToken![widget.model!.tokenIndex]['tokenAddress'], context: context);

      widget.model!.balance = tokenBalance;
    }

    if (widget.model!.amountController.text != '') {
      presale.calEstimateSel(
          widget.model!.amountController.text,
          widget.model!.listSupportToken![widget.model!.tokenIndex]['price'],
          widget.model!.rate);
    }
    setState(() {});
  }

  Future<int> discountDialog() async {
    final presale = Provider.of<PresaleProvider>(context, listen: false);
    final res = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return DiscountDialog(widget.model!, widget.model!.rateIndex);
        });

    widget.onRateChange!(res);

    if (widget.model!.amountController.text != '') {
      presale.calEstimateSel(
          widget.model!.amountController.text,
          widget.model!.listSupportToken![widget.model!.tokenIndex]['price'],
          widget.model!.rate);
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    final presale = Provider.of<PresaleProvider>(context, listen: false);
    return BodyScaffold(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          
          MyAppBar(
            tile: TextButton(
              onPressed: () async {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    return PresaleList();
                  }
                );
              },
              child: MyText(
                text: 'Activity',
                right: 20,
                color: isDarkTheme
                  ? AppColors.whiteHexaColor //AppColors.darkCard
                  : AppColors.darkCard,
                fontWeight: FontWeight.w600
              )
            ),
            title: "Presale",
            color: isDarkTheme
              ? hexaCodeToColor(AppColors.darkCard)
              : hexaCodeToColor(AppColors.whiteHexaColor),
            onPressed: () {
              presale.setInitEstSel();
              Navigator.pop(context);
            },
          ),
          // SizedBox(height: 24.0),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MyText(
                    pTop: 24.0,
                    pLeft: 24.0,
                    width: double.infinity,
                    textAlign: TextAlign.left,
                    text: "Network: Binance Smart Chain",
                    color: isDarkTheme
                      ? AppColors.darkSecondaryText
                      : AppColors.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  Container(
                    width: 400,
                    margin: const EdgeInsets.all(24.0),
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: isDarkTheme
                          ? hexaCodeToColor(AppColors.darkCard)
                          : hexaCodeToColor(AppColors.whiteHexaColor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: isDarkTheme
                                ? hexaCodeToColor(AppColors.darkBgd)
                                : hexaCodeToColor(AppColors.lowWhite),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  MyText(
                                    fontSize: 16.0,
                                    textAlign: TextAlign.left,
                                    color: isDarkTheme
                                        ? AppColors.whiteColorHexa
                                        : AppColors.textColor,
                                    fontWeight: FontWeight.w700,
                                    text: widget.model!.balance == null
                                        ? "Balance: Loading..."
                                        : "Balance: ${widget.model!.balance} ",
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      //autofocus: true,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(
                                          TextField.noMaxLength,
                                        ),
                                        FilteringTextInputFormatter(
                                            RegExp(r"^\d+\.?\d{0,8}"),
                                            allow: true)
                                      ],
                                      controller: widget.model!.amountController,
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
                                        border: InputBorder.none,
                                        hintText: 'Input amount',
                                        hintStyle: TextStyle(
                                          fontSize: 18.0,
                                          color: isDarkTheme
                                              ? hexaCodeToColor(
                                                  AppColors.whiteColorHexa)
                                              : hexaCodeToColor(
                                                      AppColors.textColor)
                                                  .withOpacity(0.3),
                                        ),
                                      ),
                                      validator: (value) => value!.isEmpty
                                          ? 'Please fill in amount'
                                          : null,
                                      /* Limit Length Of Text Input */
                                      onChanged: (String? value){
                                        return widget.onChange!(value);
                                      },
                                      // onChanged: (String value) {
                                      //   if (value.isNotEmpty) {
                                      //     setState(() {});
                                      //     _enableBtn = true;
                                      //   } else {
                                      //     setState(() {});
                                      //     _enableBtn = false;
                                      //   }
                                      // },
                                      onFieldSubmitted: (value) {},
                                    ),
                                  ),
                                  _ReuseDropDown(
                                    initialValue: initialValue,
                                    itemsList: widget.model!.listSupportToken!,
                                    onChanged: (value) {
                                      onChanged(value);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25),
                        Icon(Icons.arrow_downward,
                            color: isDarkTheme
                                ? hexaCodeToColor(AppColors.whiteColorHexa)
                                : Colors.black,
                            size: 30),
                        SizedBox(height: 25),
                        Container(
                          height: 100,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: isDarkTheme
                                ? hexaCodeToColor(AppColors.darkBgd)
                                : hexaCodeToColor(AppColors.lowWhite),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  MyText(
                                    textAlign: TextAlign.left,
                                    fontSize: 16.0,
                                    color: isDarkTheme
                                        ? AppColors.whiteColorHexa
                                        : AppColors.textColor,
                                    fontWeight: FontWeight.w700,
                                    text: "To (estimated) ",
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Consumer<PresaleProvider>(
                                      builder: (context, value, child) {
                                    return MyText(
                                        textAlign: TextAlign.left,
                                        color: isDarkTheme
                                            ? AppColors.whiteColorHexa
                                            : AppColors.textColor,
                                        fontWeight: FontWeight.w700,
                                        text:
                                            '${value.estSel.toStringAsFixed(4)}');
                                  }),
                                  Container(
                                    padding: const EdgeInsets.only(right: 34.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            AppConfig.assetsPath+'SelendraCircle-Blue.png',
                                            height: 30,
                                            width: 30),
                                        SizedBox(width: 6.0),
                                        MyText(
                                          top: 4.0,
                                          color: isDarkTheme
                                              ? AppColors.whiteColorHexa
                                              : AppColors.textColor,
                                          fontWeight: FontWeight.w700,
                                          text: "SEL",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(),
                            InkWell(
                              onTap: () async {
                                await discountDialog();
                              },
                              child: Row(
                                children: [
                                  MyText(
                                    textAlign: TextAlign.left,
                                    fontSize: 16.0,
                                    color: isDarkTheme
                                        ? AppColors.whiteColorHexa
                                        : AppColors.textColor,
                                    fontWeight: FontWeight.w700,
                                    text: "Discount ${widget.model!.rate}%",
                                  ),
                                  SizedBox(width: 6.0),
                                  Icon(Icons.settings,
                                      color: isDarkTheme
                                          ? hexaCodeToColor(
                                              AppColors.whiteHexaColor)
                                          : Colors.black),
                                ],
                              ),
                            ),
                          ],
                        ),
                        MyFlatButton(
                          action: !widget.model!.canSubmit
                              ? null
                              : () async {
                                  await widget.submitPresale!();
                                },
                          edgeMargin:
                              const EdgeInsets.only(bottom: 16, top: 42),
                          textButton: 'CONTRIBUTE',
                        ),
                      ],
                    ),
                  ),
                  PresaleDescription(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiscountDialog extends StatefulWidget {
  final PresaleModel model;
  final int initial;
  const DiscountDialog(this.model, this.initial);
  @override
  _DiscountDialogState createState() => new _DiscountDialogState();
}

class _DiscountDialogState extends State<DiscountDialog> {
  int index = 1;

  @override
  void initState() {
    if (widget.initial != 1) {
      index = widget.initial;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Container(
      padding: const EdgeInsets.all(4.0),
      width: MediaQuery.of(context).size.width * 0.8,
      height: 340,
      child: Column(
        children: [
          MyText(
            fontSize: 22.0,
            textAlign: TextAlign.left,
            fontWeight: FontWeight.bold,
            text: "Discount",
          ),
          SizedBox(height: 16.0),
          GestureDetector(
            onTap: () {
              setState(() {
                index = 1;
              });
            },
            child: _customRow(
              ': 1 year vesting lock',
              '10%',
              index == 1
                  ? hexaCodeToColor(AppColors.secondary)
                  : hexaCodeToColor(AppColors.secondary).withOpacity(0),
              index == 1 ? AppColors.whiteColorHexa : AppColors.blackColor,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                index = 2;
              });

              // rateChange(2);
            },
            child: _customRow(
              ': 2 year vesting lock',
              '20%',
              index == 2
                  ? hexaCodeToColor(AppColors.secondary)
                  : hexaCodeToColor(AppColors.secondary).withOpacity(0),
              index == 2 ? AppColors.whiteColorHexa : AppColors.blackColor,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                index = 3;
              });
            },
            child: _customRow(
              ': 3 year vesting lock',
              '30%',
              index == 3
                  ? hexaCodeToColor(AppColors.secondary)
                  : hexaCodeToColor(AppColors.secondary).withOpacity(0),
              index == 3 ? AppColors.whiteColorHexa : AppColors.blackColor,
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      hexaCodeToColor(AppColors.secondary)),
                ),
                onPressed: () {
                  Navigator.pop(context, index);
                },
                child: Text('CLOSE'),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  _customRow(
      String trailingText, String btnText, Color cardColor, String textColor) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Card(
            color: cardColor,
            margin: EdgeInsets.zero,
            child: Container(
                height: 40,
                width: 130,
                alignment: Alignment.center,
                child: MyText(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    text: btnText)),
          ),
          MyText(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              //     : AppColors.greyCode,
              text: trailingText)
        ],
      ),
    );
  }
}

class _ReuseDropDown extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final Widget? icon;
  final String? initialValue;
  final TextStyle? style;
  final List<Map<String, dynamic>>? itemsList;

  const _ReuseDropDown(
      {this.onChanged,
      this.initialValue,
      this.icon,
      this.style,
      this.itemsList});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

    return Theme(
      data: ThemeData(
          canvasColor: hexaCodeToColor(
              isDarkTheme ? AppColors.darkCard : AppColors.whiteColorHexa)),
      child: DropdownButton(
        value: initialValue,
        underline: Container(
          color: Colors.blue,
        ),
        style: style,
        icon: icon,
        onChanged: (String? value){
          onChanged!(value!);
        },
        items: itemsList!.map<DropdownMenuItem<String>>((Map<String, dynamic> e) {
          return DropdownMenuItem<String>(
            value: "${e['symbol']}",
            child: Row(
              children: [
                Image.asset(
                  "${e['logo']}",
                  height: 30,
                  width: 30,
                ),
                SizedBox(width: 6.0),
                Text(
                  "${e['symbol']}",
                  style: TextStyle(
                    color: isDarkTheme
                        ? hexaCodeToColor(AppColors.darkSecondaryText)
                        : hexaCodeToColor(AppColors.textColor),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
