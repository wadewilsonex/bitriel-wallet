import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/auth/create_wallet/bloc_create.dart';
import 'package:bitriel_wallet/presentation/auth/passcode/bloc_passcode.dart';
import 'package:bitriel_wallet/standalone/utils/themes/colors.dart';

class Welcome extends StatelessWidget {
  
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _textHeader(),

              const SizedBox(height: 20),
        
              _listMenuButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textHeader(){
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        MyText(
          text: "Set up\nyour Bitriel wallet",
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.start,
          fontSize: 25,
          color: AppColors.midNightBlue,
        ),

        SizedBox(
          height: 10,
        ),

        MyText(
          text: "Safe keeping digital assets, send, receive, trade, and more with Bitriel wallet.",
          textAlign: TextAlign.start,
          fontSize: 19,
          color: AppColors.darkGrey
        )
      ],
    );
  }

  Widget _menuButton(
    BuildContext context, 
    {
      Color? bgColor, 
      required String title, 
      required IconData icon, 
      required String route, 
      String? imgName,
      required AssetProvider pro
    }
  ) {
    return GestureDetector(
      onTap: () {
        // context.push(route);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateSeed())
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Icon Placeholder
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 10.0),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Icon(icon, color: Colors.white),
                )),

              // Image Placeholder
              pro.isDownloadedAsset == true ? Image.file(File("${pro.dirPath}/icons/$imgName"), width: 200, height: 200, cacheHeight: 200,) : Container(),
      
              // Title Placeholder
              Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 10.0),
                child: myText2(
                  context,
                  text: title,
                  color2: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listMenuButton(BuildContext context){

    return Consumer<AssetProvider>(
      builder: (context, pro, wg) {
        return Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: _menuButton(
                    context, 
                    title: "Create Wallet", 
                    icon: Iconsax.add_circle, 
                    route: "/create-wallet", 
                    imgName: "setup-1.png", 
                    bgColor: const Color(0xFFF29F05),
                    pro: pro
                  )
                ),

                const SizedBox(width: 10,),

                Flexible(
                  flex: 1,
                  child: _menuButton(
                    context, 
                    title: "Import Wallet",
                    icon: Iconsax.import, 
                    route: "/import-wallet", 
                    imgName: "setup-2.png", 
                    bgColor: const Color(0xFFF29F05).withOpacity(0.5),
                    pro: pro
                  )
                )
              ],
            )
          ],
        );
      }
    );
  }

}