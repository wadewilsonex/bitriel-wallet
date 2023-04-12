import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/account.m.dart';
import 'package:wallet_apps/src/models/card_section_setting.m.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/screen/home/menu/backup/backup_key.dart';
import 'package:wallet_apps/src/screen/home/menu/changePin/changepin.dart';
import 'package:wallet_apps/src/screen/main/seeds/create_seeds/create_seeds.dart';

class AccountBody extends StatelessWidget{

  final String? walletName;
  final AccountM? accountModel;
  final Function? onSubmitName;
  final Function? onChangeName;
  final Function? onChangedBackup;
  final Function? onChangedChangePin;
  final Function? onSubmitChangePin;
  final Function? onSubmit;
  final Function? submitChangePin;
  final Function? submitBackUpKey;
  final Function? changeName;
  // final Function? deleteAccout;

  const AccountBody({
    Key? key, 
    this.walletName,
    this.accountModel, 
    this.onSubmitName,
    this.onChangeName,
    this.onChangedBackup, 
    this.onSubmit,
    this.onChangedChangePin, 
    this.onSubmitChangePin, 
    this.submitChangePin, 
    this.submitBackUpKey, 
    this.changeName, 
    // this.deleteAccout
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const MyText(
          text: "Multi-Wallets",
          fontSize: 18,
          color2: Colors.black,
          fontWeight: FontWeight.w600
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Iconsax.arrow_left_2,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 30,
          ),
        ),
      ),
      body: Consumer<ApiProvider>(
        builder: (context, provider, wg){
          return ListView.builder(
            itemCount: provider.getKeyring.allAccounts.length,
            itemBuilder:(context, index) {
              return InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () async {

                  accountModel!.accIndex = index;

                  // ignore: use_build_context_synchronously
                  await showModalBottomSheet(
                    backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical( 
                        top: Radius.circular(25.0),
                      ),
                    ),
                    context: context,
                    builder: (BuildContext context) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          
                          Padding(
                            padding: const EdgeInsets.only(top: paddingSize, left: paddingSize, right: paddingSize),
                            child: MyText(
                              text: provider.getKeyring.allAccounts[index].name ?? '',
                              hexaColor: AppColors.blackColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.start,
                            ),
                          ),

                          const Divider(),
                        
                          GestureDetector(
                            onTap: () => _editAccountNameDialog(context),
                            child: _itemButton(
                              icon: Iconsax.edit, 
                              title: "Edit Wallet Name", 
                              iconColor: AppColors.darkGrey,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context, 
                                Transition(
                                  child: BackUpKey(acc: provider.getKeyring.allAccounts[index],),
                                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                                )
                              );
                            },
                            child: _itemButton(
                              icon: Iconsax.export_1, 
                              title: "Export Wallet",
                              iconColor: AppColors.primaryColor, 
                              titleColor: AppColors.primaryColor
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context, 
                                Transition(
                                  child: ChangePin(acc: provider.getKeyring.allAccounts[index],),
                                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                                )
                              );
                            },
                            child: _itemButton(
                              icon: Iconsax.lock, 
                              title: "Change PIN",
                              iconColor: AppColors.warningColor, 
                              titleColor: AppColors.warningColor
                            ),
                          ),

                          GestureDetector(
                            onTap: () async {

                              Map? value;
                  
                              accountModel!.accIndex = index;

                              String? data = await StorageServices.readSecure(DbKey.privateList)!;

                              List<dynamic>? decode = json.decode(data); 

                              /// If Delete Current Account
                              if (provider.getKeyring.keyPairs[index].address == provider.getKeyring.current.address){
                                // ignore: use_build_context_synchronously
                                value = await DialogComponents().dialogCustom(
                                  context: context,
                                  titles: "You are on current wallet! Are you sure to want delete this wallet?",
                                  contents2: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [

                                        const MyText(
                                          pBottom: 10,
                                          text: "Please choose another wallet below to move to current wallet.",
                                          fontWeight: FontWeight.w600,
                                        ),

                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: provider.getKeyring.keyPairs.length,
                                          itemBuilder: (context, j){
                                            return (provider.getKeyring.keyPairs[j].address != provider.getKeyring.keyPairs[index].address) 
                                            ? ListTile(
                                              onTap: (){
                                                Navigator.pop(context, decode![j]);
                                              },
                                              selectedColor: Colors.blue,
                                              leading: SizedBox(
                                                width: 50,
                                                child: randomAvatar(provider.getKeyring.allAccounts[j].icon ?? '',)
                                              ),
                                              title: MyText(text: provider.getKeyring.keyPairs[j].name, textAlign: TextAlign.left,), 
                                              subtitle: MyText(text: provider.getKeyring.keyPairs[j].address!.replaceRange(10, provider.getKeyring.allAccounts[j].address!.length - 10, "........"), textAlign: TextAlign.left),
                                            ) 
                                            : Container();
                                          },
                                        ),
                                      ],
                                    )
                                  ),
                                  btn2: Container(),
                                  btn: Padding(
                                    padding: const EdgeInsets.all(paddingSize),
                                    child: MyGradientButton(
                                      textButton: "Cancel",
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      action: () => Navigator.pop(context),
                                    ),
                                  ),
                                );
                              } else {

                                // ignore: use_build_context_synchronously
                                value = await DialogComponents().dialogCustom(
                                  context: context,
                                  titles: 'Are you sure to delete this wallet?',
                                  contents: 'Your current wallet, and assets will be removed from this app permanently\n\n You can Only recover your wallet with your Secret Recovery Seed Phrases',
          
                                  btn: MyFlatButton(
                                    height: 60,
                                    edgeMargin: const EdgeInsets.symmetric(horizontal: paddingSize),
                                    isTransparent: false,
                                    buttonColor: AppColors.whiteHexaColor,
                                    textColor: AppColors.redColor,
                                    textButton: "Confirm",
                                    isBorder: true,
                                    action: () {

                                      List<dynamic> current = decode!.where((element) {
                                        
                                        if (element['address'] == provider.getKeyring.current.address){
                                          return true;
                                        }
                                        return false;
                                      }).toList();
                                      Navigator.pop(context, current[0]);
                                      
                                    },
                                  ),

                                  btn2: Padding(
                                    padding: const EdgeInsets.all(paddingSize),
                                    child: MyGradientButton(
                                      textButton: "Cancel",
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      action: () => Navigator.pop(context),
                                    ),
                                  ),
                                );
                              }
                              
                              if(value != null) {

                                await provider.getSdk.api.keyring.deleteAccount(
                                  provider.getKeyring,
                                  provider.getKeyring.allAccounts[index],
                                );

                                decode!.removeAt(index);
                                
                                print(decode.indexOf(value));

                                provider.getKeyring.setCurrent(provider.getKeyring.allAccounts[decode.indexOf(value)]);
                                Provider.of<ContractProvider>(context, listen: false).ethAdd = decode[decode.indexOf(value)]['eth_address'];
                              
                                await StorageServices.writeSecure(DbKey.privateList, json.encode(decode));
                                // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                                provider.notifyListeners();
                                // ignore: invalid_use_of_protected_member
                                Provider.of<ContractProvider>(context, listen: false).notifyListeners();
                                
                                ContractsBalance.getAllAssetBalance();
                              }

                            },
                            child: _itemButton(
                              icon: Iconsax.trash, 
                              title: "Delete Wallet", 
                              titleColor: AppColors.redColor,
                              iconColor: AppColors.redColor,
                            ),
                          ),

                          const SizedBox(height: 10),
                          
                        ],
                      );
                    }
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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

                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: 50,
                                      height: 50,
                                      child: randomAvatar(provider.getKeyring.allAccounts[index].icon ?? '')
                                    ),

                                    const SizedBox(width: 10),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        MyText(
                                          text: provider.getKeyring.allAccounts[index].name ?? '',
                                          hexaColor: AppColors.blackColor,
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start,
                                        ),
                                        
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: paddingSize / 2),
                                              child: MyText(
                                                text: provider.getKeyring.allAccounts[index].address!.replaceRange(10, provider.getKeyring.allAccounts[index].address!.length - 10, "........"),
                                                hexaColor: AppColors.greyCode,
                                                fontSize: 16,
                                              ),
                                            ),
                                        
                                            InkWell(
                                              onTap: () async {
                                                await Clipboard.setData(
                                                  ClipboardData(text: provider.getKeyring.allAccounts[index].address ??''),
                                                );
                                                Fluttertoast.showToast(
                                                  msg: "Copied address",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                );
                                              }, 
                                              child: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primaryColor), size: 20,)
                                            )
                                          ],
                                        )
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
                                  Iconsax.arrow_right_3
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
            },
          );
        }
      ),
      bottomNavigationBar: Consumer<ApiProvider>(
        builder: (context, provider, wg){
          return provider.getKeyring.keyPairs.length >= 3 ? const SizedBox() : Row(
            children: [

              Expanded(
                child: MyGradientButton(
                  edgeMargin: const EdgeInsets.all(paddingSize),
                  textButton: "Create Wallet",
                  fontWeight: FontWeight.w400,
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: () async {

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Pincode(label: PinCodeLabel.fromAccount,)
                        // const ImportAcc(
                        //   isBackBtn: true,
                        // )
                      )
                    ).then((value) async {
                      if (value != null){
                        
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateSeeds(newAcc: NewAccount(), passCode: value,)
                            // const ImportAcc(
                            //   isBackBtn: true,
                            // )
                          )
                        ).then((value) {
                          if (value != null && value == true){
                            
                            // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                            Provider.of<ApiProvider>(context, listen: false).notifyListeners();
                          }
                        });
                      }
                    });
                  },
                ),
              ),
          
              Expanded(
                child: MyGradientButton(
                  edgeMargin: const EdgeInsets.all(paddingSize),
                  textButton: "Import Wallet",
                  fontWeight: FontWeight.w400,
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: () async {

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Pincode(label: PinCodeLabel.fromAccount,)
                        // const ImportAcc(
                        //   isBackBtn: true,
                        // )
                      )
                    ).then((pinValue) async {
                      if (pinValue != null){

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImportAcc(isBackBtn: true, isAddNew: true, passCode: pinValue,)
                            // const ImportAcc(
                            //   isBackBtn: true,
                            // )
                          )
                        ).then((accValue) {
                          if (accValue != null && accValue == true){
                            // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                            Provider.of<ApiProvider>(context, listen: false).notifyListeners();
                          }
                        });
                      }
                    });

                  },
                ),
              )
            ],
          );
        }
      ),
    );
  }

  Widget _itemButton({required String title, required IconData icon, String? titleColor, String? iconColor}){

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: paddingSize / 2),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: hexaCodeToColor(AppColors.lightColorBg),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingSize),
          child: Row(
            children: [
              
              Icon(icon, color: hexaCodeToColor(iconColor!)),
        
              MyText(
                left: 10,
                text: title,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                hexaColor: titleColor ?? AppColors.blackColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _editAccountNameDialog(BuildContext context) {
    
    accountModel!.editNameController.text = Provider.of<ApiProvider>(context, listen: false).getKeyring.allAccounts[accountModel!.accIndex!].name!;
    return showDialog<String?>(
      context: context,
      builder: ((context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(vertical: paddingSize),
        title: const MyText(text: "Account Name", fontSize: 20, fontWeight: FontWeight.w500, textAlign: TextAlign.start, color2: Colors.black,),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Form(
            child: MyInputField(
              autoFocus: true,
              hintText: 'Enter Name',
              controller: accountModel!.editNameController,
              onSubmit: () async {
                await changeName!();
              }, 
              focusNode: accountModel!.newNode,
            ),
          ),
        ),
        actions: [

          Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: MyFlatButton(
                    height: 60,
                    edgeMargin: const EdgeInsets.symmetric(horizontal: paddingSize),
                    isTransparent: false,
                    buttonColor: AppColors.whiteHexaColor,
                    textColor: AppColors.redColor,
                    textButton: "Cancel",
                    isBorder: true,
                    action: () {
                      _closeDialog(context);
                    },
                  )
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: MyGradientButton(
                    edgeMargin: const EdgeInsets.symmetric(horizontal: paddingSize),
                    textButton: "Update",
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    action: () async {
                      await changeName!();
                    },
                  ),
                ),
              ),
            ]
          )

          
        ],
      )),
    );
  }

  void _closeDialog(BuildContext context) {
    Navigator.of(context).pop(accountModel!.editNameController.text); // dialog returns true
  }
}

  Future<void> _deleteAccount({BuildContext? context}) async {

    dialogLoading(context!);

    final api = Provider.of<ApiProvider>(context, listen: false);
    
    try {

      for( KeyPairData e in api.getKeyring.allAccounts){
        await api.getSdk.api.keyring.deleteAccount(
          api.getKeyring,
          e,
        );
      }

      final mode = await StorageServices.fetchData(DbKey.themeMode);
      final sldNW = await StorageServices.fetchData(DbKey.sldNetwork);

      await StorageServices.clearStorage();

      // Re-Save Them Mode
      await StorageServices.storeData(mode, DbKey.themeMode);
      await StorageServices.storeData(sldNW, DbKey.sldNetwork);

      await StorageServices.clearSecure();
      
      Provider.of<ContractProvider>(context, listen: false).resetConObject();
      
      await Future.delayed(const Duration(seconds: 2), () {});
      
      Provider.of<WalletProvider>(context, listen: false).clearPortfolio();

      Navigator.pushAndRemoveUntil(context, RouteAnimation(enterPage: const Onboarding()), ModalRoute.withName('/'));
    } catch (e) {

      if (kDebugMode) {
        print("_deleteAccount ${e.toString()}");
      }
      // await dialog(context, e.toString(), 'Opps');
    }
  }