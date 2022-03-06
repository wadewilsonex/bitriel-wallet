import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/reuse_dropdown.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/service/contract.dart';

class SubmitTrxBody extends StatelessWidget {
  final bool? enableInput;
  final ModelScanPay? scanPayM;
  final Function? onSubmit;
  final Function? clickSend;
  final Function? validateSubmit;
  final Function? onChanged;
  final String Function(String)? validateField;
  final Function(String)? onChangeDropDown;

  final PopupMenuItem Function(Map<String, dynamic>)? item;
  final Function? pasteText;

  const SubmitTrxBody({
    this.pasteText,
    this.enableInput,
    this.scanPayM,
    this.onChanged,
    this.validateField,
    this.onSubmit,
    this.clickSend,
    this.validateSubmit,
    this.onChangeDropDown,
    this.item
  });

  @override
  Widget build(BuildContext context) {
    final List<MyInputField> listInput = [
      MyInputField(
        pBottom: 16,
        labelText: "Receiver address",
        textInputFormatter: [
          LengthLimitingTextInputFormatter(TextField.noMaxLength),
        ],
        controller: scanPayM!.controlReceiverAddress,
        focusNode: scanPayM!.nodeReceiverAddress,
        validateField: (value) => value == null ? 'Please fill in receiver address' : null,
        onChanged: onChanged,
        onSubmit: () {}
      ),
      MyInputField(
        pBottom: 16,
        labelText: "Amount",
        textInputFormatter: [
          LengthLimitingTextInputFormatter(
            TextField.noMaxLength,
          ),
          FilteringTextInputFormatter(RegExp(r"^\d+\.?\d{0,8}"), allow: true)
        ],
        inputType: Platform.isAndroid ? TextInputType.number : TextInputType.text,
        controller: scanPayM!.controlAmount,
        focusNode: scanPayM!.nodeAmount,
        validateField: validateField,
        onChanged: onChanged,
        onSubmit: () async {
          await validateSubmit!();
        }
      ),
    ];

    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

    final contract = Provider.of<ContractProvider>(context);

    return Column(
      children: [
        MyAppBar(
          title: "Send wallet",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Expanded(
          child: Center(
            child: BodyScaffold(
              child: Form(
                key: scanPayM!.formStateKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    listInput[0],
                    
                    /* Type of payment */
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 16.0,
                        left: 16,
                        right: 16,
                      ),

                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 11.0,
                          bottom: 11.0,
                          left: 26.0,
                          right: 14.0,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkTheme
                            ? hexaCodeToColor(AppColors.darkCard)
                            : hexaCodeToColor(AppColors.whiteHexaColor),
                          borderRadius: BorderRadius.circular(size5),
                          border: Border.all(
                            width: scanPayM!.asset != null ? 1 : 0,
                            color: scanPayM!.asset != null
                              ? hexaCodeToColor(AppColors.secondary)
                              : Colors.transparent
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: MyText(
                                text: 'Asset',
                                textAlign: TextAlign.left,
                                color: isDarkTheme
                                  ? AppColors.darkSecondaryText
                                  : AppColors.textColor,
                              ),
                            ),
                            ReuseDropDown(
                              initialValue: scanPayM!.assetValue.toString(),
                              onChanged: onChangeDropDown,
                              itemsList: ContractService.getConSymbol(contract.sortListContract),
                              style: TextStyle(
                                color: isDarkTheme
                                  ? Colors.white
                                  : hexaCodeToColor(AppColors.blackColor),
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ],
                        ),
                      ),

                      // child: customDropDown(
                      //   scanPayM.asset ?? "Asset name",
                      //   list,
                      //   scanPayM,
                      //   onChangeDropDown,
                      //   item,
                      // ),
                    ),

                    listInput[1],
                    
                    //listInput[2],
                    MyFlatButton(
                      textButton: "CONTINUE",
                      edgeMargin: const EdgeInsets.only(
                        top: 40,
                        left: 66,
                        right: 66,
                      ),
                      hasShadow: scanPayM!.enable,
                      action: scanPayM!.enable ? validateSubmit : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
