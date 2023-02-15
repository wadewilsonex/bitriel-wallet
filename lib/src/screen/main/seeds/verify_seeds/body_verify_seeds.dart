import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/seeds_c.dart';
import 'package:wallet_apps/src/models/createkey_m.dart';

class VerifyPassphraseBody extends StatelessWidget {

  final CreateKeyModel? createKeyModel;
  final Function? submit;
  final Function? onTap;
  final Function? remove3Seeds;

  const VerifyPassphraseBody({
    Key? key, 
    this.createKeyModel,
    this.submit,
    this.onTap,
    this.remove3Seeds
  }) : super(key: key);

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
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                const SeedContents(
                  title: 'Verify Seed', 
                  subTitle: 'Almost done. Please input the words in the numerical order.'
                ),
  
                SizedBox(height: 7.h),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDarkMode ? hexaCodeToColor(AppColors.whiteColorHexa).withOpacity(0.06) : hexaCodeToColor("#E8E8E8"),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: SeedsCompoent().getColumn(context, createKeyModel!.tmpSeed!, 0, moreSize: 2.5),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: SeedsCompoent().getColumn(context, createKeyModel!.tmpSeed!, 1, moreSize: 2.5),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: SeedsCompoent().getColumn(context, createKeyModel!.tmpSeed!, 2, moreSize: 2.5),
                          ),
                        ],
                      ),
                    ],
                  )
                ),
  
                if (createKeyModel!.tmpThreeNum!.isNotEmpty) Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    alignment: Alignment.center,
                    height: 5.8.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: createKeyModel!.tmpThreeNum!.length,
                      itemBuilder: (context, i){
                        return SeedsCompoent().seedContainer(context, createKeyModel!.lsSeeds![int.parse(createKeyModel!.tmpThreeNum![i])], int.parse(createKeyModel!.tmpThreeNum![i]), i, onTap);
                      }
                    ),
                  ),
                ),
  
                SizedBox(height: 3.h),
                // Display Refresh Button When User Fill Out All
                if (createKeyModel!.tmpThreeNum!.isEmpty)
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.refresh, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,), size: 3.h),
                          const SizedBox(width: 9),
                          const MyText(
                            text: "Try Again",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,  
                          ),
                        ],
                      ),
                    ),
                    onTap: () => remove3Seeds!()
                  ),
                ),
  
                Flexible(child: Container()),
                MyGradientButton(
                  textButton: "Continue",
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: () async {
                    submit!();
                  },
                )
              ],
            ),
          ),
        ),
      )
    );
  }

}
