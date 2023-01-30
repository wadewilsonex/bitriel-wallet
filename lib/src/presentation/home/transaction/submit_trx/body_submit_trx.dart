import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/utils/service/contract.dart';
import '../../receive_wallet/appbar_wallet.dart';

class SubmitTrxBody extends StatelessWidget {
  final bool? enableInput;
  final ModelScanPay? scanPayM;
  final Function? onSubmit;
  final Function? clickSend;
  final Function? validateSubmit;
  final Function? validateAddress;
  final Function? onChangeAsset;
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
    this.onChangeAsset,
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
            padding: EdgeInsets.only(right: 2.5.vmax),
            child: SvgPicture.asset(
              '${AppConfig.iconsPath}qr_code.svg',
              width: 4.vmax,
              height: 4.vmax,
              color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.orangeColor)
            ),
          ),
        ),
        pBottom: 2.5.vmax,
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
        pBottom: 2.5.vmax,
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

    return Center(
      child: Container(
        color: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
        child: Form(
          // key: scanPayM!.formStateKey,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
              MyText(
                width: MediaQuery.of(context).size.width/1.5,
                text: "${scanPayM!.balance!} ${Provider.of<ContractProvider>(context).sortListContract[scanPayM!.assetValue].symbol}",
                hexaColor: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 5,
              ),
      
              SizedBox(height: 1.vmax),
      
              MyText(
                text: "Available balance",
                hexaColor: isDarkMode ? AppColors.lowWhite : AppColors.darkGrey,
              ),
      
              SizedBox(height: 10.vmax,),
      
              listInput[0],
              
              /* Type of payment */
              Container(
                margin: EdgeInsets.only(
                  // bottom: 16,
                  left: paddingSize,
                  right: paddingSize,
                ),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(
                  paddingSize, 1.vmax, paddingSize, 1.vmax
                ), 
                decoration: BoxDecoration(
                  color: isDarkMode
                    ? Colors.white.withOpacity(0.06)
                    : hexaCodeToColor(AppColors.whiteHexaColor),
                  borderRadius: BorderRadius.circular(1.vmax),
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
              
              Container(
                margin: EdgeInsets.only(
                  top: 1.5.vmax,
                  bottom: 2.vmax,
                  left: paddingSize,
                  right: paddingSize,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Iconsax.warning_2, color: hexaCodeToColor(AppColors.warningColor), size: 2.5.vmax),
                    SizedBox(width: 1.vmax,),
                    
                    Flexible(
                      child: MyText(
                        overflow: TextOverflow.ellipsis,
                        text: "Select the right network, or assets may be lost.",
                        hexaColor: isDarkMode ? AppColors.lowWhite : AppColors.textColor,
                      )
                    ),
                  ],
                ),
              ),
      
              listInput[1],
              
              //listInput[2],
              MyGradientButton(
                width: MediaQuery.of(context).size.width,
                edgeMargin: EdgeInsets.symmetric(horizontal: paddingSize),
                textButton: "CONTINUE",
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                action: 
                // (){
                //   showDialog(
                //     context: context, builder: (context){
                //       return AlertDialog(
                //         title: MyText(
                //           text: "Oops",
                //         ),
                //         content: MyText(
                //           text: "Feature under maintenance",
                //         ),
                //       );
                //     }
                //   );
                // }
                  scanPayM!.enable ? validateSubmit : null,
              ),
      
            ],
          ),
        ),
      ),
    );
  }
}