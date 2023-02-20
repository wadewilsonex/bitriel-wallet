import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/service/contract.dart';

class SubmitTrxBody extends StatelessWidget {
  final bool? enableInput;
  final ModelScanPay? scanPayM;
  final Function? onSubmit;
  final Function? clickSend;
  final Function? validateSubmit;
  final Function? validateAddress;
  final Function? onChanged;
  final String Function(String)? validateField;
  final Function(String)? onChangeAsset;

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
    this.onChangeAsset,
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
            child: Icon(Iconsax.scan, color: hexaCodeToColor(AppColors.primaryColor)),
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

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Consumer<ContractProvider>(
        builder: (context, provider, widget) {
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
                      fontSize: 18,
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
                      fontSize: 17,
                    ),
                  ),
    
                  SizedBox(height: 2.h,),
          
                  listInput[0],
                  
          
                  listInput[1],
    
                  /* Type of payment */
                  GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        isDismissible: true,
                        backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical( 
                            top: Radius.circular(25.0),
                          ),
                        ),
                        builder: (context) => _listAsset(
                          isValue: true,
                          listContract: ContractService.getConSymbol(context, contract.sortListContract),
                          initialValue: scanPayM!.assetValue.toString(),
                          onChanged: onChangeAsset,
                        ),
                      );
    
                    },
                    child: Container(
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
                            provider.sortListContract[scanPayM!.assetValue].logo.toString().contains("http") 
                            ? Image.network("${provider.sortListContract[scanPayM!.assetValue].logo}", height: 25.sp, width: 25.sp,) 
                            : Image.asset("${provider.sortListContract[scanPayM!.assetValue].logo}", height: 25.sp, width: 25.sp,),

                            Expanded(
                              child: MyText(
                                pTop: paddingSize,
                                pBottom: paddingSize,
                                pLeft: paddingSize,
                                text: "${ (ContractService.getConByIndex( context, provider.sortListContract, scanPayM!.assetValue ))['symbol'] }",
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                textAlign: TextAlign.left,
                                hexaColor: isDarkMode
                                  ? AppColors.darkSecondaryText
                                  : AppColors.textColor,
                              ),
                            ),

                            Icon(Iconsax.arrow_right_3, color: hexaCodeToColor(AppColors.primaryColor),)
                          ],
                        ),
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
      ),
    );
  }

  Widget _listAsset(
    {
      final bool? isValue,
      final String? initialValue,
      final Function? onChanged,
      final List<Map<String, dynamic>>? listContract,
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
                itemCount: listContract!.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          onChanged!(index.toString());
                          Navigator.pop(context, listContract[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 5),
                          child: Row(
                            children: [
                              listContract[index]["logo"].toString().contains("http") 
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network("${listContract[index]["logo"]}", height: 27.sp, width: 27.sp,)
                              ) 
                              : ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset("${listContract[index]["logo"]}", height: 27.sp, width: 27.sp,)
                              ),
                                          
                              SizedBox(width: 2.w,),
                                          
                              MyText(text: listContract[index]["symbol"], fontSize: 18, fontWeight: FontWeight.bold,),
                                          
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