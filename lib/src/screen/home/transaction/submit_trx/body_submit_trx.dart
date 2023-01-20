import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/service/contract.dart';
import '../../receive_wallet/appbar_wallet.dart';

class SubmitTrxBody extends StatelessWidget {
  final bool? enableInput;
  final ModelScanPay? scanPayM;
  final Function? onSubmit;
  final Function? clickSend;
  final Function? validateSubmit;
  final Function? validateAddress;
  final Function? onChanged;
  final String Function(String)? validateField;
  final Function(String)? onChangeDropDown;

  final PopupMenuItem Function(Map<String, dynamic>)? item;
  final Function? pasteText;
  final bool? pushRepleacement;
  final Function? scanQR;

  const SubmitTrxBody({Key? key, 
    this.pushRepleacement,
    this.pasteText,
    this.enableInput,
    this.scanPayM,
    this.onChanged,
    this.validateField,
    this.validateAddress,
    this.onSubmit,
    this.clickSend,
    this.validateSubmit,
    this.onChangeDropDown,
    this.item,
    this.scanQR
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<MyInputField> listInput = [
      
      MyInputField(
        suffixIcon: GestureDetector(
          onTap: () async {
            scanQR!();
          },
          child: Container(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Iconsax.scan, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.orangeColor)),
          ),
        ),
        pBottom: 16,
        hintText: "Receiver address",
        textInputFormatter: [
          LengthLimitingTextInputFormatter(TextField.noMaxLength),
        ],
        controller: scanPayM!.controlReceiverAddress,
        focusNode: scanPayM!.nodeReceiverAddress,
        validateField: (value) => value == null ? "Plaese fill reciever address" : null,
        // validateField: (value) {
        //   print("ValidateField $value");
        //   return validateAddress!(value);
        // },
        onChanged: onChanged,
        onSubmit: () {}
      ),
      MyInputField(
        pBottom: 16,
        hintText: "Amount",
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
    
    final contract = Provider.of<ContractProvider>(context);

    return Container(
      height: MediaQuery.of(context).size.height,
      color: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            
            SizedBox(height: 2.h,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize),
              child: MyText(
                text: "Available balance",
                hexaColor: isDarkMode ? AppColors.lowWhite : AppColors.darkGrey,
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize),
              child: MyText(
                text: "${scanPayM!.balance!} ${Provider.of<ContractProvider>(context).sortListContract[scanPayM!.assetValue].symbol}",
                hexaColor: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start,
                fontSize: 22,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(paddingSize),
              child: MyText(
                text: "Please, enter the receiver’s address with the amount of transfer ${Provider.of<ContractProvider>(context).sortListContract[scanPayM!.assetValue].symbol} in below field.",
                hexaColor: "#878787",
                textAlign: TextAlign.start,
              ),
            ),

            SizedBox(height: 2.h,),
    
            listInput[0],
            
    
            listInput[1],

            /* Type of payment */
            Container(
              margin: const EdgeInsets.only(
                // bottom: 16,
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
                        text: 'Asset',
                        textAlign: TextAlign.left,
                        hexaColor: isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.textColor,
                      ),
                    ),
                    Flexible(
                      child:  QrViewTitle(
                        isValue: true,
                        listContract: ContractService.getConSymbol(context, contract.sortListContract),
                        initialValue: scanPayM!.assetValue.toString(),
                        onChanged: onChangeDropDown,
                      ),
                    )
                  ],
                ),
              ),
            ),

            
            Container(
              margin: EdgeInsets.only(
                top: 10.sp,
                bottom: 15.sp,
                left: paddingSize,
                right: paddingSize,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Iconsax.warning_2, color: hexaCodeToColor(AppColors.warningColor), size: 18.sp),
                  SizedBox(width: 1.w,),
                  MyText(
                    text: "Select the right network, or assets may be lost.",
                    hexaColor: isDarkMode ? AppColors.lowWhite : AppColors.textColor,
                    fontSize: 15,
                  ),
                ],
              ),
            ),

            Expanded(child: Container()),
            MyGradientButton(
              edgeMargin: const EdgeInsets.all(paddingSize),
              textButton: "CONTINUE",
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              action: scanPayM!.enable ? validateSubmit : null,
            ),
    
          ],
        ),
      ),
    );
  }
}