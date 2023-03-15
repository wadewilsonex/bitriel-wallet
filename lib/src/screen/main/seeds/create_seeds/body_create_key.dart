import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/seeds_c.dart';
import 'package:wallet_apps/src/models/account.m.dart';
import 'package:wallet_apps/src/models/createkey_m.dart';
import 'package:wallet_apps/src/screen/main/seeds/verify_seeds/verify_seeds.dart';


class CreateSeedsBody extends StatelessWidget {

  final CreateKeyModel? createKeyModel;
  final NewAccount? newAcc;
  final Function() generateKey;

  const CreateSeedsBody({Key? key, required this.createKeyModel, required this.generateKey, @required this.newAcc}) : super(key: key);

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

                SizedBox(height: 2.5.h),
                MyText(
                  text: "After writing and securing your 12 words, click continue to proceed",
                  hexaColor: isDarkMode ? AppColors.lowWhite : AppColors.textColor,
                  textAlign: TextAlign.start,
                  fontSize: 18,
                ),
                
                SizedBox(height: 7.h),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isDarkMode ? Colors.black.withOpacity(0.06) : hexaCodeToColor("#E8E8E8"),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: SeedsCompoent().getColumn(context, createKeyModel!.seed!, 0, moreSize: 2.5),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: SeedsCompoent().getColumn(context, createKeyModel!.seed!, 1, moreSize: 2.5),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: SeedsCompoent().getColumn(context, createKeyModel!.seed!, 2, moreSize: 2.5),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                              const MyText(
                                text: "Generate seed",
                                fontSize: 17,
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
                              const MyText(
                                text: "Copy",
                                fontSize: 17,
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

                Expanded(child: Container()),
                MyGradientButton(
                  textButton: "Continue",
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: () async {
                    // Generate Random Three Number Before Navigate
                    createKeyModel!.threeNum = AppUtils().randomThreeEachNumber();
                    Navigator.push(context, Transition(child: VerifyPassphrase(createKeyModel: createKeyModel!, newAcc: newAcc),  transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
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
