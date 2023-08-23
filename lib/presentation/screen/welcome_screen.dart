import 'package:bitriel_wallet/index.dart';

class Welcome extends StatelessWidget {
  
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: hexaCodeToColor(AppColors.background),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _textHeader(),

              const SizedBox(height: 50),
        
              SizedBox(
                child: _listMenuButton(context)
              ),
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

        MyTextConstant(
          text: "Set up\nyour Bitriel wallet",
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.start,
          fontSize: 25,
          color2: Colors.black,
        ),

        SizedBox(
          height: 10,
        ),

        MyTextConstant(
          text: "Safe keeping digital assets, send, receive, trade, and more with Bitriel wallet.",
          textAlign: TextAlign.start,
          fontSize: 17,
          color2: Colors.grey
        )
      ],
    );
  }

  Widget _listMenuButton(BuildContext context){

    return Row(
      children: [
        Flexible(
          flex: 1,
          child: _menuButton(
            context, 
            title: "Create Wallet", 
            icon: Iconsax.add_circle, 
            route: "/create-wallet", 
            imgName: "setup-1.png", 
            bgColor: hexaCodeToColor(AppColors.primary).withOpacity(0.5),
            navigate: () async {

              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PincodeScreen())
              ).then((value) {
                
                if (value != null){

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateWalletScreen(pin: value!,))
                  );
                }
              });
            }
          )
        ),

        const SizedBox(width: 10,),

        Flexible(
          flex: 1,
          child: _menuButton(
            context, 
            title: "Import Wallet", 
            icon: Iconsax.import ,
            route: "/import-wallet", 
            imgName: "setup-2.png", 
            bgColor: hexaCodeToColor(AppColors.secondary).withOpacity(0.5),
            navigate: () async {

              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PincodeScreen())
              ).then((value) {
                
                if (value != null){

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImportWalletScreen(pin: value,))
                  );
                }
              });
            }
          )
        )
      ],
    );
  }


  Widget _menuButton(BuildContext context, {Color? bgColor, required String title, required IconData icon, required String route, String? imgName, Function? navigate}) {
    return GestureDetector(
      onTap: () {
        // context.push(route);
        navigate!();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 250,
          decoration: BoxDecoration(
            color: bgColor
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
      
              // Icon Placeholder
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 10.0),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Icon(icon, color: Colors.white),
                )
              ),

              
              Expanded(
                child: Consumer<AssetProvider>(
                  builder: (context, pro, wg){
                    return pro.isDownloadedAsset == true ? Image.file(File("${pro.dirPath}/icons/$imgName"), width: double.maxFinite,) : Container();
                  }
                ),
              ),
      
              // Image Placeholder
              // Consumer<AssetProvider>(
              //   builder: (context, pro, wg){
              //     return pro.isDownloadedAsset ? const Expanded(child: SizedBox()) : const Center(
              //       child: Padding(
              //         padding: EdgeInsets.all(8.0),
              //         child: Placeholder(
              //           fallbackHeight: 200,
              //           fallbackWidth: 200,
              //         ),
              //       ),
              //     );
              //   }
              // ),
          
              // Title
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

}