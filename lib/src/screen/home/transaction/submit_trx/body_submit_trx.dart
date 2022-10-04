import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/service/contract.dart';
import '../../receive_wallet/appbar_wallet.dart';

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
  final bool? pushRepleacement;
  final Function? scanQR;

  const SubmitTrxBody({Key? key, 
    this.pushRepleacement,
    this.pasteText,
    this.enableInput,
    this.scanPayM,
    this.onChanged,
    this.validateField,
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
            child: SvgPicture.asset(
              '${AppConfig.iconsPath}qr_code.svg',
              width: 4.w,
              height: 4.h,
              color: Colors.white,
            ),
          ),
        ),
        pBottom: 16,
        hintText: "Receiver address",
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

    return Column(
      children: [
        MyAppBar(
          title: "Send",
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
                    
                    MyText(
                      width: MediaQuery.of(context).size.width/1.5,
                      text: "${scanPayM!.balance!} ${Provider.of<ContractProvider>(context).sortListContract[scanPayM!.assetValue].symbol}",
                      hexaColor: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),

                    SizedBox(height: 1.h,),

                    const MyText(
                      text: "Available balance",
                      hexaColor: AppColors.lowWhite,
                    ),

                    SizedBox(height: 10.h,),

                    listInput[0],
                    
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
                                // assetInfo: provider.assetInfo,
                                listContract: ContractService.getConSymbol(context, contract.sortListContract),
                                initialValue: scanPayM!.assetValue.toString(),
                                onChanged: onChanged,
                              ),
                            )
                            // ReuseDropDown(
                            //   icon: Icon(Iconsax.arrow_down_1, color: Colors.white, size: 20.5.sp),
                            //   initialValue: scanPayM!.assetValue.toString(),
                            //   onChanged: onChangeDropDown,
                            //   itemsList: ContractService.getConSymbol(context, contract.sortListContract),
                            //   style: TextStyle(
                            //     color: isDarkMode
                            //       ? Colors.white
                            //       : hexaCodeToColor(AppColors.blackColor),
                            //     fontSize: 15.sp,
                            //     fontWeight: FontWeight.w600
                            //   ),
                            // ),
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
                          Icon(Iconsax.warning_2, color: hexaCodeToColor(AppColors.warningColor), size: 18.5.sp),
                          SizedBox(width: 1.w,),
                          const MyText(
                            top: 5,
                            text: "Select the right network, or assets may be lost.",
                            hexaColor: AppColors.lowWhite,
                          ),
                        ],
                      ),
                    ),

                    listInput[1],
                    
                    //listInput[2],
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
            ),
          ),
        )
      ],
    );
  }
}