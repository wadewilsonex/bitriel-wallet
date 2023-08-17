import 'package:bitriel_wallet/domain/usecases/wallet_uc/receive_impl.dart';
import 'package:bitriel_wallet/index.dart';

class ReceiveWallet extends StatelessWidget {

  final String? addr;

  const ReceiveWallet({Key? key, this.addr}) : super(key: key);

  @override
  Widget build(BuildContext context) { 

    final ReceiveUcImpl receiveImpl = ReceiveUcImpl();

    receiveImpl.setBuildContext = context;

    return Scaffold(
      backgroundColor: hexaCodeToColor(AppColors.background),
      appBar: appBar(context, title: "Receive SEL"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          
          _qrWidget(receiveImpl, addr),

          _warnMsg(),

          _optionBtn(context, receiveImpl, addr),

        ],
      ),
    );
  }
}

Widget _qrWidget(ReceiveUcImpl receiveImpl, String? addr) {
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
          
              Consumer<SDKProvider>(
                builder: (context, pro, wg) {
                  return RepaintBoundary(
                    key: receiveImpl.globalKey,
                    child: Container(
                      padding: const EdgeInsets.all(paddingSize + 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        // boxShadow: [shadow(context)],
                        color: isDarkMode
                          ? Colors.white
                          : hexaCodeToColor(AppColors.whiteHexaColor),
                      ),
                      child: QrImageView(
                        data: addr ?? pro.getSdkImpl.getSELAddress,
                        version: QrVersions.auto,
                        size: 200.0,
                        embeddedImage: Image.asset('assets/logo/embed-qr.png').image,
                        // eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.circle),
                        // dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle),
                      ),
                    ),
                  );
                }
              ),
        
              if(addr != null) 
              Container(
                margin: const EdgeInsets.all(paddingSize),
                child: MyTextConstant(
                  text: addr,
                  color2: hexaCodeToColor(AppColors.darkGrey),
                  fontSize: 16,
                ),
              )
                
              else Consumer<SDKProvider>(
                builder: (context, pro, wg) {
                  return Container(
                    margin: const EdgeInsets.all(paddingSize),
                    child: MyTextConstant(
                      text: pro.getSdkImpl.getSELAddress,
                      color2: hexaCodeToColor(AppColors.darkGrey),
                      fontSize: 16,
                    ),
                  );
                }
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

Widget _optionBtn(BuildContext context, ReceiveUcImpl receiveImpl, String? addr) {

  print("addr ${addr ?? 'null'}");
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
              onPressed: () async {
                // print(Provider.of<SDKProvider>(context, listen: false).getSdkImpl.evmAddress);
                await receiveImpl.copyAddress(addr ?? Provider.of<SDKProvider>(context, listen: false).getSdkImpl.getSELAddress);
              },
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
              onPressed: () async {
                await receiveImpl.shareAddress(addr ?? Provider.of<SDKProvider>(context, listen: false).getSdkImpl.getSELAddress);
              },
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