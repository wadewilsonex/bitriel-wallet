import 'package:bitriel_wallet/index.dart';

PreferredSizeWidget appBar(final BuildContext context, {required final String title}) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: hexaCodeToColor(AppColors.background),
    title: MyTextConstant(
      text: title,
      fontSize: 26,
      color2: hexaCodeToColor(AppColors.midNightBlue),
      fontWeight: FontWeight.w600,
    ),
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Iconsax.arrow_left_2,
        size: 30,
        color: hexaCodeToColor(AppColors.midNightBlue),
      ),
    ),
  );
}


PreferredSizeWidget defaultAppBar({
  required BuildContext? context,
}) {

  const appBarHeight = 80.0;

  return AppBar(
    scrolledUnderElevation: 0,
    elevation: 0,
    backgroundColor: hexaCodeToColor(AppColors.white),
    automaticallyImplyLeading: false,
    toolbarHeight: appBarHeight,
    centerTitle: true,
    flexibleSpace: SafeArea(
      child: Container(
        width: MediaQuery.of(context!).size.width,
        margin: const EdgeInsets.only(left: 14, right: 14, top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          color: hexaCodeToColor("#8ECAE6").withOpacity(0.20)
        ),
      ),
    ),
    
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MultiAccountScreen()) 
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                height: 40,
                width: 40,
                child: RandomAvatar("Allen"),
              ),
            )
          ),
        ),

        const Spacer(),
        
        GestureDetector(
          onTap: () async {
            bottomSheetCgNetwork(context);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 5),
                child: MyTextConstant(
                  text: "seF4221ffg.......d2213f4fsad",
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                  color2: hexaCodeToColor(AppColors.midNightBlue),
                  fontSize: 15,
                ),
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  MyTextConstant(
                    text: "SELENDRA", 
                    color2: hexaCodeToColor(AppColors.darkGrey), 
                    fontSize: 12,
                  ),

                    Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      Iconsax.arrow_down_1, 
                      size: 18, 
                      color: hexaCodeToColor(AppColors.midNightBlue),
                    ),
                  )
                ],
              ),

            ],
          )
        ),

        const Spacer(),

        Expanded(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10),
            child: IconButton(
              iconSize: 25,
              icon: Icon(
                Iconsax.scan,
                color: hexaCodeToColor(AppColors.midNightBlue),
              ),
              onPressed: () async {

              },
            ),
          ),
        ),
      ],
    )
  );
}


void bottomSheetCgNetwork(BuildContext context) async{
  
  return showModalBottomSheet(
    backgroundColor: hexaCodeToColor(AppColors.white),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    ),
    context: context,
    builder: (setBuildContext) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyTextConstant(
                    text: "Networks",
                    fontSize: 18,
                    color2: hexaCodeToColor(AppColors.midNightBlue),
                    fontWeight: FontWeight.w600,
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Iconsax.close_circle, 
                      color: hexaCodeToColor(AppColors.midNightBlue),
                    )
                  )
                ],
              ),
            ),

            // Network RPC 0
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: hexaCodeToColor(AppColors.primary),
                )
              ),
              height: 60,
              child: Row(
                mainAxisSize: MainAxisSize.min, 
                children: <Widget>[

                  const SizedBox(width: 10),

                  SizedBox(
                    height: 40,
                    width: 40,
                    child: RandomAvatar("Allen"),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        MyTextConstant(
                          text: "Selendra via Endpoint 0",
                          color2: hexaCodeToColor(AppColors.midNightBlue),
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),

                        const MyTextConstant(
                          text: "wss://rpc0.selendra.org",
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  )
                ]
              ),
            ),

            const SizedBox(height: 10),

            // Network RPC 1
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: hexaCodeToColor(AppColors.primary),
                )
              ),
              height: 60,
              child: Row(
                mainAxisSize: MainAxisSize.min, 
                children: <Widget>[

                  const SizedBox(width: 10),

                  SizedBox(
                    height: 40,
                    width: 40,
                    child: RandomAvatar("Allens"),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        MyTextConstant(
                          text: "Selendra via Endpoint 1",
                          color2: hexaCodeToColor(AppColors.midNightBlue),
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),

                        const MyTextConstant(
                          text: "wss://rpc1.selendra.org",
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  )
                ]
              ),
            ),

          
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: MyGradientButton(
                textButton: "Switch Network",
                action: () async{
                  Navigator.of(context).pop();
                },
              ),
            ),

          ],
        ),
      );
    }
  );
}