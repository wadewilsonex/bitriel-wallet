import 'package:wallet_apps/index.dart';

PreferredSizeWidget eventAppBar({
  required BuildContext? context,
  required String? title
}) {
  return AppBar(
    foregroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg).withOpacity(0),
    backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg).withOpacity(0),
    elevation: 0,
    toolbarHeight: 7,
    // leadingWidth: 15,
    automaticallyImplyLeading: false,
    titleSpacing: 0,
    // centerTitle: true,
    flexibleSpace: SafeArea(
      child: InkWell(
        onTap: (){
          Navigator.pop(context!);
        },
        child: Container(
          alignment: Alignment.centerLeft,
          width: 20,
          margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
          // padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: hexaCodeToColor("#E6E6E6")),
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            color: hexaCodeToColor("#413B3B")
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back_ios_new, color: hexaCodeToColor(AppColors.whiteHexaColor), size: 4,),
              MyText(left: 10, text: title, color2: Colors.white, fontWeight: FontWeight.w700,)
            ],
          ),
        ),
      ),
    ),
  );
}