import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/createKey_m.dart';
import 'package:wallet_apps/src/screen/main/verify_key/verify_key.dart';


class CreateSeedsBody extends StatelessWidget {

  final CreateKeyModel? createKeyModel;
  final Function() generateKey;

  const CreateSeedsBody({Key? key, required this.createKeyModel, required this.generateKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    var correctHeight = height - padding.top - padding.bottom;

    return Scaffold(
      backgroundColor: hexaCodeToColor(AppColors.darkBgd),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).orientation == Orientation.portrait
              ? correctHeight
              : MediaQuery.of(context).size.height * 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 25),
                        MyText(
                          text: 'Seed',
                          color: AppColors.whiteColorHexa,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),

                        SizedBox(height: 25),
                        MyText(
                          text: 'Write down or copy these words in the order and save them somewhere safe.',
                          color: AppColors.bgdColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.start,
                        ),
                        
                        SizedBox(height: 100),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: getColumn(createKeyModel!.seed!, 0),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: getColumn(createKeyModel!.seed!, 1),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: getColumn(createKeyModel!.seed!, 2),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 50),
                        GestureDetector(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(AppConfig.iconsPath+'refresh-2.svg'),
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

                        SizedBox(height: 86),
                        MyText(
                          text: "After writing and securing your 12 words, click continue to proceed",
                          color: AppColors.bgdColor,
                          fontSize: 16,
                        ),


                        SizedBox(height: 22),
                        MyFlatButton(
                          hasShadow: false,
                          textButton: "Continue",
                          action: () async {
                            createKeyModel!.threeNum = await AppUtils().randomThreeEachNumber();
                            print("createKeyModel!.threeNum ${createKeyModel!.threeNum}");
                            print("createKeyModel!.tmpThreeNum ${createKeyModel!.tmpThreeNum}");
                            Navigator.push(context, RouteAnimation(enterPage: VerifyPassphrase(createKeyModel: createKeyModel!)));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getColumn(String seed, int pos) {
    var list = <Widget>[];
    var se = seed.split(' ');
    var colSize = se.length ~/ 3;

    for (var i = 0; i < colSize; i++) {
      list.add(Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ), 
        // color: grey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: i * 3 + pos + 1 < 10
          ? Text(
            '  ' + (i * 3 + pos + 1).toString() + '.  ' + se[i * 3 + pos],
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          )
          : Text(
            (i * 3 + pos + 1).toString() + '.  ' + se[i * 3 + pos],
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ));
    }
    return list;
  }
  
}
