/* The components file has custom widgets which are used by multiple different screens */

import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MenuHeader extends StatelessWidget {
  
  final Map<String, dynamic>? userInfo;

  const MenuHeader({this.userInfo});

  @override
  Widget build(BuildContext context) {

    final acc = Provider.of<ApiProvider>(context).accountM;
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

    return Container(
      margin: const EdgeInsets.only(left: 16),
      child: SizedBox(
        height: 138,
        child: Consumer<ApiProvider>(
          builder: (context, value, child) {
            return Row(
              children: [
                
                InkWell(
                  onTap: acc.address == null ? null : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Account())
                    );
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: acc.addressIcon == null 
                    ? Shimmer.fromColors(
                      child: Container(
                        width: 60,
                        height: 60,
                        margin: EdgeInsets.only(bottom: 3),
                        decoration: BoxDecoration(
                          color: isDarkTheme
                            ? hexaCodeToColor(AppColors.whiteHexaColor)
                            : Colors.grey.shade400,
                          shape: BoxShape.circle,
                        ),
                      ), 
                      period: const Duration(seconds: 2),
                      baseColor: isDarkTheme
                        ? hexaCodeToColor(AppColors.darkCard)
                        : Colors.grey[300]!,
                      highlightColor: isDarkTheme
                        ? hexaCodeToColor(AppColors.darkBgd)
                        : Colors.grey[100]!,
                    ) 
                    : Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: isDarkTheme
                          ? hexaCodeToColor(AppColors.whiteHexaColor)
                          : Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.string(acc.addressIcon!),
                    ),
                  ),
                ),
                  
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    acc.name != null 
                    ? MyText(
                      bottom: 3,
                      text: acc.name ?? '',
                      color: isDarkTheme
                        ? AppColors.whiteColorHexa
                        : AppColors.textColor,
                      fontSize: 16,
                    ) 
                    : Shimmer.fromColors(
                      child: Container(
                        width: 100,
                        height: 8.0,
                        margin: EdgeInsets.only(bottom: 3),
                        color: Colors.white,
                      ), 
                      period: const Duration(seconds: 2),
                      baseColor: isDarkTheme
                        ? hexaCodeToColor(AppColors.darkCard)
                        : Colors.grey[300]!,
                      highlightColor: isDarkTheme
                        ? hexaCodeToColor(AppColors.darkBgd)
                        : Colors.grey[100]!,
                    ),
                    
                    acc.address != null
                    ? Row(
                      children: [
                        MyText(
                          right: 5,
                          text: acc.address!.replaceRange( 5, acc.address!.length - 5, "....."),
                          color: isDarkTheme
                            ? AppColors.whiteColorHexa
                            : AppColors.textColor,
                          fontSize: 16,
                          textAlign: TextAlign.left
                        ),
                        InkWell(
                          onTap: () async {
                            await Clipboard.setData(
                              ClipboardData(text: acc.address!),
                            );
                            Fluttertoast.showToast(
                              msg: "Copied address",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                          }, 
                          child: SvgPicture.asset(
                            AppConfig.iconsPath+'qr_code.svg',
                            width: 20,
                            height: 20,
                            color: hexaCodeToColor(AppColors.secondary),
                          )
                        )
                      ]
                    )
                    : Shimmer.fromColors(
                      child: Container(
                        width: 150,
                        height: 8.0,
                        color: Colors.white,
                      ), 
                      period: const Duration(seconds: 2),
                      baseColor: isDarkTheme
                        ? hexaCodeToColor(AppColors.darkCard)
                        : Colors.grey[300]!,
                      highlightColor: isDarkTheme
                        ? hexaCodeToColor(AppColors.darkBgd)
                        : Colors.grey[100]!,
                    )
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class MenuSubTitle extends StatelessWidget {
  final int? index;

  const MenuSubTitle({this.index});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Container(
      padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 8),
      color: isDarkTheme
        ? hexaCodeToColor(AppColors.whiteColorHexa).withOpacity(0.06)
        : Colors.grey[200],
      height: 55,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: MyText(
              fontSize: 16,
              text: MenuModel.listTile[index!]['title'].toString(),
              color: AppColors.secondarytext,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}

class MyListTile extends StatelessWidget {
  final void Function()? onTap;
  final int? index;
  final int? subIndex;
  final Widget? trailing;
  final bool? enable;

  const MyListTile({
    @required this.index,
    @required this.subIndex,
    this.enable = true,
    this.trailing,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 30),
      enabled: enable!,
      onTap: onTap,
      leading: SvgPicture.asset(
        MenuModel.listTile[index!]['sub'][subIndex]['icon'].toString(),
        color: isDarkTheme ? Colors.white : Colors.black,
        width: 30,
        height: 30
      ),
      title: MyText(
        text: MenuModel.listTile[index!]['sub'][subIndex]['subTitle'].toString(),
        color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
        textAlign: TextAlign.left,
        fontSize: 16,
      ),
      trailing: trailing,
    );
  }
}

// Widget customListTile(
//     BuildContext context, IconData icon, String title, dynamic method,
//     {bool maintenance = false}) {
//   return Container(
//     padding: EdgeInsets.only(left: 19.0, right: 19.0),
//     decoration: BoxDecoration(
//         border: Border(
//             top: BorderSide(width: 1, color: Colors.white.withOpacity(0.2)))),
//     child: ListTile(
//         contentPadding: EdgeInsets.all(0),
//         leading: Container(
//           padding: EdgeInsets.all(0),
//           // child: FaIcon(
//           //   icon,
//           //   color: Colors.white
//           // ),
//         ),
//         title: Text(
//           title,
//           style: TextStyle(
//               fontWeight: FontWeight.w400, color: hexaCodeToColor("#EFF0F2")),
//         ),
//         trailing: Icon(
//           Icons.arrow_forward_ios,
//           size: 10.0,
//           color: Colors.white,
//         ),
//         onTap: !maintenance
//             ? method
//             : () async {
//                 await dialog(
//                     context,
//                     Text("Feature under maintenance",
//                         textAlign: TextAlign.center),
//                     Text("Message"));
//               }),
//   );
// }
