import 'package:bitriel_wallet/index.dart';
import 'package:qr_flutter/qr_flutter.dart'; 

class ReceiveWallet extends StatelessWidget {
  const ReceiveWallet({Key? key, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      backgroundColor: hexaCodeToColor(AppColors.background),
      appBar: appBar(context, title: "Receive SEL"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          
          _qrWidget(),

          _warnMsg(),

          _optionBtn(),

        ],
      ),
    );
  }
}

Widget _qrWidget() {
  return Container(
    margin: const EdgeInsets.only(
      bottom: paddingSize,
      left: 50.0,
      right: 50.0,
      top: 50.0
    ),
    child: Column(
      children: [
          
        // Asset Logo and Symbol
        Container(
          padding: const EdgeInsets.only(top: paddingSize),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            // boxShadow: [shadow(context)],
            color: isDarkMode
              ? Colors.white
              : hexaCodeToColor(AppColors.whiteHexaColor),
          ),
          child: Column(
            children: [
          
              QrImageView(
                data: '1234567890',
                version: QrVersions.auto,
                size: 200.0,
                embeddedImage: Image.asset('assets/logo/embed-qr.png').image,
                // eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.circle),
                // dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle),
              ),
        
              Container(
                margin: const EdgeInsets.all(paddingSize),
                child: MyTextConstant(
                  text: 'sefdsgdfklgjfdlgfedjhngldfukgjhglkdfssssgfdgsssss',
                  color2: hexaCodeToColor(AppColors.darkGrey),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),

        
      ],
    ),
  );
}

Widget _warnMsg() {
  return Container(
    margin: const EdgeInsets.all(14),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: hexaCodeToColor(AppColors.red).withOpacity(0.35)
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Iconsax.warning_2, color:Colors.red,),

        SizedBox(width: 10),
  
        Expanded(
          child: MyTextConstant(
            text: "Send only Selendra Smart Chain (SEL) to this address, or you might lose your funds.",
            textAlign: TextAlign.start,
            color2: Colors.red,
          ),
        )
      ]
    ),
  );
}

Widget _optionBtn() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            FloatingActionButton(
              heroTag: "btnCopy",
              backgroundColor: Colors.white,
              onPressed: () {},
              child: Icon(
                Iconsax.copy,
                size: 35,
                color: hexaCodeToColor(AppColors.primary),
              ),
            ),
  
            const SizedBox(height: 10),
  
            MyTextConstant(
              text: "Copy",
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w600,
              color2: hexaCodeToColor(AppColors.midNightBlue),
            ),
            
          ],
        ),
  
        const SizedBox(width: 50),
  
        Column(
          children: [
            FloatingActionButton(
              heroTag: "btnShare",
              backgroundColor: Colors.white,
              onPressed: () {},
              child: Icon(
                Iconsax.share,
                size: 35,
                color: hexaCodeToColor(AppColors.primary),
              ),
            ),
  
            const SizedBox(height: 10),
  
            MyTextConstant(
              text: "Share",
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w600,
              color2: hexaCodeToColor(AppColors.midNightBlue),
            ),
            
          ],
        ),
      ],
    ),
  );
}