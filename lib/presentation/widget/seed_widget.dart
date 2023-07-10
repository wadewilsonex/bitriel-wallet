import 'package:bitriel_wallet/index.dart';

class SeedContents extends StatelessWidget{

  final String? title;
  final String? subTitle;

  const SeedContents({Key? key, required this.title, required this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 25),
        MyTextConstant(
          text: title,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),

        const SizedBox(height: 5),
        MyTextConstant(
          text: subTitle,
          // hexaColor: isDarkMode ? AppColors.lowWhite : AppColors.darkGrey,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.start,
          // fontSize: 16,
        ),
      ],
    );
  }
}

Future<void> seedVerifyLaterDialog(BuildContext context, Function? submit) async {

  bool isCheck = false;
  
  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateWidget) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: hexaCodeToColor(AppColors.whiteColorHexa),
            content: SizedBox(
              // height: MediaQuery.of(context).size.height / 2.6,
              width: MediaQuery.of(context).size.width * 0.7,
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Lottie.asset(
                        "assets/animation/warning-shield.json",
                        repeat: true,
                      ),
                    ),
                    const MyText(
                      text: 'Verify you Seed Phrase later?',
                      fontSize: 20,
                      top: 10,
                      bottom: 25,
                      fontWeight: FontWeight.bold,
                    ),
  
                    Theme(
                      data: ThemeData(),
                      child: CheckboxListTile(
                        title: const MyText(
                          text: "I understand that if I lose my Secret Seed Phrase I will not be able to access my wallet",
                          textAlign: TextAlign.start,
                        ),
                        activeColor: hexaCodeToColor(AppColors.primaryColor),
                        value: isCheck,
                        onChanged: (newValue) {
                          setStateWidget(() {
                            isCheck = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.1,
                    ),

                    MyFlatButton(
                      isTransparent: true,
                      buttonColor: AppColors.greenColor,
                      textColor: isCheck == false ? AppColors.greyCode : AppColors.primaryColor,
                      textButton: "Yes, Verify Later",
                      action: () {
                        isCheck == false ? null : submit!();
                      },
                    ),

                    const SizedBox(height: 10,),

                    MyGradientButton(
                      textButton: "No, Verify Now",
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      action: (){
                        Navigator.pop(context);
                      }
                    )

                  ],
                ),
              ),
            )
          );
        }
      );
    },
  );
}