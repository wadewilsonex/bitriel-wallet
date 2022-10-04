import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/seeds_c.dart';
import 'package:wallet_apps/src/models/createkey_m.dart';
import 'package:wallet_apps/src/screen/main/verify_key/verify_key.dart';


class CreateSeedsBody extends StatelessWidget {

  final CreateKeyModel? createKeyModel;
  final Function() generateKey;

  const CreateSeedsBody({Key? key, required this.createKeyModel, required this.generateKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.only(left: paddingSize, right: paddingSize, bottom: paddingSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                const SeedContents(
                  title: 'Seed', 
                  subTitle: 'Write down or copy these words in the order and save them somewhere safe.'
                ),
                
                SizedBox(height: 7.h),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: SeedsCompoent().getColumn(context, createKeyModel!.seed!, 0),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: SeedsCompoent().getColumn(context, createKeyModel!.seed!, 1),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: SeedsCompoent().getColumn(context, createKeyModel!.seed!, 2),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.refresh, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,), size: 3.h),
                              const SizedBox(width: 9),
                              MyText(
                                text: "Generate new seed",
                                fontSize: 14,
                                fontWeight: FontWeight.bold,  
                              ),
                            ],
                          ),
                        ),
                        onTap: () => generateKey()
                      ),
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.copy, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,), size: 3.h),
                              const SizedBox(width: 9),
                              MyText(
                                text: "Copy",
                                fontSize: 14,
                                fontWeight: FontWeight.bold,  
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                'Copied to clipboard',
                                textAlign: TextAlign.center,
                              ),
                              duration: Duration(seconds: 1),
                            ));
                            Clipboard.setData(
                              ClipboardData(text: createKeyModel!.seed!),
                            );
                        }
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 7.h),
                MyText(
                  text: "After writing and securing your 12 words, click continue to proceed",
                  hexaColor: isDarkMode ? AppColors.lowWhite : AppColors.textColor,
                ),


                Expanded(child: Container()),
                MyGradientButton(
                  textButton: "Continue",
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: () async {
                    // Generate Random Three Number Before Navigate
                    createKeyModel!.threeNum = AppUtils().randomThreeEachNumber();
                    Navigator.push(context, Transition(child: VerifyPassphrase(createKeyModel: createKeyModel!),  transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                  },
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
  
}
