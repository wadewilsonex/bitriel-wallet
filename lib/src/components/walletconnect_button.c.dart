import 'package:wallet_apps/index.dart';

class WalletConnectMenuItem extends StatelessWidget {
  final String? title;
  final Function? action;
  final String? image;
  
  const WalletConnectMenuItem({Key? key, 
    this.title,
    @required this.action,
    this.image,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          action!();
        },
        child: Container(
          // width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 48.0,
                offset: const Offset(0.0, 2)
              )
            ],
            borderRadius: BorderRadius.circular(8),
            color: hexaCodeToColor(isDarkMode ? AppColors.defiMenuItem : AppColors.whiteHexaColor)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(image!),
                    )
                  )
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(2.0),
                child: MyText(
                  text: title,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}