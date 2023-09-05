import 'package:bitriel_wallet/index.dart';

Widget itemButton({required String title, required IconData icon, String? titleColor, String? iconColor}){

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: paddingSize / 2),
    child: Container(
      height: 40,
      decoration: BoxDecoration(
        color: hexaCodeToColor(AppColors.white),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: paddingSize),
        child: Row(
          children: [
            
            Icon(icon, color: hexaCodeToColor(iconColor!)),

            const SizedBox(width: 10,),
      
            MyTextConstant(
              text: title,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              // hexaColor: titleColor ?? AppColors.blackColor,
            )
          ],
        ),
      ),
    ),
  );
}

Future<String?> editAccountNameDialog(BuildContext context) {
    
    // accountModel!.editNameController.text = Provider.of<ApiProvider>(context, listen: false).getKeyring.allAccounts[accountModel!.accIndex!].name!;
    return showDialog<String?>(
      context: context,
      builder: ((context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(vertical: paddingSize),
        title: const MyTextConstant(text: "Account Name", fontSize: 20, fontWeight: FontWeight.w500, textAlign: TextAlign.start, color2: Colors.black,),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          // child: Form(
          //   child: MyInputField(
          //     autoFocus: true,
          //     hintText: 'Enter Name',
          //     controller: accountModel!.editNameController,
          //     onSubmit: () async {
          //       await changeName!();
          //     }, 
          //     focusNode: accountModel!.newNode,
          //   ),
          // ),
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
                      // _closeDialog(context);
                    },
                  )
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: MyButton(
                    edgeMargin: const EdgeInsets.symmetric(horizontal: paddingSize),
                    textButton: "Update",
                    // begin: Alignment.bottomLeft,
                    // end: Alignment.topRight,
                    action: () async {
                      // await changeName!();
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