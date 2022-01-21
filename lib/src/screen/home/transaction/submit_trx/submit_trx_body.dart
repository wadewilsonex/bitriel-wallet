import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/appbar_c.dart';
import 'package:wallet_apps/src/components/reuse_dropdown.dart';
import 'package:wallet_apps/core/service/contract.dart';
import 'package:clipboard/clipboard.dart';

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

    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

    final contract = Provider.of<ContractProvider>(context);

    const double textSize = 15;

    final List<MyInputField> listInput = [
      MyInputField(
        isBorder: false,
        pLeft: 0, pRight: 0,
        // pBottom: 16,
        labelText: "Receiver address",
        textInputFormatter: [
          LengthLimitingTextInputFormatter(TextField.noMaxLength),
        ],
        controller: scanPayM!.controlReceiverAddress,
        focusNode: scanPayM!.nodeReceiverAddress,
        validateField: (value) => value == null ? 'Please fill in receiver address' : null,
        onChanged: onChanged,
        onSubmit: () {},
        // suffix: ,
      ),
      MyInputField(
        isBorder: false,
        pLeft: 0, pRight: 0,
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

    return BodyScaffold(
      height: MediaQuery.of(context).size.height,
      left: paddingSize, right: paddingSize,
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            SendAppBar(
              title: "SEND",
              trailing: IconButton(
                padding: EdgeInsets.zero,
                onPressed: (){},
                icon: Icon(Icons.close, size: 30, color: Colors.white)
              ),
              margin: EdgeInsets.only(bottom: 30),
            ),

            SendComponent(
              margin: EdgeInsets.only(bottom: 30),
              label: "Receive Address",
              txtFormField: listInput[0],
              trailing1: MyText(
                text: "Paste",
                fontWeight: FontWeight.w700,
                color: AppColors.blueColor,
                fontSize: textSize,
              ),
              trailing2: SvgPicture.asset(AppConfig.iconPath+"qr.svg", width: 20, height: 20),
              onPressedTrailing1: () async {
                pasteText!();
              }
            ),
            
            /* Type of payment */
            // Container(
            //   margin: const EdgeInsets.only(
            //     bottom: 16.0,
            //     left: 16,
            //     right: 16,
            //   ),

            //   child: Container(
            //     padding: const EdgeInsets.only(
            //       top: 11.0,
            //       bottom: 11.0,
            //       left: 20.0,
            //       right: 14.0,
            //     ),
            //     decoration: BoxDecoration(
            //       color: isDarkTheme
            //         ? hexaCodeToColor(AppColors.lowGrey)
            //         : hexaCodeToColor(AppColors.whiteHexaColor),
            //       borderRadius: BorderRadius.circular(size5),
            //       border: Border.all(
            //         width: scanPayM!.asset != null ? 1 : 0,
            //         color: hexaCodeToColor(AppColors.whiteColorHexa)
            //         // scanPayM!.asset != null
            //         //   ? hexaCodeToColor(AppColors.secondary)
            //         //   : Colors.transparent
            //       ),
            //     ),
            //     child: Row(
            //       children: <Widget>[
            //         Expanded(
            //           child: MyText(
            //             text: 'Asset',
            //             textAlign: TextAlign.left,
            //             color: isDarkTheme
            //               ? AppColors.darkSecondaryText
            //               : AppColors.textColor,
            //             fontSize: 15,
            //           ),
            //         ),
            //         ReuseDropDown(
            //           initialValue: scanPayM!.assetValue.toString(),
            //           onChanged: onChangeDropDown,
            //           itemsList: ContractService.getConSymbol(contract.sortListContract),
            //           style: TextStyle(
            //             color: isDarkTheme
            //               ? Colors.white
            //               : hexaCodeToColor(AppColors.blackColor),
            //             fontSize: 18,
            //             fontWeight: FontWeight.w600
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),

            // ),

            SendComponent(
              margin: EdgeInsets.only(bottom: 20),
              label: "Amount",
              txtFormField: listInput[1],
              trailing1: MyText(
                text: "USD",
                fontWeight: FontWeight.w700,
                color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.blackColor,
                fontSize: textSize,
              ),
              trailing2: MyText(
                text: "SEL",
                fontWeight: FontWeight.w700,
                color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.blackColor,
                fontSize: textSize,
              ),
              onPressedTrailing2: () async {
                try {
                  await TrxOptionMethod.scanQR(
                    context,
                    Provider.of<ContractProvider>(context, listen: false).sortListContract,
                  );
                } catch (e) {
                  // print(e);
                }
              },
            ),
            
            MyText(
              // left: 10,
              text: " ≈ ${scanPayM!.priceToSel.toString()} SEL",
              fontSize: textSize,
              color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.blackColor,
            ),

            Expanded(child: Container()),
            
            //listInput[2],
            MyFlatButton(
              height: 100,
              textButton: "Next",
              fontSize: 13,
              edgePadding: EdgeInsets.only(top: 20, bottom: 20),
              // edgeMargin: const EdgeInsets.only(
              //   top: 40,
              // ),
              hasShadow: scanPayM!.enable,
              action: scanPayM!.enable ? validateSubmit : null,
            ),
          ],
        ),
      ),
    );
  }
}
