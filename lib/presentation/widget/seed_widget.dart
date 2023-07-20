import 'package:bitriel_wallet/index.dart';

Future<void> seedVerifyLaterDialog(BuildContext context, Function? submit) async {

  bool isCheck = false;
  
  showModalBottomSheet(
    context: context,
    backgroundColor: hexaCodeToColor(AppColors.white),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20), topRight: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateWidget) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
          
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Lottie.asset(
                    "assets/animation/warning-shield.json",
                    repeat: true,
                  ),
                ),
                
                const SizedBox(height: 10),
                
                MyTextConstant(
                  text: 'Verify you Seed Phrase later?',
                  color2: hexaCodeToColor(AppColors.midNightBlue),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),

                const SizedBox(height: 10),
          
                CheckboxListTile(
                  title: MyTextConstant(
                    text: "I understand that if I lose my Secret Seed Phrase I will not be able to access my wallet",
                    textAlign: TextAlign.start,
                    color2: hexaCodeToColor(AppColors.midNightBlue),
                  ),
                  activeColor: hexaCodeToColor(AppColors.primary),
                  value: isCheck,
                  onChanged: (newValue) {
                    setStateWidget(() {
                      isCheck = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                const SizedBox(height: 10,),

                MyButton(
                  textButton: "Yes, Verify Later",
                  buttonColor: AppColors.white,
                  opacity: 0,
                  textColor: isCheck == false ? AppColors.lightGrey : AppColors.primary,
                  action: (){
                    isCheck == false ? null : submit!();
                  }
                ),
          
                const SizedBox(height: 10,),
          
                MyButton(
                  textButton: "No, Verify Now",
                  action: (){
                    Navigator.pop(context);
                  }
                ),

                const SizedBox(height: 10,),
          
              ],
            ),
          );
        }
      );
    },
  );
}