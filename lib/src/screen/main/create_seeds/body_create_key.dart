import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/seeds_c.dart';
import 'package:wallet_apps/src/models/createKey_m.dart';
import 'package:wallet_apps/src/screen/main/verify_key/verify_key.dart';


class CreateSeedsBody extends StatelessWidget {

  final CreateKeyModel? createKeyModel;
  final Function() generateKey;

  const CreateSeedsBody({Key? key, required this.createKeyModel, required this.generateKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: hexaCodeToColor(AppColors.darkBgd),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.only(left: paddingSize, right: paddingSize, bottom: paddingSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                SeedContents(
                  title: 'Seed', 
                  subTitle: 'Write down or copy these words in the order and save them somewhere safe.'
                ),
                
                SizedBox(height: 100),
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

                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.refresh, color: hexaCodeToColor(AppColors.whiteColorHexa), size: 20),
                          SizedBox(width: 9),
                          MyText(
                            text: "Generate new seed",
                            color: AppColors.whiteColorHexa,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,  
                            top: 4,
                          ),
                        ],
                      ),
                      onTap: () => generateKey()
                    ),

                    GestureDetector(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.whiteColorHexa), size: 20),
                          SizedBox(width: 9),
                          MyText(
                            text: "Copy",
                            color: AppColors.whiteColorHexa,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,  
                            top: 4,
                          ),
                        ],
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
                  ],
                ),



                SizedBox(height: 86),
                MyText(
                  text: "After writing and securing your 12 words, click continue to proceed",
                  color: AppColors.lowWhite,
                  fontSize: 16,
                ),


                Expanded(child: Container()),
                MyGradientButton(
                  textButton: "Continue",
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: () async {
                    // Generate Random Three Number Before Navigate
                    createKeyModel!.threeNum = await AppUtils().randomThreeEachNumber();
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
