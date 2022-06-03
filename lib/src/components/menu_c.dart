/* The components file has custom widgets which are used by multiple different screens */

import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/shimmer_c.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: hexaCodeToColor("#114463"),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
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
                  child: AvatarShimmer(
                    txt: acc.addressIcon,
                    child: SvgPicture.string(acc.addressIcon!)
                  )
                ),
                  
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    TextShimmer(txt: acc.name),
                    
                    WidgetShimmer(
                      txt: acc.address, 
                      child: Row(
                        children: [
                          
                          MyText(
                            right: 5,
                            text: acc.address!.replaceRange(5, acc.address!.length - 5, "....."),
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
      // color: isDarkTheme
      //   ? hexaCodeToColor(AppColors.whiteColorHexa).withOpacity(0.06)
      //   : Colors.grey[200],
      height: 55,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: MyText(
                  fontSize: 16,
                  text: MenuModel.listTile[index!]['title'].toString(),
                  color: "#D4D6E3",
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: hexaCodeToColor("#D4D6E3"),
                  indent: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyListTile extends StatelessWidget {
  final Widget? icon;
  final void Function()? onTap;
  final int? index;
  final int? subIndex;
  final Widget? trailing;
  final bool? enable;

  const MyListTile({
    this.icon,
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
      // contentPadding: const EdgeInsets.only(left: 30),
      enabled: enable!,
      onTap: onTap,
      leading: icon ?? SvgPicture.asset(
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
