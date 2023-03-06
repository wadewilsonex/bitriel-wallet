import 'package:wallet_apps/index.dart';

class BodyMultipleWallets extends StatelessWidget {
  const BodyMultipleWallets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left_2,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 30
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkCard : AppColors.whiteHexaColor).withOpacity(0),
        title: MyText(text: 'Wallets', fontSize: 20, hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor, fontWeight: FontWeight.bold,),
      ),
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 3),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    Transition(
                      child: Account(walletName: 'Wallet $index'),
                      transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                    )
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xff764abc),
                      child: MyText(text: "W", color2: Colors.white,),
                    ),
                    title: MyText(text: 'Wallet $index', fontSize: 18, fontWeight: FontWeight.bold, textAlign: TextAlign.start,),
                    trailing: Icon(Iconsax.arrow_right_3, color: hexaCodeToColor(AppColors.primaryColor), size: 30,),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: MyGradientButton(
        edgeMargin: const EdgeInsets.all(paddingSize),
        textButton: "Add Wallet",
        fontWeight: FontWeight.w400,
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        action: () async {
         
        },
      ),
    );
  }
}