import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/shimmers/shimmer_c.dart';
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
        //   debugPrint("ValidateField $value");
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
                  
                  const SizedBox(height: 5,),
    
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                    child: MyText(
                      text: "Available balance",
                      hexaColor: isDarkMode ? AppColors.lowWhite : AppColors.darkGrey,
                      fontSize: 20,
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                    child: MyText(
                      text: "${scanPayM!.balance!} ${Provider.of<ContractProvider>(context).sortListContract[scanPayM!.assetValue].symbol}",
                      hexaColor: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.start,
                      fontSize: 25,
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
    
                  // const SizedBox(height: 2,),

                  // _listSenderWallet(context),

                  const SizedBox(height: 5,),
          
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
                            ? Image.network("${provider.sortListContract[scanPayM!.assetValue].logo}", height: 40, width: 40,) 
                            : Image.file(File("${provider.sortListContract[scanPayM!.assetValue].logo}"), height: 40, width: 40,),

                            Expanded(
                              child: MyText(
                                pTop: paddingSize,
                                pBottom: paddingSize,
                                pLeft: paddingSize,
                                text: "${ (ContractService.getConByIndex( context, provider.sortListContract, scanPayM!.assetValue ))['symbol'] }",
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
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
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: paddingSize,
                      right: paddingSize,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Iconsax.warning_2, color: hexaCodeToColor(AppColors.warningColor), size: 18),
                        const SizedBox(width: 1,),
                        MyText(
                          pLeft: 5,
                          text: "Select the right network and asset, or assets may be lost.",
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

  Widget _listSenderWallet(BuildContext context) {
    return Consumer<ApiProvider>(
      builder: (context, provider, widget) {
        return InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            bottomSheetSelectAccount(context);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(paddingSize, 0, paddingSize, 0),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AvatarShimmer(
                                height: 50,
                                width: 50,
                                txt: provider.getKeyring.current.icon,
                                child: randomAvatar(provider.getKeyring.current.icon ?? ''),
                              ),

                              const SizedBox(width: 10),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                    text: provider.getKeyring.current.name,
                                    hexaColor: AppColors.blackColor,
                                    fontSize: 19,
                                    textAlign: TextAlign.start,
                                  ),

                                  MyText(
                                    text: provider.getKeyring.current.address!.replaceRange(8, provider.getKeyring.current.address!.length - 8, "......."),
                                    hexaColor: AppColors.blackColor,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    textAlign: TextAlign.start,
                                  ),
                                  
                                ],
                              ),
                            ]
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                          child: const Icon(
                            Iconsax.arrow_down_1
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        );
      }
    );
  }

  void bottomSheetSelectAccount(BuildContext context) async{
    return showBarModalBottomSheet(
      backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical( 
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, mySetState) {
            return Consumer<ApiProvider>(
              builder: (context, provider, wg) {
                return ListView.builder(
                  itemCount: provider.getKeyring.allAccounts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        provider.getKeyring.setCurrent(provider.getKeyring.allAccounts[index]);
                        provider.notifyListeners();
                        mySetState( () {});

                        scanPayM!.controlAmount.clear();
                        Navigator.pop(context);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                    
                          Padding(
                            padding: const EdgeInsets.all(paddingSize),
                            child: Row(
                              children: [
                    
                                AvatarShimmer(
                                  txt: provider.getKeyring.current.icon,
                                  child: randomAvatar(provider.getKeyring.allAccounts[index].icon ?? '',),
                                ),
                    
                                const SizedBox(width: 10),
                          
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      text: provider.getKeyring.current.name,
                                      fontSize: 19,
                                      textAlign: TextAlign.start,
                                    ),
                                
                                    MyText(
                                      text: provider.getKeyring.allAccounts[index].address == null ? "" : provider.getKeyring.allAccounts[index].address!.replaceRange(6, provider.getKeyring.current.address!.length - 6, "......."),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                    
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: provider.getKeyring.allAccounts[index].address == provider.getKeyring.current.address 
                                    ? const Icon(Icons.check_circle_rounded, color: Colors.green, size: 30,) 
                                    : Icon(Icons.circle, color: Colors.grey[600], size: 30,) 
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                );
              }
            );
          }
        );
      }
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
              size: 25,
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

                          scanPayM!.controlAmount.clear();
                          
                          Navigator.pop(context, listContract[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 5),
                          child: Row(
                            children: [
                              listContract[index]["logo"].toString().contains("http") 
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network("${listContract[index]["logo"]}", height: 40, width: 40,)
                              ) 
                              : ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(File("${listContract[index]["logo"]}"), height: 40, width: 40,)
                              ),
                                          
                              const SizedBox(width: 10,),
                                          
                              MyText(text: listContract[index]["symbol"], fontSize: 20, fontWeight: FontWeight.bold,),
                                          
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